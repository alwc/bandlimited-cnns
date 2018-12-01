#include <ATen/ATen.h>

#include <cuda.h>
#include <cuda_runtime.h>
#include <cstdio>
#include <cmath>

namespace {

template <typename scalar_t>
__global__ void complex_mul_cuda_kernel(
    const scalar_t* __restrict__ x,
    const scalar_t* __restrict__ y,
    scalar_t* __restrict__ out,
    const int N, const int F, const int C, const int H, const int W) {

    const int n = blockIdx.x; // current data point in the batch
    const int f = blockIdx.y; // current filter from the filter bank
    const int h = blockIdx.z; // current row to be computed
    const int w = threadIdx.x; // current column to be computed

    if(h >= H) return;

    const int I = 2; // the last dimension for the complex number
    const int batch_size = H * W * C * I;
    const int n_idx = n * batch_size;  // start index in the batch for this input map
    const int f_idx = f * batch_size;  // start index in the bank for this filter
    const int h_idx = h * W * C * I;   // start index for this row
    const int w_idx = w * C * I;       // start index for this column

    // index in the input map
    const int N_idx = n_idx + h_idx + w_idx; // index for this C,I component in input

    // index in the filter
    const int F_idx = f_idx + h_idx + w_idx; // index for this C,I component in filter

    // find index for the output
    const int no_idx = n * F*H*W*I; // output index for the batch data point
    const int fo_idx = f * H*W*I;   // output index for the filter/channel
    const int ho_idx = h * W * I;   // output index for row
    const int wo_idx = w * I;       // output index for col
    const int O_idx = no_idx + fo_idx + ho_idx + wo_idx;

    scalar_t out_re = 0.0;
    scalar_t out_im = 0.0;

    for (int c = 0; c < C; ++c) {
        scalar_t x_re = x[N_idx + c*I];
        scalar_t x_im = x[N_idx + c*I + 1];
        scalar_t y_re = y[F_idx + c*I];
        scalar_t y_im = y[F_idx + c*I + 1];
        single_mul(x_re, x_im, y_re, y_im, &out_re, &out_im);
    }
    out[O_idx] = out_re;
    out[O_idx + 1] = out_im;
}

template <typename scalar_t>
__device__ __forceinline__ void single_mul(
    scalar_t x_re,
    scalar_t x_im,
    scalar_t y_re,
    scalar_t y_im,
    scalar_t* out_re,
    scalar_t* out_im) {

    scalar_t uavc = x_re * (y_re + y_im);
    *out_re += uavc - (x_re + x_im) * y_im;
    *out_im += (x_im - x_re) * y_re + uavc;
}

} // namespace

void complex_mul_cuda(at::Tensor x, at::Tensor y, at::Tensor out) {

    const int threads = 1024;  // corresponds to W

    const auto N = x.size(0);  // batch_size
    const auto F = y.size(0);  // filter_bank_size
    const auto C = x.size(1);  // number of channels
    const auto H = x.size(2);  // height of the matrix
    const auto W = x.size(3);  // width of the matrix

    // set channel as the last but one dimension
    x = x.permute({0,2,3,1,4});
    y = y.permute({0,2,3,1,4});

    const auto x_blocks = N;
    const auto y_blocks = F;
    // Overall we need: N*F*H*W threads - for each element in the output.
    const auto z_blocks = (N*F*H*W + threads - 1)/threads;  // corresponds to H
    const dim3 blocks(x_blocks, y_blocks, z_blocks);

    AT_DISPATCH_FLOATING_TYPES(x.type(), "complex_mul_cuda",
    ([&] {
        complex_mul_cuda_kernel<scalar_t><<<blocks, threads>>>(
        x.data<scalar_t>(), y.data<scalar_t>(), out.data<scalar_t>(),
        N, F, C, H, W);
    }));

    // restore the channel to the second dimension
    x = x.permute({0,3,1,2,4});
    y = y.permute({0,3,1,2,4});
}
