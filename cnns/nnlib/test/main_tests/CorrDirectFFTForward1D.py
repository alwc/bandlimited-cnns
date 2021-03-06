from scipy import signal

from nnlib.layers import *


def rel_error(x, y):
    """ returns relative error """
    return np.max(np.abs(x - y) / (np.maximum(1e-8, np.abs(x) + np.abs(y))))


x = [1, 2, 3, 5, 1, -1, 2, 3, 5, 8, 3, 9, 1, 2, 5, 1]
x = np.array(x)
print("input x shape: ", x.shape)
filters = [4, 5, 3, 4]
filters = np.array(filters)
b = np.array([0])

stride = 1

mode = "full"
if mode == "valid":
    padding = 0
elif mode == "full":
    padding = len(filters) - 1

scipy_correlate = signal.correlate(x, filters, mode=mode)
print("correlate scipy:", scipy_correlate)
print("correlate scipy shape:", scipy_correlate.shape)

scipy_fft = signal.correlate(x, filters, mode=mode, method="fft")
print("fft scipy:", scipy_fft)
print("fft scipy shape:", scipy_fft.shape)

np_correlate = np.correlate(x, filters, mode=mode)
print("correlate numpy:", np_correlate)
print("correlate numpy shape:", np_correlate.shape)

print("x: ", x)
print("filters: ", filters)
xfft = np.fft.fft(x)
filterfft = np.conj(np.fft.fft(filters, len(xfft)))
# element-wise multiplication in the frequency domain
out = xfft * filterfft
# take the inverse of the output from the frequency domain and return the modules of the complex numbers
out = np.fft.ifft(out)
output = np.real(out)[:xfft.shape[-1]]
out_W = np.int(((len(x) + 2 * padding - len(filters)) / stride) + 1)
# output = np.absolute(out)
output = output[:out_W]

print("output of cross-correlation via fft: ", output)
print("output of cross-correlation via fft shape: ", output.shape)

x = x.reshape(1, 1, -1)
filters = filters.reshape(1, 1, -1)

print("size of padding: ", padding)
conv_param = {'stride': stride, 'pad': padding}
outnaive, _ = conv_forward_naive_1D(x, filters, b, conv_param)
print("out naive conv: ", outnaive)
print("out naive conv shape: ", outnaive.shape)

print("x: ", x)
print("filters: ", filters)

outfft, _ = conv_forward_fft_1D(x, filters, b, conv_param)
print("outfff: ", outfft)
print("outfff shape: ", outfft.shape)

print("is the fft cross_correlation for convolution correct with respect to naive: ",
      np.allclose(outfft, outnaive, atol=1e-12))
print("relative error fft naive: ", rel_error(outfft, outnaive))
print("absolute error fft: ", np.sum(np.abs(outfft - outnaive)))
print("absolute error scipy: ", np.sum(np.abs(scipy_correlate - outnaive)))
print("absolute error numpy: ", np.sum(np.abs(np_correlate - outnaive)))
print("absolute error scipy fft: ", np.sum(np.abs(scipy_fft - outnaive)))
