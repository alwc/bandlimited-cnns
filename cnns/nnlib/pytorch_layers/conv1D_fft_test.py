import logging
import unittest

import numpy as np
import torch
from torch import tensor

from cnns.nnlib.layers import conv_backward_naive_1D
from cnns.nnlib.layers import conv_forward_naive_1D
from cnns.nnlib.pytorch_layers.conv1D_fft \
    import Conv1DfftFunction, Conv1DfftAutograd, Conv1Dfft
from cnns.nnlib.pytorch_layers.pytorch_utils import MockContext
from cnns.nnlib.utils.log_utils import get_logger
from cnns.nnlib.utils.log_utils import set_up_logging

ERR_MSG = "Expected x is different from computed y."


class TestPyTorchConv1d(unittest.TestCase):

    def setUp(self):
        log_file = "pytorch_conv1D_reuse_map_fft.log"
        is_debug = True
        set_up_logging(log_file=log_file, is_debug=is_debug)
        self.logger = get_logger(name=__name__)
        self.logger.setLevel(logging.DEBUG)
        self.logger.info("Set up test")

    def test_FunctionForwardNoCompression(self):
        x = np.array([[[1., 2., 3.]]])
        y = np.array([[[2., 1.]]])
        b = np.array([0.0])
        # get the expected results from numpy correlate
        expected_result = np.correlate(x[0, 0, :], y[0, 0, :], mode="valid")
        conv = Conv1Dfft(filter_value=torch.from_numpy(y),
                         bias_value=torch.from_numpy(b))
        result = conv.forward(input=torch.from_numpy(x))
        np.testing.assert_array_almost_equal(
            result, np.array([[expected_result]]))

    def test_FunctionForwardCompression(self):
        x = np.array([[[1., 2., 3., 4., 5., 6., 7., 8.]]])
        y = np.array([[[2., 1.]]])
        b = np.array([0.0])
        # get the expected results from numpy correlate
        expected_result = np.array(
            [[[4.25, 6.75, 10.25, 12.75, 16.25, 18.75, 22.25]]])
        conv = Conv1Dfft(filter_value=torch.from_numpy(y),
                         bias_value=torch.from_numpy(b), index_back=1)
        result = conv.forward(input=torch.from_numpy(x))
        np.testing.assert_array_almost_equal(
            x=np.array(expected_result), y=result,
            err_msg="Expected x is different from computed y.")

    def test_FunctionForwardSpectralPooling(self):
        x = np.array([[[1., 2., 3., 4., 5., 6., 7., 8.]]])
        y = np.array([[[2., 1.]]])
        b = np.array([0.0])
        # get the expected results from numpy correlate
        expected_result = np.array(
            [[[2.771341, 5.15668, 9.354594, 14.419427]]])
        conv = Conv1Dfft(filter_value=torch.from_numpy(y),
                         bias_value=torch.from_numpy(b), out_size=4)
        result = conv.forward(input=torch.from_numpy(x))
        np.testing.assert_array_almost_equal(
            x=np.array(expected_result), y=result,
            err_msg="Expected x is different from computed y.")

    def test_FunctionForwardNoCompressionManySignalsOneChannel(self):
        x = np.array([[[1., -1., 0.]], [[1., 2., 3.]]])
        y = np.array([[[-2.0, 3.0]]])
        b = np.array([0.0])
        # get the expected result
        conv_param = {'pad': 0, 'stride': 1}
        expected_result, _ = conv_forward_naive_1D(x, y, b,
                                                   conv_param)
        self.logger.debug("expected result: " + str(expected_result))

        conv = Conv1DfftFunction()
        result = conv.forward(ctx=None, input=torch.from_numpy(x),
                              filter=torch.from_numpy(y),
                              bias=torch.from_numpy(b))
        self.logger.debug("obtained result: " + str(result))
        np.testing.assert_array_almost_equal(
            result, np.array(expected_result))

    def test_FunctionForwardNoCompressionManySignalsOneFilterTwoChannels(self):
        x = np.array([[[1., 2., 3.], [4., 5., 6.]],
                      [[1., -1., 0.], [2., 5., 6.]]])
        y = np.array([[[0.0, 1.0], [-1.0, -1.0]]])
        b = np.array([0.0])
        # get the expected result
        conv_param = {'pad': 0, 'stride': 1}
        expected_result, _ = conv_forward_naive_1D(x, y, b,
                                                   conv_param)
        self.logger.debug("expected result: " + str(expected_result))

        conv = Conv1DfftFunction()
        result = conv.forward(ctx=None, input=torch.from_numpy(x),
                              filter=torch.from_numpy(y),
                              bias=torch.from_numpy(b))
        self.logger.debug("obtained result: " + str(result))
        np.testing.assert_array_almost_equal(
            result, np.array(expected_result))

    def test_FunctionForwardNoCompression2Signals2Filters2Channels(self):
        x = np.array(
            [[[1., 2., 3.], [4., 5., 6.]], [[1., -1., 0.], [2., 5., 6.]]])
        y = np.array([[[2., 1.], [1., 3.]], [[0.0, 1.0], [-1.0, -1.0]]])
        b = np.array([1.0, 1.0])
        # get the expected result
        conv_param = {'pad': 0, 'stride': 1}
        expected_result, _ = conv_forward_naive_1D(x, y, b,
                                                   conv_param)
        self.logger.debug("expected result: " + str(expected_result))

        conv = Conv1DfftFunction()
        result = conv.forward(ctx=None, input=torch.from_numpy(x),
                              filter=torch.from_numpy(y),
                              bias=torch.from_numpy(b))
        self.logger.debug("obtained result: " + str(result))
        np.testing.assert_array_almost_equal(
            result, np.array(expected_result))

    def test_FunctionForwardRandom(self):
        num_channels = 3
        num_data_points = 11
        num_values_data = 21
        num_values_filter = 5
        num_filters = 3
        # Input signal: 5 data points, 3 channels, 10 values.
        x = np.random.rand(num_data_points, num_channels, num_values_data)
        # Filters: 3 filters, 3 channels, 4 values.
        y = np.random.rand(num_filters, num_channels, num_values_filter)
        # Bias: one for each filter
        b = np.random.rand(num_filters)
        # get the expected result
        conv_param = {'pad': 0, 'stride': 1}
        expected_result, _ = conv_forward_naive_1D(x, y, b, conv_param)
        self.logger.debug("expected result: " + str(expected_result))

        conv = Conv1DfftFunction()
        result = conv.forward(ctx=None, input=torch.from_numpy(x),
                              filter=torch.from_numpy(y),
                              bias=torch.from_numpy(b))
        self.logger.debug("obtained result: " + str(result))
        np.testing.assert_array_almost_equal(
            result, np.array(expected_result))

    def test_FunctionBackwardNoCompressionWithBias(self):
        x = np.array([[[1.0, 2.0, 3.0]]])
        y = np.array([[[2.0, 1.0]]])
        b = np.array([2.0])
        dtype = torch.float
        x_torch = tensor(x, requires_grad=True, dtype=dtype)
        y_torch = tensor(y, requires_grad=True, dtype=dtype)
        b_torch = tensor(b, requires_grad=True, dtype=dtype)

        conv_param = {'pad': 0, 'stride': 1}
        expected_result, cache = conv_forward_naive_1D(x, y, b,
                                                       conv_param)
        ctx = MockContext()
        ctx.set_needs_input_grad(3)
        result_torch = Conv1DfftFunction.forward(
            ctx, input=x_torch, filter=y_torch, bias=b_torch)
        result = result_torch.detach().numpy()
        np.testing.assert_array_almost_equal(
            result, np.array(expected_result))

        dout = tensor([[[0.1, -0.2]]], dtype=dtype)
        # get the expected result from the backward pass
        expected_dx, expected_dw, expected_db = \
            conv_backward_naive_1D(dout.numpy(), cache)

        dx, dw, db, _, _, _, _, _, _, _ = Conv1DfftFunction.backward(ctx, dout)

        self.logger.debug("expected dx: " + str(expected_dx))
        self.logger.debug("computed dx: " + str(dx))

        # are the gradients correct
        np.testing.assert_array_almost_equal(dx.detach().numpy(),
                                             expected_dx)
        np.testing.assert_array_almost_equal(dw.detach().numpy(),
                                             expected_dw)
        np.testing.assert_array_almost_equal(db.detach().numpy(),
                                             expected_db)

    def test_FunctionBackwardNoCompressionWithBias2Inputs(self):
        x = np.array([[[1.0, 2.0, 3.0]], [[2.0, -1.0, 3.0]]])
        # Number of filters F, number of channels C, number of values WW.
        y = np.array([[[2.0, 1.0]]])
        b = np.array([2.0])
        dtype = torch.float
        x_torch = tensor(x, requires_grad=True, dtype=dtype)
        y_torch = tensor(y, requires_grad=True, dtype=dtype)
        b_torch = tensor(b, requires_grad=True, dtype=dtype)

        conv_param = {'pad': 0, 'stride': 1}
        expected_result, cache = conv_forward_naive_1D(x, y, b, conv_param)
        ctx = MockContext()
        ctx.set_needs_input_grad(3)
        result_torch = Conv1DfftFunction.forward(
            ctx, input=x_torch, filter=y_torch, bias=b_torch)
        result = result_torch.detach().numpy()
        np.testing.assert_array_almost_equal(result, np.array(expected_result))

        dout = tensor([[[0.1, -0.2]], [[0.2, -0.1]]], dtype=dtype)
        # get the expected result from the backward pass
        expected_dx, expected_dw, expected_db = \
            conv_backward_naive_1D(dout.numpy(), cache)

        print("expected_dx: ", expected_dx)
        print("expected_dw: ", expected_dw)
        print("expected_db: ", expected_db)

        dx, dw, db, _, _, _, _, _, _, _ = Conv1DfftFunction.backward(ctx,
                                                                     dout)

        # are the gradients correct
        np.testing.assert_array_almost_equal(
            x=expected_dx, y=dx.detach().numpy(),
            err_msg="Expected x is different from computed y.")
        np.testing.assert_array_almost_equal(
            x=expected_dw, y=dw.detach().numpy(),
            err_msg="Expected x is different from computed y.")
        np.testing.assert_array_almost_equal(db.detach().numpy(),
                                             expected_db)

    def test_FunctionBackwardNoCompressionWithBias2Filters(self):
        x = np.array([[[1.0, 2.0, 3.0]]])
        # Number of filters F, number of channels C, number of values WW.
        y = np.array([[[2.0, 1.0]], [[-0.1, 0.3]]])
        b = np.array([2.0, 1.0])  # 2 filters => 2 bias terms
        dtype = torch.float
        x_torch = tensor(x, requires_grad=True, dtype=dtype)
        y_torch = tensor(y, requires_grad=True, dtype=dtype)
        b_torch = tensor(b, requires_grad=True, dtype=dtype)

        conv_param = {'pad': 0, 'stride': 1}
        expected_result, cache = conv_forward_naive_1D(x, y, b, conv_param)
        ctx = MockContext()
        ctx.set_needs_input_grad(3)
        result_torch = Conv1DfftFunction.forward(
            ctx, input=x_torch, filter=y_torch, bias=b_torch)
        result = result_torch.detach().numpy()
        np.testing.assert_array_almost_equal(result, np.array(expected_result))

        dout = tensor([[[0.1, -0.2], [0.2, -0.1]]], dtype=dtype)
        # get the expected result from the backward pass
        expected_dx, expected_dw, expected_db = \
            conv_backward_naive_1D(dout.numpy(), cache)

        print("expected_dx: ", expected_dx)
        print("expected_dw: ", expected_dw)
        print("expected_db: ", expected_db)

        dx, dw, db, _, _, _, _, _, _, _ = Conv1DfftFunction.backward(ctx, dout)

        # are the gradients correct
        np.testing.assert_array_almost_equal(
            x=expected_dx, y=dx.detach().numpy(),
            err_msg="Expected x is different from computed y.")
        np.testing.assert_array_almost_equal(
            x=expected_dw, y=dw.detach().numpy(),
            err_msg="Expected x is different from computed y.")
        np.testing.assert_array_almost_equal(db.detach().numpy(),
                                             expected_db)

    def test_FunctionBackwardNoCompressionNoBias(self):
        print()
        print("Test forward and backward manual passes.")
        x = np.array([[[1.0, 2.0, 3.0]]])
        y = np.array([[[2.0, 1.0]]])
        b = np.array([0.0])
        dtype = torch.float
        x_torch = tensor(x, requires_grad=True, dtype=dtype)
        y_torch = tensor(y, requires_grad=True, dtype=dtype)
        b_torch = tensor(b, requires_grad=True, dtype=dtype)

        conv_param = {'pad': 0, 'stride': 1}
        expected_result, cache = conv_forward_naive_1D(x=x, w=y, b=b,
                                                       conv_param=conv_param)

        result_torch = Conv1DfftFunction.apply(x_torch, y_torch, b_torch)
        result = result_torch.detach().numpy()
        np.testing.assert_array_almost_equal(
            result, np.array(expected_result))

        dout = tensor([[[0.1, -0.2]]], dtype=dtype)
        # get the expected result from the backward pass
        expected_dx, expected_dw, expected_db = \
            conv_backward_naive_1D(dout.numpy(), cache)

        result_torch.backward(dout)

        # are the gradients correct
        np.testing.assert_array_almost_equal(x_torch.grad,
                                             expected_dx)
        np.testing.assert_array_almost_equal(y_torch.grad,
                                             expected_dw)
        np.testing.assert_array_almost_equal(b_torch.grad,
                                             expected_db)

    def test_FunctionBackwardNoCompressionNoBiasLonger(self):
        print()
        print("Test forward and backward manual passes.")
        x = np.array([[[1.0, 2.0, 3.0, 4.0, 5.0, -1.0, 3.0]]])
        y = np.array([[[2.0, 1.0, -2.0]]])
        b = np.array([0.0])
        dtype = torch.float
        x_torch = tensor(x, requires_grad=True, dtype=dtype)
        y_torch = tensor(y, requires_grad=True, dtype=dtype)
        b_torch = tensor(b, requires_grad=True, dtype=dtype)

        conv_param = {'pad': 0, 'stride': 1}
        expected_result, cache = conv_forward_naive_1D(x=x, w=y, b=b,
                                                       conv_param=conv_param)

        print("expected result out for the forward pass: ", expected_result)

        result_torch = Conv1DfftFunction.apply(x_torch, y_torch, b_torch)
        result = result_torch.detach().numpy()
        np.testing.assert_array_almost_equal(
            result, np.array(expected_result))

        dout = tensor([[[0.1, -0.2, 0.3, -0.1, 0.4]]], dtype=dtype)
        # get the expected result from the backward pass
        expected_dx, expected_dw, expected_db = \
            conv_backward_naive_1D(dout.numpy(), cache)

        print("expected_dx: ", expected_dx)
        print("expected_dw: ", expected_dw)
        print("expected_db: ", expected_db)

        result_torch.backward(dout)

        # are the gradients correct
        np.testing.assert_array_almost_equal(x=expected_dx, y=x_torch.grad,
                                             err_msg=ERR_MSG)
        np.testing.assert_array_almost_equal(x=expected_dw, y=y_torch.grad,
                                             err_msg=ERR_MSG)
        np.testing.assert_array_almost_equal(x=expected_db, y=b_torch.grad,
                                             err_msg=ERR_MSG)

    def test_FunctionBackwardWithPooling(self):
        x = np.array([[[1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, -2.0]]])
        y = np.array([[[2.0, 1.0, 3.0, 1.0, -3.0]]])
        b = np.array([0.0])
        dtype = torch.float
        x_torch = tensor(x, requires_grad=True, dtype=dtype)
        y_torch = tensor(y, requires_grad=True, dtype=dtype)
        b_torch = tensor(b, requires_grad=True, dtype=dtype)

        conv_param = {'pad': 0, 'stride': 1}
        accurate_expected_result, cache = conv_forward_naive_1D(
            x=x, w=y, b=b, conv_param=conv_param)
        print("Accurate expected result: ", accurate_expected_result)

        # approximate_expected_result = np.array(
        #     [[[-2.105834, 0.457627, 8.501472, 20.74531]]])
        approximate_expected_result = np.array(
            [[[6.146684, 11.792807, 17.264324, 21.90055]]])
        print("Approximate expected result: ", approximate_expected_result)

        out_size = approximate_expected_result.shape[-1]

        result_torch = Conv1DfftFunction.apply(
            x_torch, y_torch, b_torch, None, None, None, out_size, 1, True)
        result = result_torch.detach().numpy()
        print("Computed result: ", result)
        np.testing.assert_array_almost_equal(
            x=np.array(approximate_expected_result), y=result,
            err_msg="Expected x is different from computed y.")

        self._check_delta1D(actual_result=result,
                            accurate_expected_result=accurate_expected_result,
                            delta=8.1)

        dout = tensor([[[0.1, -0.2, 0.3, -0.1]]], dtype=dtype)
        # get the expected result from the backward pass
        expected_dx, expected_dw, expected_db = \
            conv_backward_naive_1D(dout.numpy(), cache)

        result_torch.backward(dout)

        # approximate_expected_dx = np.array(
        #     [[[0.052956, 0.120672, 0.161284, 0.150332, 0.089258,
        #        0.005318, -0.063087, -0.087266, -0.063311, -0.012829]]])
        approximate_expected_dx = np.array(
            [[[0.069143, 0.073756, 0.072217, 0.064673, 0.052066,
               0.035999, 0.018504, 0.001745, -0.012286, -0.022057]]])

        # are the gradients correct
        np.testing.assert_array_almost_equal(
            x=approximate_expected_dx, y=x_torch.grad,
            err_msg="Expected x is different from computed y.")

        self._check_delta1D(actual_result=x_torch.grad,
                            accurate_expected_result=expected_dx, delta=1.1)

        # approximate_expected_dw = np.array(
        #     [[[0.129913, 0.249468, 0.429712, 0.620098, 0.748242]]])
        approximate_expected_dw = np.array(
            [[[0.287457, 0.391437, 0.479054, 0.539719, 0.565961]]])
        np.testing.assert_array_almost_equal(
            x=approximate_expected_dw, y=y_torch.grad,
            err_msg="Expected x is different from computed y.")

        self._check_delta1D(actual_result=y_torch.grad,
                            accurate_expected_result=expected_dw, delta=0.2)

        np.testing.assert_array_almost_equal(b_torch.grad,
                                             expected_db)

    def _check_delta1D(self, actual_result, accurate_expected_result, delta):
        """
        Compare if the difference between the two objects is more than the
        given delta.

        :param actual_result: the computed result
        :param accurate_expected_result: the expected accurate result
        :param delta: compare if that the difference between the two objects
        is more than the given delta
        """
        print("actual_result: {}".format(actual_result))
        print("accurate_expected_result: {}".format(accurate_expected_result))
        result_flat = actual_result[0][0]
        accurate_expected_flat = accurate_expected_result[0][0]
        for index, item in enumerate(result_flat):
            self.assertAlmostEqual(
                first=accurate_expected_flat[index], second=item, delta=delta,
                msg="The approximate result is not within delta={} of the "
                    "accurate result!".format(delta))

    def test_FunctionBackwardCompressionBias(self):
        x = np.array([[[1.0, 2.0, 3.0, 4.0, 5.0, -1.0, 10.0]]])
        y = np.array([[[2.0, 1.0, -3.0]]])
        b = np.array([1.0])
        dtype = torch.float
        x_torch = tensor(x, requires_grad=True, dtype=dtype)
        y_torch = tensor(y, requires_grad=True, dtype=dtype)
        b_torch = tensor(b, requires_grad=True, dtype=dtype)

        conv_param = {'pad': 0, 'stride': 1}
        expected_result, cache = conv_forward_naive_1D(x=x, w=y, b=b,
                                                       conv_param=conv_param)
        print("expected result: ", expected_result)

        # 1 index back
        conv_fft = Conv1Dfft(filter_value=y_torch, bias_value=b_torch,
                             index_back=1)
        result_torch = conv_fft.forward(input=x_torch)

        result = result_torch.detach().numpy()
        compressed_expected_result = np.array(
            [[[-2.25, -5.75, -2.25, 15.25, -18.25]]])
        # compressed_expected_result = np.array(
        #     [[[-4., -3.999999, -4., 16.999998, -20.]]])
        np.testing.assert_array_almost_equal(
            x=compressed_expected_result, y=result, decimal=2, err_msg=ERR_MSG)

        dout = tensor([[[0.1, -0.2, -0.3, 0.3, 0.1]]], dtype=dtype)
        # get the expected result from the backward pass
        expected_dx, expected_dw, expected_db = \
            conv_backward_naive_1D(dout.numpy(), cache)

        result_torch.backward(dout)
        assert conv_fft.is_manual[0] == 1

        # are the gradients correct
        print("accurate expected_dx: ", expected_dx)
        approximate_dx = np.array(
            [[[0.175, -0.275, -1.125, 0.925, 1.375, -0.775, -0.325]]])
        # approximate_dx = np.array(
        #     [[[0.2, -0.3, -1.1, 0.9, 1.4, -0.8, -0.3]]])
        np.testing.assert_array_almost_equal(
            x=approximate_dx, y=x_torch.grad, decimal=3,
            err_msg="Expected approximate x is different from computed y. The "
                    "exact x (that represents dx) is: {}".format(expected_dx))
        print("accurate expected_dw: ", expected_dw)

        approximate_dw = np.array([[[0.675, -0.375, -1.125]]])
        # approximate_dw = np.array([[[0.5, -0.2, -1.3]]])

        np.testing.assert_array_almost_equal(
            x=approximate_dw, y=y_torch.grad, decimal=3,
            err_msg="Expected approximate x is different from computed y. The "
                    "exact x (that represents dw) is: {}".format(expected_dw))
        np.testing.assert_array_almost_equal(
            x=expected_db, y=b_torch.grad,
            err_msg="Expected approximate x is different from computed y.")

    def test_FunctionBackwardNoCompression2Channels(self):
        x = np.array([[[1.0, 2.0, 3.0], [-1.0, -3.0, 2.0]]])
        y = np.array([[[2.0, 1.0], [-2.0, 3.0]]])
        # still it is only a single filter but with 2 channels
        b = np.array([0.0])
        dtype = torch.float
        x_torch = tensor(x, requires_grad=True, dtype=dtype)
        y_torch = tensor(y, requires_grad=True, dtype=dtype)
        b_torch = tensor(b, requires_grad=True, dtype=dtype)

        conv_param = {'pad': 0, 'stride': 1}
        expected_result, cache = conv_forward_naive_1D(x=x, w=y, b=b,
                                                       conv_param=conv_param)

        result_torch = Conv1DfftFunction.apply(x_torch, y_torch, b_torch)
        result = result_torch.detach().numpy()
        np.testing.assert_array_almost_equal(
            result, np.array(expected_result))

        dout = tensor([[[0.1, -0.2]]], dtype=dtype)
        # get the expected result from the backward pass
        expected_dx, expected_dw, expected_db = \
            conv_backward_naive_1D(dout.numpy(), cache)

        result_torch.backward(dout)

        print()
        print("expected dx: " + str(expected_dx))
        print("computed dx: {}".format(x_torch.grad))

        print("expected dw: {}".format(expected_dw))
        print("computed dw: {}".format(y_torch.grad))

        # self.logger.debug("expected db: ", expected_db)
        # self.logger.debug("computed db: ", b_torch.grad)

        # Are the gradients correct?
        np.testing.assert_array_almost_equal(x=expected_dx, y=x_torch.grad,
                                             err_msg=ERR_MSG)
        np.testing.assert_array_almost_equal(x=expected_dw, y=y_torch.grad,
                                             err_msg=ERR_MSG)
        np.testing.assert_array_almost_equal(x=expected_db, y=b_torch.grad,
                                             err_msg=ERR_MSG)

    def test_FunctionForwardWithCompression(self):
        # test with compression
        x = np.array([[[1., 2., 3.]]])
        y = np.array([[[2., 1.]]])
        b = np.array([0.0])
        expected_result = [[[3.75, 7.25]]]
        conv = Conv1DfftFunction()
        result = conv.forward(
            ctx=None, input=torch.from_numpy(x), index_back=1,
            filter=torch.from_numpy(y), bias=torch.from_numpy(b))
        np.testing.assert_array_almost_equal(result, np.array(expected_result))

    def test_AutogradForwardNoCompression(self):
        x = np.array([[[1., 2., 3.]]])
        y = np.array([[[2., 1.]]])
        b = np.array([0.0])
        # get the expected results from numpy correlate
        expected_result = np.correlate(x[0, 0, :], y[0, 0, :], mode="valid")
        conv = Conv1DfftAutograd(filter_value=torch.from_numpy(y),
                                 bias_value=torch.from_numpy(b))
        result = conv.forward(input=torch.from_numpy(x))

        np.testing.assert_array_almost_equal(
            result, np.array([[expected_result]]))

    def test_AutogradForwardWithCompression(self):
        # test with compression
        x = np.array([[[1., 2., 3.]]])
        y = np.array([[[2., 1.]]])
        b = np.array([0.0])
        expected_result = [3.75, 7.25]
        conv = Conv1DfftAutograd(
            filter_value=torch.from_numpy(y), bias_value=torch.from_numpy(b),
            index_back=1)
        result = conv.forward(input=torch.from_numpy(x))
        np.testing.assert_array_almost_equal(
            result, np.array([[expected_result]]))

    def test_FunctionForwardBackwardRandomAutoGrad(self):
        print()
        print("Test forward backward passes with random data.")
        num_channels = 3
        num_data_points = 11
        num_values_data = 21
        num_values_filter = 5
        num_filters = 3
        # Input signal: 5 data points, 3 channels, 10 values.
        x = np.random.rand(num_data_points, num_channels, num_values_data)
        # Filters: 3 filters, 3 channels, 4 values.
        y = np.random.rand(num_filters, num_channels, num_values_filter)
        # Bias: one for each filter
        b = np.random.rand(num_filters)
        # get the expected result
        conv_param = {'pad': 0, 'stride': 1}
        expected_result, _ = conv_forward_naive_1D(x=x, w=y, b=b,
                                                   conv_param=conv_param)
        self.logger.debug("expected result: " + str(expected_result))

        dtype = torch.float
        x_torch = tensor(x, requires_grad=True, dtype=dtype)
        y_torch = tensor(y, requires_grad=True, dtype=dtype)
        b_torch = tensor(b, requires_grad=True, dtype=dtype)
        conv = Conv1DfftAutograd(filter_value=y_torch, bias_value=b_torch,
                                 is_manual=tensor([0]))
        result_torch = conv.forward(input=x_torch)
        result = result_torch.detach().numpy()
        self.logger.debug("obtained result: " + str(result))
        np.testing.assert_array_almost_equal(result, np.array(expected_result))

        conv_param = {'pad': 0, 'stride': 1}
        expected_result, cache = conv_forward_naive_1D(x, y, b, conv_param)

        # dout = tensor(result/100.0, dtype=dtype)
        dout = torch.randn(result_torch.shape)
        # get the expected result from the backward pass
        expected_dx, expected_dw, expected_db = \
            conv_backward_naive_1D(dout.numpy(), cache)

        result_torch.backward(dout)

        # Assert that we executed the backward pass via PyTorch's AutoGrad
        # (value is 0) and not manually (for manual grad the value is 1:
        # conv.is_manual[0] == 1).
        assert 0 == conv.is_manual[0]

        # print()
        # print("expected dx: " + str(expected_dx))
        # print("computed dx: {}".format(x_torch.grad))
        #
        # print("expected dw: {}".format(expected_dw))
        # print("computed dw: {}".format(y_torch.grad))
        # self.logger.debug("expected db: ", expected_db)
        # self.logger.debug("computed db: ", b_torch.grad)

        # are the gradients correct
        np.testing.assert_array_almost_equal(
            x=expected_dx, y=x_torch.grad,
            err_msg="Expected x is different from computed y.")
        np.testing.assert_array_almost_equal(
            x=expected_dw, y=y_torch.grad, decimal=4,
            err_msg="Expected x is different from computed y.")
        np.testing.assert_array_almost_equal(
            x=expected_db, y=b_torch.grad, decimal=5,
            err_msg="Expected x is different from computed y.")

    def test_FunctionForwardBackwardRandomManualBackprop(self):
        print()
        print("Test forward backward manual passes with random data.")
        num_channels = 3
        num_data_points = 11
        num_values_data = 21
        num_values_filter = 5
        num_filters = 5
        # Input signal: 5 data points, 3 channels, 10 values.
        x = np.random.rand(num_data_points, num_channels, num_values_data)
        # Filters: 3 filters, 3 channels, 4 values.
        y = np.random.rand(num_filters, num_channels, num_values_filter)
        # Bias: one for each filter
        b = np.random.rand(num_filters)
        # get the expected result
        conv_param = {'pad': 0, 'stride': 1}
        expected_result, _ = conv_forward_naive_1D(x=x, w=y, b=b,
                                                   conv_param=conv_param)
        self.logger.debug("expected result: " + str(expected_result))

        dtype = torch.float
        x_torch = tensor(x, requires_grad=True, dtype=dtype)
        y_torch = tensor(y, requires_grad=True, dtype=dtype)
        b_torch = tensor(b, requires_grad=True, dtype=dtype)
        conv = Conv1Dfft(filter_value=y_torch, bias_value=b_torch)
        result_torch = conv.forward(input=x_torch)
        result = result_torch.detach().numpy()
        self.logger.debug("obtained result: " + str(result))
        np.testing.assert_array_almost_equal(result, np.array(expected_result))

        conv_param = {'pad': 0, 'stride': 1}
        expected_result, cache = conv_forward_naive_1D(x, y, b, conv_param)

        # dout = tensor(result/100.0, dtype=dtype)
        dout = torch.randn(result_torch.shape)
        # get the expected result from the backward pass
        expected_dx, expected_dw, expected_db = \
            conv_backward_naive_1D(dout.numpy(), cache)

        result_torch.backward(dout)

        # Assert that we executed the backward pass manually (value is 1) and
        # not via PyTorch's autograd (for autograd: conv.is_manual[0] == 0).
        assert conv.is_manual[0] == 1

        # print()
        # print("expected dx: " + str(expected_dx))
        # print("computed dx: {}".format(x_torch.grad))
        #
        # print("expected dw: {}".format(expected_dw))
        # print("computed dw: {}".format(y_torch.grad))
        # self.logger.debug("expected db: ", expected_db)
        # self.logger.debug("computed db: ", b_torch.grad)

        # are the gradients correct
        np.testing.assert_array_almost_equal(
            x=expected_dx, y=x_torch.grad, decimal=5,
            err_msg="Expected x is different from computed y.")
        np.testing.assert_array_almost_equal(
            x=expected_dw, y=y_torch.grad, decimal=4,
            err_msg="Expected x is different from computed y.")
        np.testing.assert_array_almost_equal(
            x=expected_db, y=b_torch.grad, decimal=5,
            err_msg="Expected x is different from computed y.")


if __name__ == '__main__':
    unittest.main()
