from keras.layers.convolutional import Conv2D
from keras.legacy import interfaces
import keras.backend as K
from keras.engine.base_layer import InputSpec
from cnns.nnlib.utils.general_utils import ConvType
from cnns.tensorflow.utils import tensor_shape
from cnns.nnlib.utils.general_utils import next_power2
import tensorflow as tf


def forward_padding(x, kernel, padding, H, W, HH, WW, args=None):
    # Prepare for rfft2d.
    # The 2 most inner dimensions are H, W (channels first).
    # from N, H, W, C -> N, C, H, W
    x = tf.transpose(x, perm=[0, 3, 1, 2])
    # from H, W, C, F -> F, C, H, W
    kernel = tf.transpose(kernel, perm=[3, 2, 0, 1])

    if padding == "same":
        out_H = H
        out_W = W
    elif padding == "valid":
        # The size of the output of the convolution.
        out_H = H - HH + 1
        out_W = W - WW + 1

    HHH = max(out_H, HH)
    WWW = max(out_W, WW)

    # Padding of x to prevent the effects of wrapped-around filter/kernel
    # data.
    init_H_fft = H + (HHH - 1)
    init_W_fft = W + (WWW - 1)

    if args is None or args.next_power2:
        init_H_fft = next_power2(init_H_fft)
        init_W_fft = next_power2(init_W_fft)

    x_pad_H = init_H_fft - H
    x_pad_W = init_W_fft - W

    y_pad_H = init_H_fft - HH
    y_pad_W = init_W_fft - WW

    x = tf.pad(x, [[0, 0], [0, 0], [0, x_pad_H], [0, x_pad_W]])
    kernel = tf.pad(kernel, [[0, 0], [0, 0], [0, y_pad_H], [0, y_pad_W]])

    return x, kernel, out_H, out_W, init_H_fft, init_W_fft


@tf.custom_gradient
def conv_fft_forward(x, kernel, strides, padding, data_format, dilation_rate,
                     args=None):
    print("conv_fft_forward")
    N, H, W, C = tensor_shape(x)
    HH, WW, CC, F = tensor_shape(kernel)
    assert C == CC
    assert H >= HH
    assert W >= WW
    assert strides == (1, 1)
    assert data_format == "channels_last"
    assert dilation_rate == (1, 1)

    x, kernel, out_H, out_W, init_H_fft, init_W_fft = forward_padding(
        x=x, kernel=kernel, padding=padding, H=H, W=W, HH=HH, WW=WW, args=args)

    xfft = tf.signal.rfft2d(x)
    yfft = tf.signal.rfft2d(kernel)

    # from N, C, H, W -> H, W, N, C
    xfft = tf.transpose(xfft, perm=[2, 3, 0, 1])
    # from F, C, H, W -> H, W, F, C
    yfft = tf.transpose(yfft, perm=[2, 3, 1, 0], conjugate=True)

    outfft = tf.linalg.matmul(xfft, yfft)

    # from H, W, N, F -> N, F, H, W
    outfft = tf.transpose(outfft, perm=[2, 3, 0, 1])

    out = tf.signal.irfft2d(outfft)
    out = out[..., :out_H, :out_W]

    # from N, F, H, W -> N, H, W, F (new channel last).
    out = tf.transpose(out, perm=[0, 2, 3, 1])

    def grad(dout):
        return conv_fft_backward(dout)

    return out, grad


def conv_fft_backward(dout):
    print("conv_fft_backward")
    return dout + 2


class Conv2D_fft(tf.keras.layers.Conv2D):
    """2D convolution layer via FFT.

    This layer creates a convolution kernel that is convolved
    with the layer input to produce a tensor of
    outputs. If `use_bias` is True,
    a bias vector is created and added to the outputs. Finally, if
    `activation` is not `None`, it is applied to the outputs as well.

    When using this layer as the first layer in a model,
    provide the keyword argument `input_shape`
    (tuple of integers, does not include the sample axis),
    e.g. `input_shape=(128, 128, 3)` for 128x128 RGB pictures
    in `data_format="channels_last"`.

    # Arguments
        filters: Integer, the dimensionality of the output space
            (i.e. the number of output filters in the convolution).
        kernel_size: An integer or tuple/list of 2 integers, specifying the
            height and width of the 2D convolution window.
            Can be a single integer to specify the same value for
            all spatial dimensions.
        strides: An integer or tuple/list of 2 integers,
            specifying the strides of the convolution
            along the height and width.
            Can be a single integer to specify the same value for
            all spatial dimensions.
            Specifying any stride value != 1 is incompatible with specifying
            any `dilation_rate` value != 1.
        padding: one of `"valid"` or `"same"` (case-insensitive).
            Note that `"same"` is slightly inconsistent across backends with
            `strides` != 1, as described
            [here](https://github.com/keras-team/keras/pull/9473#issuecomment-372166860)
        data_format: A string,
            one of `"channels_last"` or `"channels_first"`.
            The ordering of the dimensions in the inputs.
            `"channels_last"` corresponds to inputs with shape
            `(batch, height, width, channels)` while `"channels_first"`
            corresponds to inputs with shape
            `(batch, channels, height, width)`.
            It defaults to the `image_data_format` value found in your
            Keras config file at `~/.keras/keras.json`.
            If you never set it, then it will be "channels_last".
        dilation_rate: an integer or tuple/list of 2 integers, specifying
            the dilation rate to use for dilated convolution.
            Can be a single integer to specify the same value for
            all spatial dimensions.
            Currently, specifying any `dilation_rate` value != 1 is
            incompatible with specifying any stride value != 1.
        activation: Activation function to use
            (see [activations](../activations.md)).
            If you don't specify anything, no activation is applied
            (ie. "linear" activation: `a(x) = x`).
        use_bias: Boolean, whether the layer uses a bias vector.
        kernel_initializer: Initializer for the `kernel` weights matrix
            (see [initializers](../initializers.md)).
        bias_initializer: Initializer for the bias vector
            (see [initializers](../initializers.md)).
        kernel_regularizer: Regularizer function applied to
            the `kernel` weights matrix
            (see [regularizer](../regularizers.md)).
        bias_regularizer: Regularizer function applied to the bias vector
            (see [regularizer](../regularizers.md)).
        activity_regularizer: Regularizer function applied to
            the output of the layer (its "activation").
            (see [regularizer](../regularizers.md)).
        kernel_constraint: Constraint function applied to the kernel matrix
            (see [constraints](../constraints.md)).
        bias_constraint: Constraint function applied to the bias vector
            (see [constraints](../constraints.md)).

    # Input shape
        4D tensor with shape:
        `(batch, channels, rows, cols)`
        if `data_format` is `"channels_first"`
        or 4D tensor with shape:
        `(batch, rows, cols, channels)`
        if `data_format` is `"channels_last"`.

    # Output shape
        4D tensor with shape:
        `(batch, filters, new_rows, new_cols)`
        if `data_format` is `"channels_first"`
        or 4D tensor with shape:
        `(batch, new_rows, new_cols, filters)`
        if `data_format` is `"channels_last"`.
        `rows` and `cols` values might have changed due to padding.
    """

    @interfaces.legacy_conv2d_support
    def __init__(self, filters,
                 kernel_size,
                 strides=(1, 1),
                 padding='valid',
                 data_format=None,
                 dilation_rate=(1, 1),
                 activation=None,
                 use_bias=True,
                 kernel_initializer='glorot_uniform',
                 bias_initializer='zeros',
                 kernel_regularizer=None,
                 bias_regularizer=None,
                 activity_regularizer=None,
                 kernel_constraint=None,
                 bias_constraint=None,
                 args=None,  # the global arguments for the code
                 **kwargs):
        super(Conv2D_fft, self).__init__(
            filters=filters,
            kernel_size=kernel_size,
            strides=strides,
            padding=padding,
            data_format=data_format,
            dilation_rate=dilation_rate,
            activation=activation,
            use_bias=use_bias,
            kernel_initializer=kernel_initializer,
            bias_initializer=bias_initializer,
            kernel_regularizer=kernel_regularizer,
            bias_regularizer=bias_regularizer,
            activity_regularizer=activity_regularizer,
            kernel_constraint=kernel_constraint,
            bias_constraint=bias_constraint,
            **kwargs)
        self.args = args

    @interfaces.legacy_add_weight_support
    def add_weight_custom(self,
                          name,
                          value,
                          dtype=None,
                          regularizer=None,
                          trainable=True,
                          constraint=None):
        """Adds a weight variable to the layer.

        # Arguments
            name: String, the name for the weight variable.
            shape: The shape tuple of the weight.
            dtype: The dtype of the weight.
            initializer: An Initializer instance (callable).
            regularizer: An optional Regularizer instance.
            trainable: A boolean, whether the weight should
                be trained via backprop or not (assuming
                that the layer itself is also trainable).
            constraint: An optional Constraint instance.

        # Returns
            The created weight variable.
        """
        if dtype is None:
            dtype = K.floatx()
        weight = K.variable(value,
                            dtype=dtype,
                            name=name,
                            constraint=constraint)
        if regularizer is not None:
            with K.name_scope('weight_regularizer'):
                self.add_loss(regularizer(weight))
        if trainable:
            self._trainable_weights.append(weight)
        else:
            self._non_trainable_weights.append(weight)
        return weight

    def build_custom(self, input_shape, kernel, bias=None):
        if self.data_format == 'channels_first':
            channel_axis = 1
        else:
            channel_axis = -1
        if input_shape[channel_axis] is None:
            raise ValueError('The channel dimension of the inputs '
                             'should be defined. Found `None`.')
        input_dim = input_shape[channel_axis]
        # kernel_shape = self.kernel_size + (input_dim, self.filters)
        self.kernel = self.add_weight_custom(value=kernel,
                                             name='kernel',
                                             regularizer=self.kernel_regularizer,
                                             constraint=self.kernel_constraint)
        if self.use_bias:
            self.bias = self.add_weight_custom(value=bias,
                                               name='bias',
                                               regularizer=self.bias_regularizer,
                                               constraint=self.bias_constraint)
        else:
            self.bias = None
        # Set input spec.
        self.input_spec = InputSpec(ndim=self.rank + 2,
                                    axes={channel_axis: input_dim})
        self.built = True

    def get_config(self):
        config = super(Conv2D_fft, self).get_config()
        config.pop('rank')
        return config

    def exec(self, x, kernel, strides, padding, data_format, dilation_rate):
        if self.args is None or self.args.conv_type == ConvType.STANDARD2D:
            outputs = K.conv2d(
                x=x,
                kernel=kernel,
                strides=strides,
                padding=padding,
                data_format=data_format,
                dilation_rate=dilation_rate)
        elif self.args.conv_type == ConvType.FFT2D:
            # raise Exception("Not implemented yet")
            print("Execute convolution via FFT")
            outputs = conv_fft_forward(x=x,
                                       kernel=kernel,
                                       strides=strides,
                                       padding=padding,
                                       data_format=data_format,
                                       dilation_rate=dilation_rate,
                                       args=self.args)
        else:
            raise Exception(f"Unknown convolution version: {self.version.name}")
        return outputs

    def call(self, inputs):
        outputs = self.exec(x=inputs,
                            kernel=self.kernel,
                            strides=self.strides,
                            padding=self.padding,
                            data_format=self.data_format,
                            dilation_rate=self.dilation_rate)

        if self.use_bias:
            outputs = K.bias_add(
                outputs,
                self.bias,
                data_format=self.data_format)

        if self.activation is not None:
            return self.activation(outputs)
        return outputs
