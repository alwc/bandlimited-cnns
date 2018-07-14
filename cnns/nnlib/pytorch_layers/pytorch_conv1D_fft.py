"""
Custom FFT based convolution that can rely on the autograd
(a tape-based automatic differentiation library that supports
all differentiable Tensor operations in pytorch).
"""
import logging

import numpy as np
import torch
from torch.nn import Module
from torch.nn.functional import pad as torch_pad
from torch.nn.parameter import Parameter

from cnns.nnlib.pytorch_layers.pytorch_utils import correlate_signals
from cnns.nnlib.pytorch_layers.pytorch_utils import next_power2

logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)
consoleLog = logging.StreamHandler()
logger.addHandler(consoleLog)

current_file_name = __file__.split("/")[-1].split(".")[0]


class PyTorchConv1dFunction(torch.autograd.Function):
    """
    Implement the 1D convolution via FFT with compression of the
    input map and the filter.
    """

    @staticmethod
    def forward(ctx, input, filter=None, bias=None, padding=None,
                preserve_energy_rate=None, index_back=None,
                out_size=None, filter_width=None):
        N, C, W = input.size()
        F, C, WW = filter.size()
        fftsize = next_power2(W + WW - 1)
        # pad only the dimensions for the time-series
        # (and neither data points nor the channels)
        padded_x = input
        out_W = W - WW + 1
        if padding is not None:
            padded_x = torch_pad(input, (padding, padding),
                                 'constant', 0)
            out_W += 2 * padding

        if out_size is not None:
            out_W = out_size
            if index_back is not None:
                logger.error(
                    "index_back cannot be set when out_size is used")
                sys.exit(1)
            index_back = len(input) - out_W

        out = torch.empty([N, F, out_W], dtype=input.dtype,
                          device=input.device)
        for nn in range(
                N):  # For each time-series in the input batch.
            for ff in range(F):  # For each filter
                for cc in range(C):  # For each channel (depth)
                    out[nn, ff] += \
                        correlate_signals(padded_x[nn, cc],
                                          filter[ff, cc],
                                          fftsize,
                                          out_size=out_W,
                                          preserve_energy_rate=
                                          preserve_energy_rate,
                                          index_back=index_back)
                    # add the bias term for a given filter
                    out[nn, ff] += bias[ff]

        return out

    @staticmethod
    def backward(ctx, output_grad):
        raise NotImplementedError


class PyTorchConv1dAutograd(Module):
    def __init__(self, filter=None, bias=None, padding=None,
                 preserve_energy_rate=None, index_back=None,
                 out_size=None, filter_width=None):
        """
        1D convolution using FFT implemented fully in PyTorch.

        :param filter_width: the width of the filter
        :param filter: you can provide the initial filter, i.e.
        filter weights of shape (F, C, WW), where
        F - number of filters, C - number of channels, WW - size of
        the filter
        :param bias: you can provide the initial value of the bias,
        of shape (F,)
        :param padding: the padding added to the front and back of
        the input signal
        :param preserve_energy_rate: the energy of the input to the
        convolution (both, the input map and filter) that
        have to be preserved (the final length is the length of the
        longer signal that preserves the set energy rate).
        :param index_back: how many frequency coefficients should be
        discarded
        :param out_size: what is the expected output size of the
        operation (when compression is used and the out_size is
        smaller than the size of the input to the convolution, then
        the max pooling can be omitted and the compression
        in this layer can serve as the frequency-based (spectral)
        pooling.

        Regarding, the stride parameter: the number of pixels between
        adjacent receptive fields in the horizontal and vertical
        directions, it is 1 for the FFT based convolution.
        """
        super(PyTorchConv1dAutograd, self).__init__()
        if filter is None:
            if filter_width is None:
                logger.error(
                    "The filter and filter_width cannot be both "
                    "None, provide one of them!")
                sys.exit(1)
            self.filter = Parameter(torch.randn(1, 1, filter_width))
        else:
            self.filter = filter
        if bias is None:
            self.bias = Parameter(torch.randn(1))
        else:
            self.bias = bias
        self.padding = padding
        self.preserve_energy_rate = preserve_energy_rate
        self.index_back = index_back
        self.out_size = out_size
        self.filter_width = filter_width

    def forward(self, input):
        """
        Forward pass of 1D convolution.

        The input consists of N data points with each data point
        representing a signal (e.g., time-series) of length W.

        We also have the notion of channels in the 1-D convolution.
        We want to use more than a single filter even for
        the input signal, so the output is a batch with the same size
        but the number of output channels is equal to the
        number of input filters.

        :param x: Input data of shape (N, C, W), N - number of data
        points in the batch, C - number of channels, W - the
        width of the signal or time-series (number of data points in
        a univariate series)
        :param w:
        :param b: biases
        :param conv_param: A dictionary with the following keys:
          - 'stride': The number of pixels between adjacent receptive
          fields in the horizontal and vertical directions.
          - 'pad': The number of pixels that will be used to zero-pad
          the input.
        :return: output data, of shape (N, F, W') where W' is given
        by: W' = 1 + (W + 2*pad - WW)

         :see:
         source short: https://goo.gl/GwyhXz
         source full: https://stackoverflow.com/questions/40703751/
         using-fourier-transforms-to-do-convolution?utm_medium=orga
         nic&utm_source=google_rich_qa&utm_campaign=google_rich_qa

        >>> # test with compression
        >>> x = np.array([[[1., 2., 3.]]])
        >>> y = np.array([[[2., 1.]]])
        >>> b = np.array([0.0])
        >>> conv_param = {'pad' : 0, 'stride' :1,
        ... 'preserve_energy_rate' :0.9}
        >>> expected_result = [3.5, 7.5]
        >>> conv = PyTorchConv1d(filter=torch.from_numpy(y),
        ... bias=torch.from_numpy(b),
        ... preserve_energy_rate=conv_param['preserve_energy_rate'])
        >>> result = conv.forward(input=torch.from_numpy(x))
        >>> np.testing.assert_array_almost_equal(result,
        ... np.array([[expected_result]]))

        >>> # test without compression
        >>> x = np.array([[[1., 2., 3.]]])
        >>> y = np.array([[[2., 1.]]])
        >>> b = np.array([0.0])
        >>> conv_param = {'pad' : 0, 'stride' :1}
        >>> dout = np.array([[[0.1, -0.2]]])
        >>> # first, get the expected results from the numpy
        >>> # correlate function
        >>> expected_result = np.correlate(x[0, 0,:], y[0, 0,:],
        ... mode="valid")
        >>> conv = PyTorchConv1d(filter=torch.from_numpy(y),
        ... bias=torch.from_numpy(b))
        >>> result = conv.forward(input=torch.from_numpy(x))
        >>> np.testing.assert_array_almost_equal(result,
        ... np.array([[expected_result]]))
        """
        return PyTorchConv1dFunction.forward(
            ctx=None, input=input, filter=self.filter, bias=self.bias,
            padding=self.padding,
            preserve_energy_rate=self.preserve_energy_rate,
            index_back=self.index_back, out_size=self.out_size,
            filter_width=self.filter_width)


class PyTorchConv1d(PyTorchConv1dAutograd):
    def __init__(self, filter=None, bias=None, padding=None,
                 preserve_energy_rate=None, index_back=None,
                 out_size=None, filter_width=None):
        super(PyTorchConv1d, self).__init__(
            self, filter=filter, bias=bias, padding=padding,
            preserve_energy_rate=preserve_energy_rate,
            index_back=index_back, out_size=out_size,
            filter_width=filter_width)

    def forward(self, input):
        """
        This is the manual implementation of the forward and
        backward passes via the Function.

        :param input: the input map (image)
        :return: the result of 1D convolution
        """
        return PyTorchConv1dFunction.apply(input, self.filter,
                                           self.bias, self.padding,
                                           self.preserve_energy_rate,
                                           self.index_back,
                                           self.out_size,
                                           self.filter_width)


def test_run():
    torch.manual_seed(231)
    module = PyTorchConv1d(3)
    print("filter and bias parameters: ", list(module.parameters()))
    input = torch.randn(1, 1, 10, requires_grad=True)
    output = module(input)
    print("forward output: ", output)
    output.backward(torch.randn(1, 1, 8))
    print("gradient for the input: ", input.grad)


if __name__ == "__main__":
    # test_run()

    import sys
    import doctest

    sys.exit(doctest.testmod()[0])
