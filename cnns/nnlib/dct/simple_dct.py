import numpy as np
import math
from functools import wraps

def correlate(dct_function):
    """
    Correlate 1D input signals via the DCT transformation.

    :param x: input signal in the time domain.
    :param y: input filter in the time domain.
    :return: the correlation z between x and y
    """
    """
    Without the use of this decorator factory wraps, the name of the example 
    function would have been 'wrapper', and the docstring of the original 
    example() would have been lost.
    """
    @wraps(dct_function)
    def wrapper(self, x, y, use_next_power2=False, is_convolution=False):
        is_correlation = not is_convolution
        N = len(x)
        L = len(y)
        M = N + L - 1
        P1 = max((L - 3), 0) // 2 + 1
        P2 = max(P1 + 1, (N - 3) // 2 + 1)
        P = max(P2 + 1, 3 * M // 2 + 1)

        if use_next_power2:
            P = int(2 ** np.ceil(np.log2(P)))

        x = np.pad(array=x, pad_width=(P1, P - P1 - N), mode='constant')
        if is_correlation:
            y = np.flip(y)
        y = np.pad(array=y, pad_width=(P2, P - P2 - L), mode='constant')
        z = dct_function(self, x, y)
        # z = z[(P1+P2):(P1+P2)+M]
        z = 2 * z
        return z

    return wrapper

class DCT:

    def __init__(self):
        pass

    def dct2(self, x):
        """
        DCT of x according to: "A computing method for linear convolution in the
        DCT domain":
        https://www.eurasip.org/Proceedings/Eusipco/Eusipco2011/papers/1569426007.pdf
        and
        https://unix4lyfe.org/dct-1d/


        :param x: 1D input signal in the time domain.
        :return: DCT(x) - 1D output signal in the frequency DCT domain.
        """
        P = x.shape[-1]
        X = np.zeros(P, dtype=float)
        for k in range(P):
            out = 0
            if k == 0:
                kk = 1. / np.sqrt(2.)
            else:
                kk = 1.
            for n in range(P):
                out += kk * x[n] * np.cos(np.pi * (n + .5) * k / P)
            out *= np.sqrt(2. / P)
            X[k] = out
        return X

    def dct1(self, Y):
        N = Y.shape[-1]
        y = np.zeros(N, dtype=float)
        for n in range(N):
            out = 0
            for k in range(N):
                if k == 0:
                    kk = 1. / 2.
                else:
                    kk = 1.
                out += kk * Y[k] * np.cos(np.pi * n * k / N)
            y[n] = out
        return y

    def dct2wiki(self, x):
        """
        DCT of x according to:
        https://en.wikipedia.org/wiki/Discrete_cosine_transform#DCT-II

        :param x: P point 1D signal with real values (samples).
        :return: the DCT of x
        """
        P = x.shape[-1]
        X = np.zeros(P, dtype=float)
        for k in range(P):
            out = 0
            for n in range(P):
                out += x[n] * np.cos(np.pi * (n + 0.5) * k / P)
            X[k] = out
        return X

    def dct1wiki(self, x):
        """
        This acts as an inverse transform for the izumi convolution.

        DCT1 of the input signal x in the frequency domain.

        :param x: N point input signal in the frequency domain.
        :return: the N point signal in the time domain.
        """
        P = x.shape[-1]
        X = np.zeros(P, dtype=float)
        for k in range(1, P-1):
            out = 0.5 * x[0]
            for n in range(P):
                out += x[n] * np.cos(np.pi * n * k / (P - 1))
            out += math.pow(-1.0, k) * x[P-1]
            X[k] = out
        return X

    def dct1reju(self, x):
        """
        This can act as a forward or backward transform. We use it simply as a
        transform. This is a very similar definition to wikipedia but with
        scaling 2.
        https://www.researchgate.net/publication/3343693_Convolution_Using_Discrete_Sine_and_Cosine_Transforms
        DCT1 of the input signal x.
        :param x: (N+1) point input signal.
        :return: transformed x.
        """
        N = x.shape[-1]
        X = np.zeros(N, dtype=float)
        for k in range(N):
            out = 0.0
            for n in range(N):
                if n == 0 or n == (N-1):
                    kk = 1.0 / 2
                else:
                    kk = 1.0
                out += kk * x[n] * np.cos(np.pi * k * n / (N-1))
            X[k] = 2 * out
        return X

    def dct2reju(self, x):
        """
        This can act as a forward or backward transform. We use it simply as a
        transform. This is a very similar definition to wikipedia but with
        scaling 2.
        https://www.researchgate.net/publication/3343693_Convolution_Using_Discrete_Sine_and_Cosine_Transforms
        DCT2 of the input signal x.
        :param x: (N) point input signal.
        :return: transformed x.
        """
        N = x.shape[-1]
        X = np.zeros(N + 1, dtype=float)
        for k in range(N):
            out = 0.0
            for n in range(N):
                out += x[n] * np.cos(np.pi * k * (n + 0.5) / N)
            X[k] = 2 * out
        X[N] = 0.0
        return X

    def dst1reju(self, x):
        """
        This can act as a forward or backward transform. We use it simply as a
        transform. This is a very similar definition to wikipedia but with
        scaling 2.
        https://www.researchgate.net/publication/3343693_Convolution_Using_Discrete_Sine_and_Cosine_Transforms
        DST1 of the input signal x.
        :param x: (N) point input signal.
        :return: transformed x.
        """
        N = x.shape[-1]
        X = np.zeros(N, dtype=float)
        X[0] = 0.0
        for k in range(1, N):
            out = 0.0
            for n in range(1, N):
                out += x[n] * np.sin(np.pi * k * n / N)
            X[k] = 2 * out
        return X

    def dst2reju(self, x):
        """
        This can act as a forward or backward transform. We use it simply as a
        transform. This is a very similar definition to wikipedia but with
        scaling 2.
        https://www.researchgate.net/publication/3343693_Convolution_Using_Discrete_Sine_and_Cosine_Transforms
        DST2 of the input signal x.
        :param x: (N) point input signal.
        :return: transformed x.
        """
        N = x.shape[-1]
        X = np.zeros(N+1, dtype=float)
        X[0] = 0.0
        for k in range(1, N+1):
            out = 0.0
            for n in range(N):
                out += x[n] * np.sin(np.pi * k * (n + 0.5) / N)
            X[k] = 2 * out
        return X


    @correlate
    def correlate_izumi(self, x, y):
        """
        Cross correlation of x and y via the DCT transform.

        :param x: input signal x in the time domain
        :param y: input filter y in the time domain
        :return: the output of the correlation
        """
        x = self.dct2(x)
        y = self.dct2(y)
        z = x * y
        z = self.dct1(z)
        return z

    @correlate
    def correlate_wiki(self, x, y):
        x = self.dct2wiki(x)
        y = self.dct2wiki(y)
        z = x * y
        z = self.dct1wiki(z)
        return z

    @correlate
    def correlate_matrucci(self, x, y):
        x = self.dct2(x)
        y = self.dct1(y)
        z = x * y
        z = self.dct2(z)
        return z

    def idct(self, x):
        N = len(x)
        X = np.zeros(N, dtype=float)
        for k in range(N):
            out = np.sqrt(.5) * x[0]
            for n in range(1, N):
                out += x[n] * np.cos(np.pi * n * (k + .5) / N)
            X[k] = out * np.sqrt(2. / N)
        return X


if __name__ == "__main__":
    dct = DCT()
    # x = np.array([1.0, 2.0, 3.0, 4.0])
    # y = np.array([-1.0, 3.0])
    x = np.arange(0, 21, dtype=float)
    y = np.array([1.0, 2.0, 3.0])
    expect = np.correlate(x, y, mode="full")
    print("expect: ", expect)
    result = dct.correlate_izumi(x, y, use_next_power2=False)
    # result = dct.correlate_matrucci(x, y, use_next_power2=False)
    print("result: ", result)
    assert np.testing.assert_allclose(actual=result, desired=expect)
