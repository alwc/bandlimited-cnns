import torch
import unittest
from cnns.nnlib.pytorch_layers.pytorch_utils import flip
from cnns.nnlib.pytorch_layers.pytorch_utils import preserve_energy2D
from cnns.nnlib.pytorch_layers.pytorch_utils import complex_mul
import numpy as np
from torch import tensor
import socket

if socket.gethostname() == "skr-compute1":
    from complex_mul_cpp import complex_mul as complex_mul_cpp
    from complex_mul_cuda import complex_mul as complex_mul_cuda

class TestPytorchUtils(unittest.TestCase):

    def test_flip(self):
        # check the flipping
        a = torch.tensor([[1, 2], [3, 4]])
        print("tensor a: ", a)
        print("flip(a, 0): ", flip(a, 0))
        flipped = flip(a, 0)
        expected = torch.tensor([[3, 4], [1, 2]])
        self.assertTrue(flipped.equal(expected))

    def test_dims_flip(self):
        b = torch.tensor([[[[1, 2], [3, 4]]]])
        print("tensor b: ", b)
        print("size of b: ", b.size())
        for dim in range(4):
            print("flip(b, {}) = ".format(dim), flip(b, dim))
        self.assertTrue(flip(b, 0).equal(b))
        self.assertTrue(flip(b, 1).equal(b))
        self.assertTrue(flip(b, 2).equal(torch.tensor([[[[3, 4], [1, 2]]]])))
        self.assertTrue(flip(b, 3).equal(torch.tensor([[[[2, 1], [4, 3]]]])))

    def test_double_flipped(self):
        b = torch.tensor([[[[1, 2], [3, 4]]]])
        double_flipped = flip(flip(b, 2), 3)
        print("flip(flip(b, 2), 3): ", double_flipped)
        double_expected = torch.tensor([[[[4, 3], [2, 1]]]])
        self.assertTrue(double_flipped.equal(double_expected))

    def test_preserve_energy2D_1(self):
        xfft = torch.tensor(
            [  # 1 image
                [  # 1 channel
                    [[[2, 2], [2, 2], [2, 2]],  # 1st row
                     [[2, 2], [2, 2], [-2, -2]],  # 2nd row
                     [[-2, 2], [-2, 2], [2, 2]]]  # 3rd row
                ]
            ])
        yfft = torch.tensor(
            [  # 1 image
                [  # 1 channel
                    [[[1, 1], [1, 1], [1, 1]],  # 1st row
                     [[1, 1], [1, 1], [-1, -1]],  # 2nd row
                     [[-1, 1], [-1, 1], [1, 1]]]  # 3rd row
                ]
            ])
        xfft2, yfft2, index_back_H, index_back_W = preserve_energy2D(xfft, yfft,
                                                                     preserve_energy_rate=50)
        expect_xfft2 = torch.tensor(
            [  # 1 image
                [  # 1 channel
                    [[[2, 2], [2, 2], [2, 2]],  # 1st row
                     [[2, 2], [2, 2], [0, 0]],  # 2nd row
                     [[-2, 2], [-2, 2], [0, 0]]]  # 3rd row
                ]
            ])
        expect_yfft2 = torch.tensor(
            [  # 1 image
                [  # 1 channel
                    [[[1, 1], [1, 1], [1, 1]],  # 1st row
                     [[1, 1], [1, 1], [0, 0]],  # 2nd row
                     [[-1, 1], [-1, 1], [0, 0]]]  # 3rd row
                ]
            ])
        np.testing.assert_equal(expect_xfft2.numpy(), xfft.numpy())
        np.testing.assert_equal(expect_yfft2.numpy(), yfft.numpy())
        np.testing.assert_equal(index_back_H, 1)
        np.testing.assert_equal(index_back_W, 0)

    def test_preserve_energy2D_2(self):
        xfft = torch.tensor(
            [  # 1 image
                [  # 1 channel
                    [[[2, 2], [2, 2], [2, 2], [2, 2]],  # 1st row
                     [[2, 2], [2, 2], [-2, -2], [-2, -2]],  # 2nd row
                     [[-2, 2], [-2, 2], [2, 2], [-2, -2]],  # 3rd row
                     [[2, 2], [2, 2], [-2, -2], [-2, -2]]]  # 4th row
                ]
            ])
        yfft = torch.tensor(
            [  # 1 image
                [  # 1 channel
                    [[[1, 1], [1, 1], [1, 1], [1, 1]],  # 1st row
                     [[1, 1], [1, 1], [-1, -1], [1, 1]],  # 2nd row
                     [[-1, 1], [-1, 1], [1, 1], [1, 1]],  # 3rd row
                     [[-1, 1], [-1, 1], [1, 1], [1, 1]]]  # 4th row
                ]
            ])
        xfft2, yfft2, index_back_H, index_back_W = preserve_energy2D(xfft, yfft,
                                                                     preserve_energy_rate=40)
        # print("result xfft2: ", xfft2)
        expect_xfft2 = torch.tensor(
            [  # 1 image
                [  # 1 channel
                    [[[2, 2], [2, 2], [2, 2], [2, 2]],  # 1st row
                     [[2, 2], [2, 2], [-2, -2], [-2, -2]],  # 2nd row
                     [[-2, 2], [0, 0], [0, 0], [-2, -2]],  # 3rd row
                     [[2, 2], [2, 2], [-2, -2], [-2, -2]]]  # 4th row
                ]
            ])
        expect_yfft2 = torch.tensor(
            [  # 1 image
                [  # 1 channel
                    [[[1, 1], [1, 1], [1, 1], [1, 1]],  # 1st row
                     [[1, 1], [1, 1], [-1, -1], [1, 1]],  # 2nd row
                     [[-1, 1], [0, 0], [0, 0], [1, 1]],  # 3rd row
                     [[-1, 1], [-1, 1], [1, 1], [1, 1]]]  # 4th row
                ]
            ])
        np.testing.assert_equal(expect_xfft2.numpy(), xfft.numpy())
        np.testing.assert_equal(expect_yfft2.numpy(), yfft.numpy())
        np.testing.assert_equal(index_back_H, 1)
        np.testing.assert_equal(index_back_W, 1)

    def test_preserve_energy2D_2(self):
        xfft = tensor([[[[[5, 6], [3, 4], [1, 2]], [[5, 6], [3, 4], [1, 2]]],
                        [[[0, 1], [1, 0], [2, 2]], [[0, 1], [1, 0], [2, 2]]]]])
        yfft = tensor([[[[[5, 6], [3, 4], [1, 2]], [[5, 6], [3, 4], [1, 2]]],
                        [[[0, 1], [1, 0], [2, 2]], [[0, 1], [1, 0], [2, 2]]]]])
        np.testing.assert_equal(xfft.size(), [1, 2, 2, 3, 2])
        xfft2, yfft2, index_back_H, index_back_W = preserve_energy2D(
            xfft.clone(), yfft.clone(), 100)
        np.testing.assert_equal(xfft2.numpy(), xfft.numpy())
        np.testing.assert_equal(yfft2.numpy(), yfft.numpy())
        np.testing.assert_equal(index_back_H, 0)
        np.testing.assert_equal(index_back_W, 0)

    def test_index_back_width(self):
        xfft = torch.tensor([
            [  # first image
                [[[2, 2], [2, 3], [2, 2]]],  # first channel
                [[[2, 2], [2, 2], [2, 2]]]  # second channel
            ],
            [  # second image
                [[[1, 1], [1, 2], [1, 1]]],  # fist channel
                [[[1, 1], [1, 1], [1, 1]]]  # second channel
            ]
        ], dtype=torch.float)
        yfft = xfft
        xfft2, yfft2, index_back_H, index_back_W = preserve_energy2D(xfft, yfft,
                                                                     50)
        expect = torch.tensor([
            [  # first image
                [[[2, 2], [2, 3], [2, 2]]],  # first channel
                [[[2, 2], [2, 2], [2, 2]]]  # second channel
            ],
            [  # second image
                [[[1, 1], [1, 2], [1, 1]]],  # fist channel
                [[[1, 1], [1, 1], [1, 1]]]  # second channel
            ]
        ], dtype=torch.float)
        # print("obtained xfft2: ", xfft2)
        np.testing.assert_equal(xfft2.numpy(), expect.numpy())
        np.testing.assert_equal(yfft2.numpy(), expect.numpy())
        np.testing.assert_equal(index_back_H, 0)
        np.testing.assert_equal(index_back_W, 1)

    def test_preserve_energy2D_index_back_height(self):
        xfft = torch.tensor([
            [  # first image
                [[[2, 2], [2, 3], [2, 2]]],  # first channel
                [[[2, 2], [2, 2], [2, 2]]]  # second channel
            ],
            [  # second image
                [[[1, 1], [1, 2], [1, 1]]],  # fist channel
                [[[1, 1], [1, 1], [1, 1]]]  # second channel
            ]
        ])
        xfft = torch.transpose(xfft, 2, 3)
        yfft = xfft
        xfft2, yfft2, index_back_H, index_back_W = preserve_energy2D(
            xfft.clone(), yfft.clone(), 50)
        np.testing.assert_equal(xfft2.numpy(), xfft.numpy())
        np.testing.assert_equal(yfft2.numpy(), xfft.numpy())
        np.testing.assert_equal(index_back_H, 1)
        np.testing.assert_equal(index_back_W, 0)

    def test_preserve_energy2D_2(self):
        xfft = tensor([[[  # 2 channels, 2 x 3 images
            [[5, 6], [3, 4], [1, 2]],
            [[5, 6], [3, 4], [1, 2]]],
            [[[0, 1], [1, 0], [0, 1]],
             [[0, 1], [1, 0], [0, 1]]]]])
        squared = torch.add(torch.pow(xfft[..., 0], 2),
                            torch.pow(xfft[..., 1], 2))
        squared = squared.sum(dim=0).sum(dim=0)
        expect_squared = tensor([  # 2 x 3 map
            [62, 26, 6],
            [62, 26, 6]])
        np.testing.assert_equal(expect_squared.numpy(), squared.numpy())
        np.testing.assert_equal(xfft.size(), [1, 2, 2, 3, 2])
        yfft = xfft
        xfft2, yfft2, index_back_H, index_back_W = preserve_energy2D(
            xfft.clone(), yfft.clone(), 60)
        expect_xfft = tensor([[[  # 2 channels, 2 x 3 images
            [[5, 6], [3, 4], [1, 2]],
            [[5, 6], [0, 0], [1, 2]]],
            [[[0, 1], [1, 0], [0, 1]],
             [[0, 1], [0, 0], [0, 1]]]]])
        expect_yfft = expect_xfft
        np.testing.assert_equal(xfft2.numpy(), expect_xfft.numpy())
        np.testing.assert_equal(yfft2.numpy(), expect_yfft.numpy())
        np.testing.assert_equal(index_back_H, 0)
        np.testing.assert_equal(index_back_W, 1)

    def test_preserve_energy2D_more_rows(self):
        xfft = torch.tensor(
            [  # 1 image
                [  # 1 channel
                    [[[2, 2], [2, 2]],  # 1st row
                     [[2, 2], [2, 2]],  # 2nd row
                     [[2, 2], [2, 2]],
                     [[-2, -2], [-2, -2]],
                     [[-2, 2], [-2, 2]],
                     [[2, 2], [-2, -2]],
                     [[2, 2], [2, 2]],
                     [[-2, -2], [-2, -2]],
                     [[2, 2], [2, 2]],
                     [[-2, -2], [-2, -2]],  # 10th row
                     ]
                ]
            ])
        yfft = xfft.clone()
        xfft2, yfft2, index_back_H, index_back_W = preserve_energy2D(
            xfft.clone(), yfft.clone(),
            preserve_energy_rate=71)
        print("result xfft2: ", xfft2)
        expect_xfft2 = torch.tensor(
            [  # 1 image
                [  # 1 channel
                    [[[2, 2], [2, 2]],  # 1st row
                     [[2, 2], [2, 2]],  # 2nd row
                     [[2, 2], [2, 2]],
                     [[-2, -2], [-2, -2]],
                     [[-2, 2], [-2, 2]],
                     [[2, 2], [-2, -2]],
                     [[2, 2], [2, 2]],
                     [[-2, -2], [0, 0]],
                     [[2, 2], [2, 2]],
                     [[-2, -2], [-2, -2]],  # 10th row
                     ]
                ]
            ])
        expect_yfft2 = expect_xfft2.clone()

        np.testing.assert_equal(xfft2.numpy(), expect_xfft2.numpy())
        np.testing.assert_equal(yfft2.numpy(), expect_yfft2.numpy())
        np.testing.assert_equal(index_back_H, 2)
        np.testing.assert_equal(index_back_W, 0)

    def test_preserve_energy2D_more_cols(self):
        xfft = torch.tensor(
            [
                [  # 1st  channel
                    [[[2, 2], [2, 2], [2, 2], [2, 2], [2, 2], [2, 2],
                     [-2, -2],
                     [-2, -2], [-2, 2], [-2, 2]],
                    [[2, 2], [-2, -2], [2, 2], [2, 2], [-2, -2], [-2, -2],
                     [2, 2], [2, 2], [-2, -2], [-2, -2]]],  # 2nd row
                ]
            ])
        print("dimensions of xfft: ", xfft.size())
        yfft = xfft.clone()
        xfft2, yfft2, index_back_H, index_back_W = preserve_energy2D(
            xfft.clone(), yfft.clone(),
            preserve_energy_rate=71)
        print("result xfft2: ", xfft2)
        expect_xfft2 = torch.tensor(
            [
                [  # 1st  channel
                    [[[2, 2], [2, 2], [2, 2], [2, 2], [2, 2], [2, 2], [-2, -2], [-2, -2], [-2, 2], [-2, 2]],
                    [[2, 2], [-2, -2], [2, 2], [2, 2], [-2, -2], [-2, -2], [2, 2], [0, 0], [-2, -2], [-2, -2]]],  # 2nd row
                ]
            ])
        expect_yfft2 = expect_xfft2.clone()

        np.testing.assert_equal(xfft2.numpy(), expect_xfft2.numpy())
        np.testing.assert_equal(yfft2.numpy(), expect_yfft2.numpy())
        np.testing.assert_equal(index_back_H, 0)
        np.testing.assert_equal(index_back_W, 2)

    def test_cuda_multiply(self):
        N, C, H, W, I = 2, 3, 5, 3, 2
        F = 4
        if torch.cuda.is_available():
            device = torch.device("cuda")
        else:
            device = torch.device("cpu")
        dtype = torch.float
        x = torch.randn(N, C, H, W, I , device=device, dtype=dtype)
        y = torch.randn(F, C, H, W, I, device=device, dtype=dtype)
        out = torch.zeros(N, F, H, W, I, device=device, dtype=dtype)

        complex_mul_cuda(x, y, out)

        print("out.size(): ", out.size())

        x = x.unsqueeze(dim=1)
        expect = complex_mul(x, y)
        expect = expect.sum(dim=2)

        np.testing.assert_allclose(
            actual=out.cpu().numpy(), desired=expect.cpu().numpy(),
            err_msg="actual out different from desired expected")

    def test_cuda_multiply_simple(self):
        if torch.cuda.is_available():
            device = torch.device("cuda")
        else:
            device = torch.device("cpu")
        dtype = torch.float
        x = torch.tensor([[[[[3,-2]]]]], device=device, dtype=dtype)
        y = torch.tensor([[[[[5,4]]]]], device=device, dtype=dtype)
        expect = torch.tensor([[[[[23, 2]]]]])
        out = torch.zeros_like(expect, device=device, dtype=dtype)
        complex_mul_cuda(x, y, out)
        np.testing.assert_allclose(
            actual=out.cpu().numpy(), desired=expect.cpu().numpy(),
            err_msg="actual out different from desired expected")

    def test_cuda_multiply_simple2(self):
        if torch.cuda.is_available():
            device = torch.device("cuda")
        else:
            device = torch.device("cpu")
        dtype = torch.float
        x = torch.tensor([[[[[3,-2], [2,5]]]]], device=device, dtype=dtype)
        y = torch.tensor([[[[[5,4], [-1, 3]]]]], device=device, dtype=dtype)
        expect = torch.tensor([[[[[23, 2], [-17, 1]]]]])
        out = torch.zeros_like(expect, device=device, dtype=dtype)
        complex_mul_cuda(x, y, out)
        np.testing.assert_allclose(
            actual=out.cpu().numpy(), desired=expect.cpu().numpy(),
            err_msg="actual out different from desired expected")



if __name__ == '__main__':
    unittest.main()
