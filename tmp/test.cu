#include <cuda.h>
#include <iostream>

#define uint unsigned int
#define uchar unsigned char
#define ushort unsigned short
#define int64_t long long
#define uint64_t unsigned long long

extern "C" __global__ void conv3(float* __restrict__ data,
				 float* __restrict__ kernel,
				 float* __restrict__ compute) {
  float compute_local[32];
  __shared__ float pad_temp_shared[720];
  __shared__ float kernel_shared[1152];
  float pad_temp_shared_local[10];
  float kernel_shared_local[12];
  for (int yy_c_init = 0; yy_c_init < 8; ++yy_c_init) {
    compute_local[(yy_c_init)] = 0.000000e+00f;
    compute_local[((yy_c_init + 8))] = 0.000000e+00f;
    compute_local[((yy_c_init + 16))] = 0.000000e+00f;
    compute_local[((yy_c_init + 24))] = 0.000000e+00f;
  }
  for (int rc_outer = 0; rc_outer < 8; ++rc_outer) {
    __syncthreads();
    for (int ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner = 0; ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner < 6; ++ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner) {
      if (((((int)threadIdx.z) * 5) + (((((int)threadIdx.x) * 6) + ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner) / 18)) < 40) {
        if ((((((int)threadIdx.z) * 90) + (((int)threadIdx.x) * 6)) + ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner) < 720) {
          if (((((int)threadIdx.x) * 6) + ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner) < 90) {
            pad_temp_shared[((((((int)threadIdx.z) * 90) + (((int)threadIdx.x) * 6)) + ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner))] = (((((1 <= ((((int)blockIdx.y) * 8) + (((((int)threadIdx.z) * 5) + (((((int)threadIdx.x) * 6) + ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner) / 18)) % 10))) && (((((int)blockIdx.y) * 8) + (((((int)threadIdx.z) * 5) + (((((int)threadIdx.x) * 6) + ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner) / 18)) % 10)) < 257)) && (1 <= ((((int)blockIdx.x) * 16) + (((((int)threadIdx.x) * 6) + ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner) % 18)))) && (((((int)blockIdx.x) * 16) + (((((int)threadIdx.x) * 6) + ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner) % 18)) < 257)) ? data[((((((((rc_outer * 262144) + ((((((int)threadIdx.z) * 5) + (((((int)threadIdx.x) * 6) + ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner) / 18)) / 10) * 65536)) + (((int)blockIdx.y) * 2048)) + ((((((int)threadIdx.z) * 5) + (((((int)threadIdx.x) * 6) + ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner) / 18)) % 10) * 256)) + (((int)blockIdx.x) * 16)) + (((((int)threadIdx.x) * 6) + ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner) % 18)) - 257))] : 0.000000e+00f);
          }
        }
      }
    }
    for (int ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner1 = 0; ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner1 < 9; ++ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner1) {
      kernel_shared[((((((int)threadIdx.z) * 144) + (((int)threadIdx.x) * 9)) + ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner1))] = kernel[((((((((int)threadIdx.z) * 1152) + ((((int)threadIdx.x) >> 2) * 288)) + (rc_outer * 36)) + ((((int)threadIdx.x) & 3) * 9)) + ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner1))];
    }
    __syncthreads();
    for (int rc_inner_outer = 0; rc_inner_outer < 4; ++rc_inner_outer) {
      for (int rx_inner_outer = 0; rx_inner_outer < 3; ++rx_inner_outer) {
        for (int ax2 = 0; ax2 < 10; ++ax2) {
          pad_temp_shared_local[(ax2)] = pad_temp_shared[(((((rc_inner_outer * 180) + (ax2 * 18)) + ((int)threadIdx.x)) + rx_inner_outer))];
        }
        for (int ax21 = 0; ax21 < 3; ++ax21) {
          kernel_shared_local[(ax21)] = kernel_shared[(((((((int)threadIdx.z) * 36) + (rc_inner_outer * 9)) + (ax21 * 3)) + rx_inner_outer))];
          kernel_shared_local[((ax21 + 3))] = kernel_shared[((((((((int)threadIdx.z) * 36) + (rc_inner_outer * 9)) + (ax21 * 3)) + rx_inner_outer) + 288))];
          kernel_shared_local[((ax21 + 6))] = kernel_shared[((((((((int)threadIdx.z) * 36) + (rc_inner_outer * 9)) + (ax21 * 3)) + rx_inner_outer) + 576))];
          kernel_shared_local[((ax21 + 9))] = kernel_shared[((((((((int)threadIdx.z) * 36) + (rc_inner_outer * 9)) + (ax21 * 3)) + rx_inner_outer) + 864))];
        }
        for (int ry_inner_inner = 0; ry_inner_inner < 3; ++ry_inner_inner) {
          for (int yy_c = 0; yy_c < 8; ++yy_c) {
            compute_local[(yy_c)] = (compute_local[(yy_c)] + (pad_temp_shared_local[((yy_c + ry_inner_inner))] * kernel_shared_local[(ry_inner_inner)]));
            compute_local[((yy_c + 8))] = (compute_local[((yy_c + 8))] + (pad_temp_shared_local[((yy_c + ry_inner_inner))] * kernel_shared_local[((ry_inner_inner + 3))]));
            compute_local[((yy_c + 16))] = (compute_local[((yy_c + 16))] + (pad_temp_shared_local[((yy_c + ry_inner_inner))] * kernel_shared_local[((ry_inner_inner + 6))]));
            compute_local[((yy_c + 24))] = (compute_local[((yy_c + 24))] + (pad_temp_shared_local[((yy_c + ry_inner_inner))] * kernel_shared_local[((ry_inner_inner + 9))]));
          }
        }
      }
    }
  }
  for (int yy_inner_inner_inner = 0; yy_inner_inner_inner < 8; ++yy_inner_inner_inner) {
    compute[((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 2048)) + (yy_inner_inner_inner * 256)) + (((int)blockIdx.x) * 16)) + ((int)threadIdx.x)))] = compute_local[(yy_inner_inner_inner)];
    compute[(((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 2048)) + (yy_inner_inner_inner * 256)) + (((int)blockIdx.x) * 16)) + ((int)threadIdx.x)) + 524288))] = compute_local[((yy_inner_inner_inner + 8))];
    compute[(((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 2048)) + (yy_inner_inner_inner * 256)) + (((int)blockIdx.x) * 16)) + ((int)threadIdx.x)) + 1048576))] = compute_local[((yy_inner_inner_inner + 16))];
    compute[(((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 2048)) + (yy_inner_inner_inner * 256)) + (((int)blockIdx.x) * 16)) + ((int)threadIdx.x)) + 1572864))] = compute_local[((yy_inner_inner_inner + 24))];
  }
}

extern "C" __global__ void conv5(float* __restrict__ data,
				 float* __restrict__ kernel,
				 float* __restrict__ compute) {
  float compute_local[64];
  __shared__ float pad_temp_shared[544];
  __shared__ float kernel_shared[800];
  float pad_temp_shared_local[16];
  float kernel_shared_local[4];
  for (int yy_c_init = 0; yy_c_init < 2; ++yy_c_init) {
    for (int xx_c_init = 0; xx_c_init < 2; ++xx_c_init) {
      compute_local[(((yy_c_init * 2) + xx_c_init))] = 0.000000e+00f;
      compute_local[((((yy_c_init * 2) + xx_c_init) + 16))] = 0.000000e+00f;
      compute_local[((((yy_c_init * 2) + xx_c_init) + 32))] = 0.000000e+00f;
      compute_local[((((yy_c_init * 2) + xx_c_init) + 48))] = 0.000000e+00f;
      compute_local[((((yy_c_init * 2) + xx_c_init) + 8))] = 0.000000e+00f;
      compute_local[((((yy_c_init * 2) + xx_c_init) + 24))] = 0.000000e+00f;
      compute_local[((((yy_c_init * 2) + xx_c_init) + 40))] = 0.000000e+00f;
      compute_local[((((yy_c_init * 2) + xx_c_init) + 56))] = 0.000000e+00f;
      compute_local[((((yy_c_init * 2) + xx_c_init) + 4))] = 0.000000e+00f;
      compute_local[((((yy_c_init * 2) + xx_c_init) + 20))] = 0.000000e+00f;
      compute_local[((((yy_c_init * 2) + xx_c_init) + 36))] = 0.000000e+00f;
      compute_local[((((yy_c_init * 2) + xx_c_init) + 52))] = 0.000000e+00f;
      compute_local[((((yy_c_init * 2) + xx_c_init) + 12))] = 0.000000e+00f;
      compute_local[((((yy_c_init * 2) + xx_c_init) + 28))] = 0.000000e+00f;
      compute_local[((((yy_c_init * 2) + xx_c_init) + 44))] = 0.000000e+00f;
      compute_local[((((yy_c_init * 2) + xx_c_init) + 60))] = 0.000000e+00f;
    }
  }
  for (int rc_outer = 0; rc_outer < 32; ++rc_outer) {
    __syncthreads();
    for (int ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner = 0; ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner < 5; ++ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner) {
      if (((((((int)threadIdx.x) * 5) + ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner) / 68) + ((int)threadIdx.z)) < 8) {
        if ((((((int)threadIdx.z) * 68) + (((int)threadIdx.x) * 5)) + ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner) < 544) {
          if (((((int)threadIdx.x) * 5) + ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner) < 68) {
            pad_temp_shared[((((((int)threadIdx.z) * 68) + (((int)threadIdx.x) * 5)) + ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner))] = (((((2 <= ((((int)blockIdx.y) * 4) + ((int)threadIdx.z))) && (((((int)blockIdx.y) * 4) + ((int)threadIdx.z)) < 258)) && (2 <= (((((int)blockIdx.x) * 64) + (((int)threadIdx.x) * 5)) + ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner))) && ((((((int)blockIdx.x) * 64) + (((int)threadIdx.x) * 5)) + ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner) < 258)) ? data[((((((((rc_outer * 65536) + (((int)blockIdx.y) * 1024)) + (((int)threadIdx.z) * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 5)) + ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner) - 514))] : 0.000000e+00f);
          }
        }
      }
    }
    for (int ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner1 = 0; ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner1 < 7; ++ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner1) {
      if (((((int)threadIdx.z) * 4) + (((((int)threadIdx.x) * 7) + ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner1) / 25)) < 32) {
        if (((((int)threadIdx.z) * 20) + (((((int)threadIdx.x) * 7) + ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner1) / 5)) < 160) {
          if ((((((int)threadIdx.z) * 100) + (((int)threadIdx.x) * 7)) + ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner1) < 800) {
            if (((((int)threadIdx.x) * 7) + ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner1) < 100) {
              kernel_shared[((((((int)threadIdx.z) * 100) + (((int)threadIdx.x) * 7)) + ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner1))] = kernel[(((((((int)threadIdx.z) * 3200) + ((((((int)threadIdx.x) * 7) + ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner1) / 25) * 800)) + (rc_outer * 25)) + (((((int)threadIdx.x) * 7) + ax0_ax1_fused_ax2_fused_ax3_fused_inner_inner_inner1) % 25)))];
            }
          }
        }
      }
    }
    __syncthreads();
    for (int ry_inner_outer = 0; ry_inner_outer < 5; ++ry_inner_outer) {
      for (int rx_inner_outer = 0; rx_inner_outer < 5; ++rx_inner_outer) {
        for (int ax2 = 0; ax2 < 2; ++ax2) {
          for (int ax3 = 0; ax3 < 2; ++ax3) {
            pad_temp_shared_local[(((ax2 * 2) + ax3))] = pad_temp_shared[((((((ax2 * 68) + (ry_inner_outer * 68)) + (((int)threadIdx.x) * 2)) + ax3) + rx_inner_outer))];
            pad_temp_shared_local[((((ax2 * 2) + ax3) + 8))] = pad_temp_shared[(((((((ax2 * 68) + (ry_inner_outer * 68)) + (((int)threadIdx.x) * 2)) + ax3) + rx_inner_outer) + 136))];
            pad_temp_shared_local[((((ax2 * 2) + ax3) + 4))] = pad_temp_shared[(((((((ax2 * 68) + (ry_inner_outer * 68)) + (((int)threadIdx.x) * 2)) + ax3) + rx_inner_outer) + 32))];
            pad_temp_shared_local[((((ax2 * 2) + ax3) + 12))] = pad_temp_shared[(((((((ax2 * 68) + (ry_inner_outer * 68)) + (((int)threadIdx.x) * 2)) + ax3) + rx_inner_outer) + 168))];
          }
        }
        kernel_shared_local[(0)] = kernel_shared[((((((int)threadIdx.z) * 25) + (ry_inner_outer * 5)) + rx_inner_outer))];
        kernel_shared_local[(1)] = kernel_shared[(((((((int)threadIdx.z) * 25) + (ry_inner_outer * 5)) + rx_inner_outer) + 200))];
        kernel_shared_local[(2)] = kernel_shared[(((((((int)threadIdx.z) * 25) + (ry_inner_outer * 5)) + rx_inner_outer) + 400))];
        kernel_shared_local[(3)] = kernel_shared[(((((((int)threadIdx.z) * 25) + (ry_inner_outer * 5)) + rx_inner_outer) + 600))];
        for (int yy_c = 0; yy_c < 2; ++yy_c) {
          for (int xx_c = 0; xx_c < 2; ++xx_c) {
            compute_local[(((yy_c * 2) + xx_c))] = (compute_local[(((yy_c * 2) + xx_c))] + (pad_temp_shared_local[(((yy_c * 2) + xx_c))] * kernel_shared_local[(0)]));
            compute_local[((((yy_c * 2) + xx_c) + 16))] = (compute_local[((((yy_c * 2) + xx_c) + 16))] + (pad_temp_shared_local[(((yy_c * 2) + xx_c))] * kernel_shared_local[(1)]));
            compute_local[((((yy_c * 2) + xx_c) + 32))] = (compute_local[((((yy_c * 2) + xx_c) + 32))] + (pad_temp_shared_local[(((yy_c * 2) + xx_c))] * kernel_shared_local[(2)]));
            compute_local[((((yy_c * 2) + xx_c) + 48))] = (compute_local[((((yy_c * 2) + xx_c) + 48))] + (pad_temp_shared_local[(((yy_c * 2) + xx_c))] * kernel_shared_local[(3)]));
            compute_local[((((yy_c * 2) + xx_c) + 8))] = (compute_local[((((yy_c * 2) + xx_c) + 8))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 8))] * kernel_shared_local[(0)]));
            compute_local[((((yy_c * 2) + xx_c) + 24))] = (compute_local[((((yy_c * 2) + xx_c) + 24))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 8))] * kernel_shared_local[(1)]));
            compute_local[((((yy_c * 2) + xx_c) + 40))] = (compute_local[((((yy_c * 2) + xx_c) + 40))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 8))] * kernel_shared_local[(2)]));
            compute_local[((((yy_c * 2) + xx_c) + 56))] = (compute_local[((((yy_c * 2) + xx_c) + 56))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 8))] * kernel_shared_local[(3)]));
            compute_local[((((yy_c * 2) + xx_c) + 4))] = (compute_local[((((yy_c * 2) + xx_c) + 4))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 4))] * kernel_shared_local[(0)]));
            compute_local[((((yy_c * 2) + xx_c) + 20))] = (compute_local[((((yy_c * 2) + xx_c) + 20))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 4))] * kernel_shared_local[(1)]));
            compute_local[((((yy_c * 2) + xx_c) + 36))] = (compute_local[((((yy_c * 2) + xx_c) + 36))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 4))] * kernel_shared_local[(2)]));
            compute_local[((((yy_c * 2) + xx_c) + 52))] = (compute_local[((((yy_c * 2) + xx_c) + 52))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 4))] * kernel_shared_local[(3)]));
            compute_local[((((yy_c * 2) + xx_c) + 12))] = (compute_local[((((yy_c * 2) + xx_c) + 12))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 12))] * kernel_shared_local[(0)]));
            compute_local[((((yy_c * 2) + xx_c) + 28))] = (compute_local[((((yy_c * 2) + xx_c) + 28))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 12))] * kernel_shared_local[(1)]));
            compute_local[((((yy_c * 2) + xx_c) + 44))] = (compute_local[((((yy_c * 2) + xx_c) + 44))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 12))] * kernel_shared_local[(2)]));
            compute_local[((((yy_c * 2) + xx_c) + 60))] = (compute_local[((((yy_c * 2) + xx_c) + 60))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 12))] * kernel_shared_local[(3)]));
          }
        }
      }
    }
  }
  for (int yy_inner_inner_inner = 0; yy_inner_inner_inner < 2; ++yy_inner_inner_inner) {
    for (int xx_inner_inner_inner = 0; xx_inner_inner_inner < 2; ++xx_inner_inner_inner) {
      compute[(((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_inner_inner_inner * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_inner_inner_inner))] = compute_local[(((yy_inner_inner_inner * 2) + xx_inner_inner_inner))];
      compute[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_inner_inner_inner * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_inner_inner_inner) + 524288))] = compute_local[((((yy_inner_inner_inner * 2) + xx_inner_inner_inner) + 16))];
      compute[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_inner_inner_inner * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_inner_inner_inner) + 1048576))] = compute_local[((((yy_inner_inner_inner * 2) + xx_inner_inner_inner) + 32))];
      compute[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_inner_inner_inner * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_inner_inner_inner) + 1572864))] = compute_local[((((yy_inner_inner_inner * 2) + xx_inner_inner_inner) + 48))];
      compute[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_inner_inner_inner * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_inner_inner_inner) + 512))] = compute_local[((((yy_inner_inner_inner * 2) + xx_inner_inner_inner) + 8))];
      compute[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_inner_inner_inner * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_inner_inner_inner) + 524800))] = compute_local[((((yy_inner_inner_inner * 2) + xx_inner_inner_inner) + 24))];
      compute[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_inner_inner_inner * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_inner_inner_inner) + 1049088))] = compute_local[((((yy_inner_inner_inner * 2) + xx_inner_inner_inner) + 40))];
      compute[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_inner_inner_inner * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_inner_inner_inner) + 1573376))] = compute_local[((((yy_inner_inner_inner * 2) + xx_inner_inner_inner) + 56))];
      compute[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_inner_inner_inner * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_inner_inner_inner) + 32))] = compute_local[((((yy_inner_inner_inner * 2) + xx_inner_inner_inner) + 4))];
      compute[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_inner_inner_inner * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_inner_inner_inner) + 524320))] = compute_local[((((yy_inner_inner_inner * 2) + xx_inner_inner_inner) + 20))];
      compute[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_inner_inner_inner * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_inner_inner_inner) + 1048608))] = compute_local[((((yy_inner_inner_inner * 2) + xx_inner_inner_inner) + 36))];
      compute[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_inner_inner_inner * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_inner_inner_inner) + 1572896))] = compute_local[((((yy_inner_inner_inner * 2) + xx_inner_inner_inner) + 52))];
      compute[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_inner_inner_inner * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_inner_inner_inner) + 544))] = compute_local[((((yy_inner_inner_inner * 2) + xx_inner_inner_inner) + 12))];
      compute[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_inner_inner_inner * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_inner_inner_inner) + 524832))] = compute_local[((((yy_inner_inner_inner * 2) + xx_inner_inner_inner) + 28))];
      compute[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_inner_inner_inner * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_inner_inner_inner) + 1049120))] = compute_local[((((yy_inner_inner_inner * 2) + xx_inner_inner_inner) + 44))];
      compute[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_inner_inner_inner * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_inner_inner_inner) + 1573408))] = compute_local[((((yy_inner_inner_inner * 2) + xx_inner_inner_inner) + 60))];
    }
  }
}

extern "C" __global__ void conv_partially_fused(float* __restrict__ data,
						float* __restrict__ kernel5,
						float* __restrict__ kernel3,
						float* __restrict__ compute5,
						float* __restrict__ compute3) {
  float compute5_local[64];
  float compute3_local[64];
  __shared__ float pad_temp_shared[544];
  __shared__ float kernel5_shared[800];
  __shared__ float kernel3_shared[288];
  float pad_temp_shared_local[16];
  float kernel_shared_local[4];
  for (int yy_c_init = 0; yy_c_init < 2; ++yy_c_init) {
    for (int xx_c_init = 0; xx_c_init < 2; ++xx_c_init) {
      compute5_local[(((yy_c_init * 2) + xx_c_init))] = 0.000000e+00f;
      compute5_local[((((yy_c_init * 2) + xx_c_init) + 16))] = 0.000000e+00f;
      compute5_local[((((yy_c_init * 2) + xx_c_init) + 32))] = 0.000000e+00f;
      compute5_local[((((yy_c_init * 2) + xx_c_init) + 48))] = 0.000000e+00f;
      compute5_local[((((yy_c_init * 2) + xx_c_init) + 8))] = 0.000000e+00f;
      compute5_local[((((yy_c_init * 2) + xx_c_init) + 24))] = 0.000000e+00f;
      compute5_local[((((yy_c_init * 2) + xx_c_init) + 40))] = 0.000000e+00f;
      compute5_local[((((yy_c_init * 2) + xx_c_init) + 56))] = 0.000000e+00f;
      compute5_local[((((yy_c_init * 2) + xx_c_init) + 4))] = 0.000000e+00f;
      compute5_local[((((yy_c_init * 2) + xx_c_init) + 20))] = 0.000000e+00f;
      compute5_local[((((yy_c_init * 2) + xx_c_init) + 36))] = 0.000000e+00f;
      compute5_local[((((yy_c_init * 2) + xx_c_init) + 52))] = 0.000000e+00f;
      compute5_local[((((yy_c_init * 2) + xx_c_init) + 12))] = 0.000000e+00f;
      compute5_local[((((yy_c_init * 2) + xx_c_init) + 28))] = 0.000000e+00f;
      compute5_local[((((yy_c_init * 2) + xx_c_init) + 44))] = 0.000000e+00f;
      compute5_local[((((yy_c_init * 2) + xx_c_init) + 60))] = 0.000000e+00f;

      compute3_local[(((yy_c_init * 2) + xx_c_init))] = 0.000000e+00f;
      compute3_local[((((yy_c_init * 2) + xx_c_init) + 16))] = 0.000000e+00f;
      compute3_local[((((yy_c_init * 2) + xx_c_init) + 32))] = 0.000000e+00f;
      compute3_local[((((yy_c_init * 2) + xx_c_init) + 48))] = 0.000000e+00f;
      compute3_local[((((yy_c_init * 2) + xx_c_init) + 8))] = 0.000000e+00f;
      compute3_local[((((yy_c_init * 2) + xx_c_init) + 24))] = 0.000000e+00f;
      compute3_local[((((yy_c_init * 2) + xx_c_init) + 40))] = 0.000000e+00f;
      compute3_local[((((yy_c_init * 2) + xx_c_init) + 56))] = 0.000000e+00f;
      compute3_local[((((yy_c_init * 2) + xx_c_init) + 4))] = 0.000000e+00f;
      compute3_local[((((yy_c_init * 2) + xx_c_init) + 20))] = 0.000000e+00f;
      compute3_local[((((yy_c_init * 2) + xx_c_init) + 36))] = 0.000000e+00f;
      compute3_local[((((yy_c_init * 2) + xx_c_init) + 52))] = 0.000000e+00f;
      compute3_local[((((yy_c_init * 2) + xx_c_init) + 12))] = 0.000000e+00f;
      compute3_local[((((yy_c_init * 2) + xx_c_init) + 28))] = 0.000000e+00f;
      compute3_local[((((yy_c_init * 2) + xx_c_init) + 44))] = 0.000000e+00f;
      compute3_local[((((yy_c_init * 2) + xx_c_init) + 60))] = 0.000000e+00f;
    }
  }
  for (int rc_outer = 0; rc_outer < 32; ++rc_outer) {
    __syncthreads();
    // Load image to shared
    for (int ax_ffiii = 0; ax_ffiii < 5; ++ax_ffiii) {
      if (((((((int)threadIdx.x) * 5) + ax_ffiii) / 68) + ((int)threadIdx.z)) < 8) {
        if ((((((int)threadIdx.z) * 68) + (((int)threadIdx.x) * 5)) + ax_ffiii) < 544) {
          if (((((int)threadIdx.x) * 5) + ax_ffiii) < 68) {
            pad_temp_shared[((((((int)threadIdx.z) * 68) + (((int)threadIdx.x) * 5)) + ax_ffiii))] = (((((2 <= ((((int)blockIdx.y) * 4) + ((int)threadIdx.z))) && (((((int)blockIdx.y) * 4) + ((int)threadIdx.z)) < 258)) && (2 <= (((((int)blockIdx.x) * 64) + (((int)threadIdx.x) * 5)) + ax_ffiii))) && ((((((int)blockIdx.x) * 64) + (((int)threadIdx.x) * 5)) + ax_ffiii) < 258)) ? data[((((((((rc_outer * 65536) + (((int)blockIdx.y) * 1024)) + (((int)threadIdx.z) * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 5)) + ax_ffiii) - 514))] : 0.000000e+00f);
          }
        }
      }
    }

    // Load 5x5 kernel to shared
    for (int ax_ffiii1 = 0; ax_ffiii1 < 7; ++ax_ffiii1) {
      if (((((int)threadIdx.z) * 4) + (((((int)threadIdx.x) * 7) + ax_ffiii1) / 25)) < 32) {
        if (((((int)threadIdx.z) * 20) + (((((int)threadIdx.x) * 7) + ax_ffiii1) / 5)) < 160) {
          if ((((((int)threadIdx.z) * 100) + (((int)threadIdx.x) * 7)) + ax_ffiii1) < 800) {
            if (((((int)threadIdx.x) * 7) + ax_ffiii1) < 100) {
              kernel5_shared[((((((int)threadIdx.z) * 100) + (((int)threadIdx.x) * 7)) + ax_ffiii1))] = kernel5[(((((((int)threadIdx.z) * 3200) + ((((((int)threadIdx.x) * 7) + ax_ffiii1) / 25) * 800)) + (rc_outer * 25)) + (((((int)threadIdx.x) * 7) + ax_ffiii1) % 25)))];
            }
          }
        }
      }
    }

    // Load 3x3 kernel to shared
    for (int ax_ffiii1 = 0; ax_ffiii1 < 3; ++ax_ffiii1) {
      if (((((int)threadIdx.z) * 4) + (((((int)threadIdx.x) * 3) + ax_ffiii1) / 9)) < 32) {
        if (((((int)threadIdx.z) * 12) + (((((int)threadIdx.x) * 3) + ax_ffiii1) / 3)) < 96) {
          if ((((((int)threadIdx.z) * 36) + (((int)threadIdx.x) * 3)) + ax_ffiii1) < 288) {
            if (((((int)threadIdx.x) * 3) + ax_ffiii1) < 36) {
              kernel3_shared[((((((int)threadIdx.z) * 36) + (((int)threadIdx.x) * 3)) + ax_ffiii1))] = kernel3[(((((((int)threadIdx.z) * 1152) + ((((((int)threadIdx.x) * 3) + ax_ffiii1) / 25) * 288)) + (rc_outer * 9)) + (((((int)threadIdx.x) * 3) + ax_ffiii1) % 9)))];
            }
          }
        }
      }
    }
    __syncthreads();

    // 5x5 reduction in registers
    for (int ry_io = 0; ry_io < 5; ++ry_io) {
      for (int rx_io = 0; rx_io < 5; ++rx_io) {
        for (int ax2 = 0; ax2 < 2; ++ax2) {
          for (int ax3 = 0; ax3 < 2; ++ax3) {
            pad_temp_shared_local[(((ax2 * 2) + ax3))] = pad_temp_shared[((((((ax2 * 68) + (ry_io * 68)) + (((int)threadIdx.x) * 2)) + ax3) + rx_io))];
            pad_temp_shared_local[((((ax2 * 2) + ax3) + 8))] = pad_temp_shared[(((((((ax2 * 68) + (ry_io * 68)) + (((int)threadIdx.x) * 2)) + ax3) + rx_io) + 136))];
            pad_temp_shared_local[((((ax2 * 2) + ax3) + 4))] = pad_temp_shared[(((((((ax2 * 68) + (ry_io * 68)) + (((int)threadIdx.x) * 2)) + ax3) + rx_io) + 32))];
            pad_temp_shared_local[((((ax2 * 2) + ax3) + 12))] = pad_temp_shared[(((((((ax2 * 68) + (ry_io * 68)) + (((int)threadIdx.x) * 2)) + ax3) + rx_io) + 168))];
          }
        }
        kernel_shared_local[(0)] = kernel5_shared[((((((int)threadIdx.z) * 25) + (ry_io * 5)) + rx_io))];
        kernel_shared_local[(1)] = kernel5_shared[(((((((int)threadIdx.z) * 25) + (ry_io * 5)) + rx_io) + 200))];
        kernel_shared_local[(2)] = kernel5_shared[(((((((int)threadIdx.z) * 25) + (ry_io * 5)) + rx_io) + 400))];
        kernel_shared_local[(3)] = kernel5_shared[(((((((int)threadIdx.z) * 25) + (ry_io * 5)) + rx_io) + 600))];
        for (int yy_c = 0; yy_c < 2; ++yy_c) {
          for (int xx_c = 0; xx_c < 2; ++xx_c) {
            compute5_local[(((yy_c * 2) + xx_c))] = (compute5_local[(((yy_c * 2) + xx_c))] + (pad_temp_shared_local[(((yy_c * 2) + xx_c))] * kernel_shared_local[(0)]));
            compute5_local[((((yy_c * 2) + xx_c) + 16))] = (compute5_local[((((yy_c * 2) + xx_c) + 16))] + (pad_temp_shared_local[(((yy_c * 2) + xx_c))] * kernel_shared_local[(1)]));
            compute5_local[((((yy_c * 2) + xx_c) + 32))] = (compute5_local[((((yy_c * 2) + xx_c) + 32))] + (pad_temp_shared_local[(((yy_c * 2) + xx_c))] * kernel_shared_local[(2)]));
            compute5_local[((((yy_c * 2) + xx_c) + 48))] = (compute5_local[((((yy_c * 2) + xx_c) + 48))] + (pad_temp_shared_local[(((yy_c * 2) + xx_c))] * kernel_shared_local[(3)]));
            compute5_local[((((yy_c * 2) + xx_c) + 8))] = (compute5_local[((((yy_c * 2) + xx_c) + 8))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 8))] * kernel_shared_local[(0)]));
            compute5_local[((((yy_c * 2) + xx_c) + 24))] = (compute5_local[((((yy_c * 2) + xx_c) + 24))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 8))] * kernel_shared_local[(1)]));
            compute5_local[((((yy_c * 2) + xx_c) + 40))] = (compute5_local[((((yy_c * 2) + xx_c) + 40))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 8))] * kernel_shared_local[(2)]));
            compute5_local[((((yy_c * 2) + xx_c) + 56))] = (compute5_local[((((yy_c * 2) + xx_c) + 56))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 8))] * kernel_shared_local[(3)]));
            compute5_local[((((yy_c * 2) + xx_c) + 4))] = (compute5_local[((((yy_c * 2) + xx_c) + 4))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 4))] * kernel_shared_local[(0)]));
            compute5_local[((((yy_c * 2) + xx_c) + 20))] = (compute5_local[((((yy_c * 2) + xx_c) + 20))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 4))] * kernel_shared_local[(1)]));
            compute5_local[((((yy_c * 2) + xx_c) + 36))] = (compute5_local[((((yy_c * 2) + xx_c) + 36))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 4))] * kernel_shared_local[(2)]));
            compute5_local[((((yy_c * 2) + xx_c) + 52))] = (compute5_local[((((yy_c * 2) + xx_c) + 52))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 4))] * kernel_shared_local[(3)]));
            compute5_local[((((yy_c * 2) + xx_c) + 12))] = (compute5_local[((((yy_c * 2) + xx_c) + 12))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 12))] * kernel_shared_local[(0)]));
            compute5_local[((((yy_c * 2) + xx_c) + 28))] = (compute5_local[((((yy_c * 2) + xx_c) + 28))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 12))] * kernel_shared_local[(1)]));
            compute5_local[((((yy_c * 2) + xx_c) + 44))] = (compute5_local[((((yy_c * 2) + xx_c) + 44))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 12))] * kernel_shared_local[(2)]));
            compute5_local[((((yy_c * 2) + xx_c) + 60))] = (compute5_local[((((yy_c * 2) + xx_c) + 60))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 12))] * kernel_shared_local[(3)]));
          }
        }
      }
    }

    // 3x3 reduction in registers
    for (int ry_io = 0; ry_io < 3; ++ry_io) {
      for (int rx_io = 0; rx_io < 3; ++rx_io) {
        for (int ax2 = 0; ax2 < 2; ++ax2) {
          for (int ax3 = 0; ax3 < 2; ++ax3) {
            pad_temp_shared_local[(((ax2 * 2) + ax3))] = pad_temp_shared[((((((ax2 * 68) + (ry_io * 68)) + (((int)threadIdx.x) * 2)) + ax3) + rx_io))];
            pad_temp_shared_local[((((ax2 * 2) + ax3) + 8))] = pad_temp_shared[(((((((ax2 * 68) + (ry_io * 68)) + (((int)threadIdx.x) * 2)) + ax3) + rx_io) + 136))];
            pad_temp_shared_local[((((ax2 * 2) + ax3) + 4))] = pad_temp_shared[(((((((ax2 * 68) + (ry_io * 68)) + (((int)threadIdx.x) * 2)) + ax3) + rx_io) + 32))];
            pad_temp_shared_local[((((ax2 * 2) + ax3) + 12))] = pad_temp_shared[(((((((ax2 * 68) + (ry_io * 68)) + (((int)threadIdx.x) * 2)) + ax3) + rx_io) + 168))];
          }
        }
        kernel_shared_local[(0)] = kernel3_shared[((((((int)threadIdx.z) * 9) + (ry_io * 3)) + rx_io))];
        kernel_shared_local[(1)] = kernel3_shared[(((((((int)threadIdx.z) * 9) + (ry_io * 3)) + rx_io) + 72))];
        kernel_shared_local[(2)] = kernel3_shared[(((((((int)threadIdx.z) * 9) + (ry_io * 3)) + rx_io) + 144))];
        kernel_shared_local[(3)] = kernel3_shared[(((((((int)threadIdx.z) * 9) + (ry_io * 3)) + rx_io) + 216))];
        for (int yy_c = 0; yy_c < 2; ++yy_c) {
          for (int xx_c = 0; xx_c < 2; ++xx_c) {
            compute3_local[(((yy_c * 2) + xx_c))] = (compute3_local[(((yy_c * 2) + xx_c))] + (pad_temp_shared_local[(((yy_c * 2) + xx_c))] * kernel_shared_local[(0)]));
            compute3_local[((((yy_c * 2) + xx_c) + 16))] = (compute3_local[((((yy_c * 2) + xx_c) + 16))] + (pad_temp_shared_local[(((yy_c * 2) + xx_c))] * kernel_shared_local[(1)]));
            compute3_local[((((yy_c * 2) + xx_c) + 32))] = (compute3_local[((((yy_c * 2) + xx_c) + 32))] + (pad_temp_shared_local[(((yy_c * 2) + xx_c))] * kernel_shared_local[(2)]));
            compute3_local[((((yy_c * 2) + xx_c) + 48))] = (compute3_local[((((yy_c * 2) + xx_c) + 48))] + (pad_temp_shared_local[(((yy_c * 2) + xx_c))] * kernel_shared_local[(3)]));
            compute3_local[((((yy_c * 2) + xx_c) + 8))] = (compute3_local[((((yy_c * 2) + xx_c) + 8))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 8))] * kernel_shared_local[(0)]));
            compute3_local[((((yy_c * 2) + xx_c) + 24))] = (compute3_local[((((yy_c * 2) + xx_c) + 24))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 8))] * kernel_shared_local[(1)]));
            compute3_local[((((yy_c * 2) + xx_c) + 40))] = (compute3_local[((((yy_c * 2) + xx_c) + 40))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 8))] * kernel_shared_local[(2)]));
            compute3_local[((((yy_c * 2) + xx_c) + 56))] = (compute3_local[((((yy_c * 2) + xx_c) + 56))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 8))] * kernel_shared_local[(3)]));
            compute3_local[((((yy_c * 2) + xx_c) + 4))] = (compute3_local[((((yy_c * 2) + xx_c) + 4))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 4))] * kernel_shared_local[(0)]));
            compute3_local[((((yy_c * 2) + xx_c) + 20))] = (compute3_local[((((yy_c * 2) + xx_c) + 20))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 4))] * kernel_shared_local[(1)]));
            compute3_local[((((yy_c * 2) + xx_c) + 36))] = (compute3_local[((((yy_c * 2) + xx_c) + 36))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 4))] * kernel_shared_local[(2)]));
            compute3_local[((((yy_c * 2) + xx_c) + 52))] = (compute3_local[((((yy_c * 2) + xx_c) + 52))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 4))] * kernel_shared_local[(3)]));
            compute3_local[((((yy_c * 2) + xx_c) + 12))] = (compute3_local[((((yy_c * 2) + xx_c) + 12))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 12))] * kernel_shared_local[(0)]));
            compute3_local[((((yy_c * 2) + xx_c) + 28))] = (compute3_local[((((yy_c * 2) + xx_c) + 28))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 12))] * kernel_shared_local[(1)]));
            compute3_local[((((yy_c * 2) + xx_c) + 44))] = (compute3_local[((((yy_c * 2) + xx_c) + 44))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 12))] * kernel_shared_local[(2)]));
            compute3_local[((((yy_c * 2) + xx_c) + 60))] = (compute3_local[((((yy_c * 2) + xx_c) + 60))] + (pad_temp_shared_local[((((yy_c * 2) + xx_c) + 12))] * kernel_shared_local[(3)]));
          }
        }
      }
    }
  }

  // Store to global
  for (int yy_iii = 0; yy_iii < 2; ++yy_iii) {
    for (int xx_iii = 0; xx_iii < 2; ++xx_iii) {
      compute5[(((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_iii * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_iii))] = compute5_local[(((yy_iii * 2) + xx_iii))];
      compute5[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_iii * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_iii) + 524288))] = compute5_local[((((yy_iii * 2) + xx_iii) + 16))];
      compute5[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_iii * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_iii) + 1048576))] = compute5_local[((((yy_iii * 2) + xx_iii) + 32))];
      compute5[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_iii * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_iii) + 1572864))] = compute5_local[((((yy_iii * 2) + xx_iii) + 48))];
      compute5[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_iii * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_iii) + 512))] = compute5_local[((((yy_iii * 2) + xx_iii) + 8))];
      compute5[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_iii * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_iii) + 524800))] = compute5_local[((((yy_iii * 2) + xx_iii) + 24))];
      compute5[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_iii * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_iii) + 1049088))] = compute5_local[((((yy_iii * 2) + xx_iii) + 40))];
      compute5[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_iii * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_iii) + 1573376))] = compute5_local[((((yy_iii * 2) + xx_iii) + 56))];
      compute5[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_iii * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_iii) + 32))] = compute5_local[((((yy_iii * 2) + xx_iii) + 4))];
      compute5[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_iii * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_iii) + 524320))] = compute5_local[((((yy_iii * 2) + xx_iii) + 20))];
      compute5[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_iii * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_iii) + 1048608))] = compute5_local[((((yy_iii * 2) + xx_iii) + 36))];
      compute5[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_iii * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_iii) + 1572896))] = compute5_local[((((yy_iii * 2) + xx_iii) + 52))];
      compute5[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_iii * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_iii) + 544))] = compute5_local[((((yy_iii * 2) + xx_iii) + 12))];
      compute5[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_iii * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_iii) + 524832))] = compute5_local[((((yy_iii * 2) + xx_iii) + 28))];
      compute5[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_iii * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_iii) + 1049120))] = compute5_local[((((yy_iii * 2) + xx_iii) + 44))];
      compute5[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_iii * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_iii) + 1573408))] = compute5_local[((((yy_iii * 2) + xx_iii) + 60))];


      compute3[(((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_iii * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_iii))] = compute3_local[(((yy_iii * 2) + xx_iii))];
      compute3[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_iii * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_iii) + 524288))] = compute3_local[((((yy_iii * 2) + xx_iii) + 16))];
      compute3[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_iii * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_iii) + 1048576))] = compute3_local[((((yy_iii * 2) + xx_iii) + 32))];
      compute3[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_iii * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_iii) + 1572864))] = compute3_local[((((yy_iii * 2) + xx_iii) + 48))];
      compute3[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_iii * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_iii) + 512))] = compute3_local[((((yy_iii * 2) + xx_iii) + 8))];
      compute3[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_iii * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_iii) + 524800))] = compute3_local[((((yy_iii * 2) + xx_iii) + 24))];
      compute3[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_iii * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_iii) + 1049088))] = compute3_local[((((yy_iii * 2) + xx_iii) + 40))];
      compute3[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_iii * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_iii) + 1573376))] = compute3_local[((((yy_iii * 2) + xx_iii) + 56))];
      compute3[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_iii * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_iii) + 32))] = compute3_local[((((yy_iii * 2) + xx_iii) + 4))];
      compute3[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_iii * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_iii) + 524320))] = compute3_local[((((yy_iii * 2) + xx_iii) + 20))];
      compute3[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_iii * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_iii) + 1048608))] = compute3_local[((((yy_iii * 2) + xx_iii) + 36))];
      compute3[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_iii * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_iii) + 1572896))] = compute3_local[((((yy_iii * 2) + xx_iii) + 52))];
      compute3[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_iii * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_iii) + 544))] = compute3_local[((((yy_iii * 2) + xx_iii) + 12))];
      compute3[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_iii * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_iii) + 524832))] = compute3_local[((((yy_iii * 2) + xx_iii) + 28))];
      compute3[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_iii * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_iii) + 1049120))] = compute3_local[((((yy_iii * 2) + xx_iii) + 44))];
      compute3[((((((((((int)threadIdx.z) * 65536) + (((int)blockIdx.y) * 1024)) + (yy_iii * 256)) + (((int)blockIdx.x) * 64)) + (((int)threadIdx.x) * 2)) + xx_iii) + 1573408))] = compute3_local[((((yy_iii * 2) + xx_iii) + 60))];
    }
  }
}

extern "C" __global__ void conv_partially_fused_old(float* __restrict__ data,
						    float* __restrict__ kernel5,
						    float* __restrict__ kernel3,
						    float* __restrict__ compute5,
						    float* __restrict__ compute3) {
  float compute5_local[64];
  float compute3_local[64];
  __shared__ float pad_temp_shared[1600];
  __shared__ float kernel5_shared[320];
  __shared__ float kernel3_shared[192];
  float pad_temp_shared_local[16];
  float kernel_shared_local[4];
  for (int ff_c_init = 0; ff_c_init < 4; ++ff_c_init) {
    for (int xx_c_init = 0; xx_c_init < 4; ++xx_c_init) {
      compute5_local[(((ff_c_init * 4) + xx_c_init))] = 0.000000e+00f;
      compute5_local[((((ff_c_init * 4) + xx_c_init) + 16))] = 0.000000e+00f;
      compute5_local[((((ff_c_init * 4) + xx_c_init) + 32))] = 0.000000e+00f;
      compute5_local[((((ff_c_init * 4) + xx_c_init) + 48))] = 0.000000e+00f;
      compute3_local[(((ff_c_init * 4) + xx_c_init))] = 0.000000e+00f;
      compute3_local[((((ff_c_init * 4) + xx_c_init) + 16))] = 0.000000e+00f;
      compute3_local[((((ff_c_init * 4) + xx_c_init) + 32))] = 0.000000e+00f;
      compute3_local[((((ff_c_init * 4) + xx_c_init) + 48))] = 0.000000e+00f;
    }
  }
  for (int rc_outer = 0; rc_outer < 16; ++rc_outer) {
    for (int ry_outer = 0; ry_outer < 5; ++ry_outer) {
      __syncthreads();
      for (int mfi = 0; mfi < 5; ++mfi) {
        pad_temp_shared[ry_outer * 320 + (((((threadIdx.z * 40) + (threadIdx.y * 20)) + (threadIdx.x * 5)) + mfi))] = (((((2 <= (((blockIdx.y * 8) + ry_outer) + (((threadIdx.z * 2) + threadIdx.y) & 7))) && ((((blockIdx.y * 8) + ry_outer) + (((threadIdx.z * 2) + threadIdx.y) & 7)) < 258)) && (2 <= (((blockIdx.x * 16) + (threadIdx.x * 5)) + mfi))) && ((((blockIdx.x * 16) + (threadIdx.x * 5)) + mfi) < 258)) ? data[((((((((((rc_outer * 131072) + ((((threadIdx.z * 2) + threadIdx.y) >> 3) * 65536)) + (blockIdx.y * 2048)) + (ry_outer * 256)) + ((((threadIdx.z * 2) + threadIdx.y) & 7) * 256)) + (blockIdx.x * 16)) + (threadIdx.x * 5)) + mfi) - 514))] : 0.000000e+00f);
      }
    }

    for (int ry_outer = 0; ry_outer < 5; ++ry_outer) {
      __syncthreads();
      for (int mfi1 = 0; mfi1 < 5; ++mfi1) {
        kernel5_shared[(((((threadIdx.z * 40) + (threadIdx.y * 20)) + (threadIdx.x * 5)) + mfi1))] = kernel5[((((((((threadIdx.z * 3200) + (threadIdx.y * 1600)) + ((threadIdx.x >> 1) * 800)) + (rc_outer * 50)) + ((threadIdx.x & 1) * 25)) + (ry_outer * 5)) + mfi1))];
      }
      __syncthreads();
      for (int rc_io = 0; rc_io < 2; ++rc_io) {
        for (int rx_io = 0; rx_io < 5; ++rx_io) {
          for (int ax3 = 0; ax3 < 4; ++ax3) {
            pad_temp_shared_local[(ax3)] = pad_temp_shared[ry_outer*320 + ((((((rc_io * 160) + (threadIdx.y * 20)) + (threadIdx.x * 4)) + ax3) + rx_io))];
            pad_temp_shared_local[((ax3 + 4))] = pad_temp_shared[ry_outer*320 + (((((((rc_io * 160) + (threadIdx.y * 20)) + (threadIdx.x * 4)) + ax3) + rx_io) + 40))];
            pad_temp_shared_local[((ax3 + 8))] = pad_temp_shared[ry_outer*320 + (((((((rc_io * 160) + (threadIdx.y * 20)) + (threadIdx.x * 4)) + ax3) + rx_io) + 80))];
            pad_temp_shared_local[((ax3 + 12))] = pad_temp_shared[ry_outer*320 + (((((((rc_io * 160) + (threadIdx.y * 20)) + (threadIdx.x * 4)) + ax3) + rx_io) + 120))];
          }
          for (int ax0 = 0; ax0 < 4; ++ax0) {
            kernel_shared_local[(ax0)] = kernel5_shared[(((((threadIdx.z * 40) + (ax0 * 10)) + (rc_io * 5)) + rx_io))];
          }
          for (int ff_c = 0; ff_c < 4; ++ff_c) {
            for (int xx_c = 0; xx_c < 4; ++xx_c) {
              compute5_local[(((ff_c * 4) + xx_c))] = (compute5_local[(((ff_c * 4) + xx_c))] + (pad_temp_shared_local[(xx_c)] * kernel_shared_local[(ff_c)]));
              compute5_local[((((ff_c * 4) + xx_c) + 16))] = (compute5_local[((((ff_c * 4) + xx_c) + 16))] + (pad_temp_shared_local[((xx_c + 4))] * kernel_shared_local[(ff_c)]));
              compute5_local[((((ff_c * 4) + xx_c) + 32))] = (compute5_local[((((ff_c * 4) + xx_c) + 32))] + (pad_temp_shared_local[((xx_c + 8))] * kernel_shared_local[(ff_c)]));
              compute5_local[((((ff_c * 4) + xx_c) + 48))] = (compute5_local[((((ff_c * 4) + xx_c) + 48))] + (pad_temp_shared_local[((xx_c + 12))] * kernel_shared_local[(ff_c)]));
            }
          }
        }
      }
    }

    for (int ry_outer = 0; ry_outer < 3; ++ry_outer) {
      __syncthreads();
      for (int mfi1 = 0; mfi1 < 3; ++mfi1) {
        kernel3_shared[(((((threadIdx.z * 24) + (threadIdx.y * 12)) + (threadIdx.x * 3)) + mfi1))] = kernel3[((((((((threadIdx.z * 1152) + (threadIdx.y * 576)) + ((threadIdx.x >> 1) * 288)) + (rc_outer * 18)) + ((threadIdx.x & 1) * 9)) + (ry_outer * 3)) + mfi1))];
      }
      __syncthreads();
      for (int rc_io = 0; rc_io < 2; ++rc_io) {
        for (int rx_io = 0; rx_io < 3; ++rx_io) {
          for (int ax3 = 0; ax3 < 4; ++ax3) {
            pad_temp_shared_local[(ax3)] = pad_temp_shared[ry_outer*192 + ((((((rc_io * 96) + (threadIdx.y * 12)) + (threadIdx.x * 4)) + ax3) + rx_io))];
            pad_temp_shared_local[((ax3 + 4))] = pad_temp_shared[ry_outer*192 + (((((((rc_io * 96) + (threadIdx.y * 12)) + (threadIdx.x * 4)) + ax3) + rx_io) + 24))];
            pad_temp_shared_local[((ax3 + 8))] = pad_temp_shared[ry_outer*192 + (((((((rc_io * 96) + (threadIdx.y * 12)) + (threadIdx.x * 4)) + ax3) + rx_io) + 48))];
            pad_temp_shared_local[((ax3 + 12))] = pad_temp_shared[ry_outer*192 + (((((((rc_io * 96) + (threadIdx.y * 12)) + (threadIdx.x * 4)) + ax3) + rx_io) + 72))];
          }
          for (int ax0 = 0; ax0 < 4; ++ax0) {
            kernel_shared_local[(ax0)] = kernel3_shared[(((((threadIdx.z * 24) + (ax0 * 6)) + (rc_io * 3)) + rx_io))];
          }
          for (int ff_c = 0; ff_c < 4; ++ff_c) {
            for (int xx_c = 0; xx_c < 4; ++xx_c) {
              compute3_local[(((ff_c * 4) + xx_c))] = (compute3_local[(((ff_c * 4) + xx_c))] + (pad_temp_shared_local[(xx_c)] * kernel_shared_local[(ff_c)]));
              compute3_local[((((ff_c * 4) + xx_c) + 16))] = (compute3_local[((((ff_c * 4) + xx_c) + 16))] + (pad_temp_shared_local[((xx_c + 4))] * kernel_shared_local[(ff_c)]));
              compute3_local[((((ff_c * 4) + xx_c) + 32))] = (compute3_local[((((ff_c * 4) + xx_c) + 32))] + (pad_temp_shared_local[((xx_c + 8))] * kernel_shared_local[(ff_c)]));
              compute3_local[((((ff_c * 4) + xx_c) + 48))] = (compute3_local[((((ff_c * 4) + xx_c) + 48))] + (pad_temp_shared_local[((xx_c + 12))] * kernel_shared_local[(ff_c)]));
            }
          }
        }
      }
    }
  }
  for (int ff_iii = 0; ff_iii < 4; ++ff_iii) {
    for (int xx_iii = 0; xx_iii < 4; ++xx_iii) {
      compute5[((((((((threadIdx.z * 262144) + (ff_iii * 65536)) + (blockIdx.y * 2048)) + (threadIdx.y * 256)) + (blockIdx.x * 16)) + (threadIdx.x * 4)) + xx_iii))] = compute5_local[(((ff_iii * 4) + xx_iii))];
      compute5[(((((((((threadIdx.z * 262144) + (ff_iii * 65536)) + (blockIdx.y * 2048)) + (threadIdx.y * 256)) + (blockIdx.x * 16)) + (threadIdx.x * 4)) + xx_iii) + 512))] = compute5_local[((((ff_iii * 4) + xx_iii) + 16))];
      compute5[(((((((((threadIdx.z * 262144) + (ff_iii * 65536)) + (blockIdx.y * 2048)) + (threadIdx.y * 256)) + (blockIdx.x * 16)) + (threadIdx.x * 4)) + xx_iii) + 1024))] = compute5_local[((((ff_iii * 4) + xx_iii) + 32))];
      compute5[(((((((((threadIdx.z * 262144) + (ff_iii * 65536)) + (blockIdx.y * 2048)) + (threadIdx.y * 256)) + (blockIdx.x * 16)) + (threadIdx.x * 4)) + xx_iii) + 1536))] = compute5_local[((((ff_iii * 4) + xx_iii) + 48))];


      compute3[((((((((threadIdx.z * 262144) + (ff_iii * 65536)) + (blockIdx.y * 2048)) + (threadIdx.y * 256)) + (blockIdx.x * 16)) + (threadIdx.x * 4)) + xx_iii))] = compute3_local[(((ff_iii * 4) + xx_iii))];
      compute3[(((((((((threadIdx.z * 262144) + (ff_iii * 65536)) + (blockIdx.y * 2048)) + (threadIdx.y * 256)) + (blockIdx.x * 16)) + (threadIdx.x * 4)) + xx_iii) + 512))] = compute3_local[((((ff_iii * 4) + xx_iii) + 16))];
      compute3[(((((((((threadIdx.z * 262144) + (ff_iii * 65536)) + (blockIdx.y * 2048)) + (threadIdx.y * 256)) + (blockIdx.x * 16)) + (threadIdx.x * 4)) + xx_iii) + 1024))] = compute3_local[((((ff_iii * 4) + xx_iii) + 32))];
      compute3[(((((((((threadIdx.z * 262144) + (ff_iii * 65536)) + (blockIdx.y * 2048)) + (threadIdx.y * 256)) + (blockIdx.x * 16)) + (threadIdx.x * 4)) + xx_iii) + 1536))] = compute3_local[((((ff_iii * 4) + xx_iii) + 48))];
    }
  }
}

extern "C" __global__ void conv_fused(float* __restrict__ data,
				      float* __restrict__ kernel,
				      float* __restrict__ compute) {
  float compute_local[16];
  __shared__ float pad_temp_shared[640];
  __shared__ float kernel_shared[3200];
  float pad_temp_shared_local[16];
  float kernel_shared_local[1];
  compute_local[(0)] = 0.000000e+00f;
  compute_local[(1)] = 0.000000e+00f;
  compute_local[(2)] = 0.000000e+00f;
  compute_local[(3)] = 0.000000e+00f;
  compute_local[(4)] = 0.000000e+00f;
  compute_local[(5)] = 0.000000e+00f;
  compute_local[(6)] = 0.000000e+00f;
  compute_local[(7)] = 0.000000e+00f;
  compute_local[(8)] = 0.000000e+00f;
  compute_local[(9)] = 0.000000e+00f;
  compute_local[(10)] = 0.000000e+00f;
  compute_local[(11)] = 0.000000e+00f;
  compute_local[(12)] = 0.000000e+00f;
  compute_local[(13)] = 0.000000e+00f;
  compute_local[(14)] = 0.000000e+00f;
  compute_local[(15)] = 0.000000e+00f;
  for (int rc_outer = 0; rc_outer < 8; ++rc_outer) {
    __syncthreads();
    pad_temp_shared[(((((int)threadIdx.z) * 20) + (((int)threadIdx.x) * 5)))] = ((((2 <= ((((int)blockIdx.y) * 4) + (((int)threadIdx.z) & 7))) && (((((int)blockIdx.y) * 4) + (((int)threadIdx.z) & 7)) < 258)) && (2 <= ((((int)blockIdx.x) * 16) + (((int)threadIdx.x) * 5)))) ? data[((((((((rc_outer * 262144) + ((((int)threadIdx.z) >> 3) * 65536)) + (((int)blockIdx.y) * 1024)) + ((((int)threadIdx.z) & 7) * 256)) + (((int)blockIdx.x) * 16)) + (((int)threadIdx.x) * 5)) - 514))] : 0.000000e+00f);
    pad_temp_shared[((((((int)threadIdx.z) * 20) + (((int)threadIdx.x) * 5)) + 1))] = ((((2 <= ((((int)blockIdx.y) * 4) + (((int)threadIdx.z) & 7))) && (((((int)blockIdx.y) * 4) + (((int)threadIdx.z) & 7)) < 258)) && (1 <= ((((int)blockIdx.x) * 16) + (((int)threadIdx.x) * 5)))) ? data[((((((((rc_outer * 262144) + ((((int)threadIdx.z) >> 3) * 65536)) + (((int)blockIdx.y) * 1024)) + ((((int)threadIdx.z) & 7) * 256)) + (((int)blockIdx.x) * 16)) + (((int)threadIdx.x) * 5)) - 513))] : 0.000000e+00f);
    pad_temp_shared[((((((int)threadIdx.z) * 20) + (((int)threadIdx.x) * 5)) + 2))] = (((2 <= ((((int)blockIdx.y) * 4) + (((int)threadIdx.z) & 7))) && (((((int)blockIdx.y) * 4) + (((int)threadIdx.z) & 7)) < 258)) ? data[((((((((rc_outer * 262144) + ((((int)threadIdx.z) >> 3) * 65536)) + (((int)blockIdx.y) * 1024)) + ((((int)threadIdx.z) & 7) * 256)) + (((int)blockIdx.x) * 16)) + (((int)threadIdx.x) * 5)) - 512))] : 0.000000e+00f);
    pad_temp_shared[((((((int)threadIdx.z) * 20) + (((int)threadIdx.x) * 5)) + 3))] = ((((2 <= ((((int)blockIdx.y) * 4) + (((int)threadIdx.z) & 7))) && (((((int)blockIdx.y) * 4) + (((int)threadIdx.z) & 7)) < 258)) && (((((int)blockIdx.x) * 16) + (((int)threadIdx.x) * 5)) < 255)) ? data[((((((((rc_outer * 262144) + ((((int)threadIdx.z) >> 3) * 65536)) + (((int)blockIdx.y) * 1024)) + ((((int)threadIdx.z) & 7) * 256)) + (((int)blockIdx.x) * 16)) + (((int)threadIdx.x) * 5)) - 511))] : 0.000000e+00f);
    pad_temp_shared[((((((int)threadIdx.z) * 20) + (((int)threadIdx.x) * 5)) + 4))] = ((((2 <= ((((int)blockIdx.y) * 4) + (((int)threadIdx.z) & 7))) && (((((int)blockIdx.y) * 4) + (((int)threadIdx.z) & 7)) < 258)) && (((((int)blockIdx.x) * 16) + (((int)threadIdx.x) * 5)) < 254)) ? data[((((((((rc_outer * 262144) + ((((int)threadIdx.z) >> 3) * 65536)) + (((int)blockIdx.y) * 1024)) + ((((int)threadIdx.z) & 7) * 256)) + (((int)blockIdx.x) * 16)) + (((int)threadIdx.x) * 5)) - 510))] : 0.000000e+00f);
    kernel_shared[(((((int)threadIdx.z) * 100) + (((int)threadIdx.x) * 25)))] = kernel[(((((((int)blockIdx.z) * 25600) + (((int)threadIdx.z) * 800)) + (rc_outer * 100)) + (((int)threadIdx.x) * 25)))];
    kernel_shared[((((((int)threadIdx.z) * 100) + (((int)threadIdx.x) * 25)) + 1))] = kernel[((((((((int)blockIdx.z) * 25600) + (((int)threadIdx.z) * 800)) + (rc_outer * 100)) + (((int)threadIdx.x) * 25)) + 1))];
    kernel_shared[((((((int)threadIdx.z) * 100) + (((int)threadIdx.x) * 25)) + 2))] = kernel[((((((((int)blockIdx.z) * 25600) + (((int)threadIdx.z) * 800)) + (rc_outer * 100)) + (((int)threadIdx.x) * 25)) + 2))];
    kernel_shared[((((((int)threadIdx.z) * 100) + (((int)threadIdx.x) * 25)) + 3))] = kernel[((((((((int)blockIdx.z) * 25600) + (((int)threadIdx.z) * 800)) + (rc_outer * 100)) + (((int)threadIdx.x) * 25)) + 3))];
    kernel_shared[((((((int)threadIdx.z) * 100) + (((int)threadIdx.x) * 25)) + 4))] = kernel[((((((((int)blockIdx.z) * 25600) + (((int)threadIdx.z) * 800)) + (rc_outer * 100)) + (((int)threadIdx.x) * 25)) + 4))];
    kernel_shared[((((((int)threadIdx.z) * 100) + (((int)threadIdx.x) * 25)) + 5))] = kernel[((((((((int)blockIdx.z) * 25600) + (((int)threadIdx.z) * 800)) + (rc_outer * 100)) + (((int)threadIdx.x) * 25)) + 5))];
    kernel_shared[((((((int)threadIdx.z) * 100) + (((int)threadIdx.x) * 25)) + 6))] = kernel[((((((((int)blockIdx.z) * 25600) + (((int)threadIdx.z) * 800)) + (rc_outer * 100)) + (((int)threadIdx.x) * 25)) + 6))];
    kernel_shared[((((((int)threadIdx.z) * 100) + (((int)threadIdx.x) * 25)) + 7))] = kernel[((((((((int)blockIdx.z) * 25600) + (((int)threadIdx.z) * 800)) + (rc_outer * 100)) + (((int)threadIdx.x) * 25)) + 7))];
    kernel_shared[((((((int)threadIdx.z) * 100) + (((int)threadIdx.x) * 25)) + 8))] = kernel[((((((((int)blockIdx.z) * 25600) + (((int)threadIdx.z) * 800)) + (rc_outer * 100)) + (((int)threadIdx.x) * 25)) + 8))];
    kernel_shared[((((((int)threadIdx.z) * 100) + (((int)threadIdx.x) * 25)) + 9))] = kernel[((((((((int)blockIdx.z) * 25600) + (((int)threadIdx.z) * 800)) + (rc_outer * 100)) + (((int)threadIdx.x) * 25)) + 9))];
    kernel_shared[((((((int)threadIdx.z) * 100) + (((int)threadIdx.x) * 25)) + 10))] = kernel[((((((((int)blockIdx.z) * 25600) + (((int)threadIdx.z) * 800)) + (rc_outer * 100)) + (((int)threadIdx.x) * 25)) + 10))];
    kernel_shared[((((((int)threadIdx.z) * 100) + (((int)threadIdx.x) * 25)) + 11))] = kernel[((((((((int)blockIdx.z) * 25600) + (((int)threadIdx.z) * 800)) + (rc_outer * 100)) + (((int)threadIdx.x) * 25)) + 11))];
    kernel_shared[((((((int)threadIdx.z) * 100) + (((int)threadIdx.x) * 25)) + 12))] = kernel[((((((((int)blockIdx.z) * 25600) + (((int)threadIdx.z) * 800)) + (rc_outer * 100)) + (((int)threadIdx.x) * 25)) + 12))];
    kernel_shared[((((((int)threadIdx.z) * 100) + (((int)threadIdx.x) * 25)) + 13))] = kernel[((((((((int)blockIdx.z) * 25600) + (((int)threadIdx.z) * 800)) + (rc_outer * 100)) + (((int)threadIdx.x) * 25)) + 13))];
    kernel_shared[((((((int)threadIdx.z) * 100) + (((int)threadIdx.x) * 25)) + 14))] = kernel[((((((((int)blockIdx.z) * 25600) + (((int)threadIdx.z) * 800)) + (rc_outer * 100)) + (((int)threadIdx.x) * 25)) + 14))];
    kernel_shared[((((((int)threadIdx.z) * 100) + (((int)threadIdx.x) * 25)) + 15))] = kernel[((((((((int)blockIdx.z) * 25600) + (((int)threadIdx.z) * 800)) + (rc_outer * 100)) + (((int)threadIdx.x) * 25)) + 15))];
    kernel_shared[((((((int)threadIdx.z) * 100) + (((int)threadIdx.x) * 25)) + 16))] = kernel[((((((((int)blockIdx.z) * 25600) + (((int)threadIdx.z) * 800)) + (rc_outer * 100)) + (((int)threadIdx.x) * 25)) + 16))];
    kernel_shared[((((((int)threadIdx.z) * 100) + (((int)threadIdx.x) * 25)) + 17))] = kernel[((((((((int)blockIdx.z) * 25600) + (((int)threadIdx.z) * 800)) + (rc_outer * 100)) + (((int)threadIdx.x) * 25)) + 17))];
    kernel_shared[((((((int)threadIdx.z) * 100) + (((int)threadIdx.x) * 25)) + 18))] = kernel[((((((((int)blockIdx.z) * 25600) + (((int)threadIdx.z) * 800)) + (rc_outer * 100)) + (((int)threadIdx.x) * 25)) + 18))];
    kernel_shared[((((((int)threadIdx.z) * 100) + (((int)threadIdx.x) * 25)) + 19))] = kernel[((((((((int)blockIdx.z) * 25600) + (((int)threadIdx.z) * 800)) + (rc_outer * 100)) + (((int)threadIdx.x) * 25)) + 19))];
    kernel_shared[((((((int)threadIdx.z) * 100) + (((int)threadIdx.x) * 25)) + 20))] = kernel[((((((((int)blockIdx.z) * 25600) + (((int)threadIdx.z) * 800)) + (rc_outer * 100)) + (((int)threadIdx.x) * 25)) + 20))];
    kernel_shared[((((((int)threadIdx.z) * 100) + (((int)threadIdx.x) * 25)) + 21))] = kernel[((((((((int)blockIdx.z) * 25600) + (((int)threadIdx.z) * 800)) + (rc_outer * 100)) + (((int)threadIdx.x) * 25)) + 21))];
    kernel_shared[((((((int)threadIdx.z) * 100) + (((int)threadIdx.x) * 25)) + 22))] = kernel[((((((((int)blockIdx.z) * 25600) + (((int)threadIdx.z) * 800)) + (rc_outer * 100)) + (((int)threadIdx.x) * 25)) + 22))];
    kernel_shared[((((((int)threadIdx.z) * 100) + (((int)threadIdx.x) * 25)) + 23))] = kernel[((((((((int)blockIdx.z) * 25600) + (((int)threadIdx.z) * 800)) + (rc_outer * 100)) + (((int)threadIdx.x) * 25)) + 23))];
    kernel_shared[((((((int)threadIdx.z) * 100) + (((int)threadIdx.x) * 25)) + 24))] = kernel[((((((((int)blockIdx.z) * 25600) + (((int)threadIdx.z) * 800)) + (rc_outer * 100)) + (((int)threadIdx.x) * 25)) + 24))];
    __syncthreads();
    for (int rc_inner_outer = 0; rc_inner_outer < 4; ++rc_inner_outer) {
      pad_temp_shared_local[(0)] = pad_temp_shared[(((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)))];
      pad_temp_shared_local[(1)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 1))];
      pad_temp_shared_local[(2)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 2))];
      pad_temp_shared_local[(3)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 3))];
      pad_temp_shared_local[(4)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 20))];
      pad_temp_shared_local[(5)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 21))];
      pad_temp_shared_local[(6)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 22))];
      pad_temp_shared_local[(7)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 23))];
      pad_temp_shared_local[(8)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 40))];
      pad_temp_shared_local[(9)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 41))];
      pad_temp_shared_local[(10)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 42))];
      pad_temp_shared_local[(11)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 43))];
      pad_temp_shared_local[(12)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 60))];
      pad_temp_shared_local[(13)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 61))];
      pad_temp_shared_local[(14)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 62))];
      pad_temp_shared_local[(15)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 63))];
      kernel_shared_local[(0)] = kernel_shared[(((((int)threadIdx.z) * 100) + (rc_inner_outer * 25)))];
      compute_local[(0)] = (compute_local[(0)] + (pad_temp_shared_local[(0)] * kernel_shared_local[(0)]));
      compute_local[(1)] = (compute_local[(1)] + (pad_temp_shared_local[(1)] * kernel_shared_local[(0)]));
      compute_local[(2)] = (compute_local[(2)] + (pad_temp_shared_local[(2)] * kernel_shared_local[(0)]));
      compute_local[(3)] = (compute_local[(3)] + (pad_temp_shared_local[(3)] * kernel_shared_local[(0)]));
      compute_local[(4)] = (compute_local[(4)] + (pad_temp_shared_local[(4)] * kernel_shared_local[(0)]));
      compute_local[(5)] = (compute_local[(5)] + (pad_temp_shared_local[(5)] * kernel_shared_local[(0)]));
      compute_local[(6)] = (compute_local[(6)] + (pad_temp_shared_local[(6)] * kernel_shared_local[(0)]));
      compute_local[(7)] = (compute_local[(7)] + (pad_temp_shared_local[(7)] * kernel_shared_local[(0)]));
      compute_local[(8)] = (compute_local[(8)] + (pad_temp_shared_local[(8)] * kernel_shared_local[(0)]));
      compute_local[(9)] = (compute_local[(9)] + (pad_temp_shared_local[(9)] * kernel_shared_local[(0)]));
      compute_local[(10)] = (compute_local[(10)] + (pad_temp_shared_local[(10)] * kernel_shared_local[(0)]));
      compute_local[(11)] = (compute_local[(11)] + (pad_temp_shared_local[(11)] * kernel_shared_local[(0)]));
      compute_local[(12)] = (compute_local[(12)] + (pad_temp_shared_local[(12)] * kernel_shared_local[(0)]));
      compute_local[(13)] = (compute_local[(13)] + (pad_temp_shared_local[(13)] * kernel_shared_local[(0)]));
      compute_local[(14)] = (compute_local[(14)] + (pad_temp_shared_local[(14)] * kernel_shared_local[(0)]));
      compute_local[(15)] = (compute_local[(15)] + (pad_temp_shared_local[(15)] * kernel_shared_local[(0)]));
      pad_temp_shared_local[(0)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 1))];
      pad_temp_shared_local[(1)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 2))];
      pad_temp_shared_local[(2)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 3))];
      pad_temp_shared_local[(3)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 4))];
      pad_temp_shared_local[(4)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 21))];
      pad_temp_shared_local[(5)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 22))];
      pad_temp_shared_local[(6)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 23))];
      pad_temp_shared_local[(7)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 24))];
      pad_temp_shared_local[(8)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 41))];
      pad_temp_shared_local[(9)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 42))];
      pad_temp_shared_local[(10)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 43))];
      pad_temp_shared_local[(11)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 44))];
      pad_temp_shared_local[(12)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 61))];
      pad_temp_shared_local[(13)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 62))];
      pad_temp_shared_local[(14)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 63))];
      pad_temp_shared_local[(15)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 64))];
      kernel_shared_local[(0)] = kernel_shared[((((((int)threadIdx.z) * 100) + (rc_inner_outer * 25)) + 1))];
      compute_local[(0)] = (compute_local[(0)] + (pad_temp_shared_local[(0)] * kernel_shared_local[(0)]));
      compute_local[(1)] = (compute_local[(1)] + (pad_temp_shared_local[(1)] * kernel_shared_local[(0)]));
      compute_local[(2)] = (compute_local[(2)] + (pad_temp_shared_local[(2)] * kernel_shared_local[(0)]));
      compute_local[(3)] = (compute_local[(3)] + (pad_temp_shared_local[(3)] * kernel_shared_local[(0)]));
      compute_local[(4)] = (compute_local[(4)] + (pad_temp_shared_local[(4)] * kernel_shared_local[(0)]));
      compute_local[(5)] = (compute_local[(5)] + (pad_temp_shared_local[(5)] * kernel_shared_local[(0)]));
      compute_local[(6)] = (compute_local[(6)] + (pad_temp_shared_local[(6)] * kernel_shared_local[(0)]));
      compute_local[(7)] = (compute_local[(7)] + (pad_temp_shared_local[(7)] * kernel_shared_local[(0)]));
      compute_local[(8)] = (compute_local[(8)] + (pad_temp_shared_local[(8)] * kernel_shared_local[(0)]));
      compute_local[(9)] = (compute_local[(9)] + (pad_temp_shared_local[(9)] * kernel_shared_local[(0)]));
      compute_local[(10)] = (compute_local[(10)] + (pad_temp_shared_local[(10)] * kernel_shared_local[(0)]));
      compute_local[(11)] = (compute_local[(11)] + (pad_temp_shared_local[(11)] * kernel_shared_local[(0)]));
      compute_local[(12)] = (compute_local[(12)] + (pad_temp_shared_local[(12)] * kernel_shared_local[(0)]));
      compute_local[(13)] = (compute_local[(13)] + (pad_temp_shared_local[(13)] * kernel_shared_local[(0)]));
      compute_local[(14)] = (compute_local[(14)] + (pad_temp_shared_local[(14)] * kernel_shared_local[(0)]));
      compute_local[(15)] = (compute_local[(15)] + (pad_temp_shared_local[(15)] * kernel_shared_local[(0)]));
      pad_temp_shared_local[(0)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 2))];
      pad_temp_shared_local[(1)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 3))];
      pad_temp_shared_local[(2)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 4))];
      pad_temp_shared_local[(3)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 5))];
      pad_temp_shared_local[(4)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 22))];
      pad_temp_shared_local[(5)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 23))];
      pad_temp_shared_local[(6)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 24))];
      pad_temp_shared_local[(7)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 25))];
      pad_temp_shared_local[(8)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 42))];
      pad_temp_shared_local[(9)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 43))];
      pad_temp_shared_local[(10)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 44))];
      pad_temp_shared_local[(11)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 45))];
      pad_temp_shared_local[(12)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 62))];
      pad_temp_shared_local[(13)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 63))];
      pad_temp_shared_local[(14)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 64))];
      pad_temp_shared_local[(15)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 65))];
      kernel_shared_local[(0)] = kernel_shared[((((((int)threadIdx.z) * 100) + (rc_inner_outer * 25)) + 2))];
      compute_local[(0)] = (compute_local[(0)] + (pad_temp_shared_local[(0)] * kernel_shared_local[(0)]));
      compute_local[(1)] = (compute_local[(1)] + (pad_temp_shared_local[(1)] * kernel_shared_local[(0)]));
      compute_local[(2)] = (compute_local[(2)] + (pad_temp_shared_local[(2)] * kernel_shared_local[(0)]));
      compute_local[(3)] = (compute_local[(3)] + (pad_temp_shared_local[(3)] * kernel_shared_local[(0)]));
      compute_local[(4)] = (compute_local[(4)] + (pad_temp_shared_local[(4)] * kernel_shared_local[(0)]));
      compute_local[(5)] = (compute_local[(5)] + (pad_temp_shared_local[(5)] * kernel_shared_local[(0)]));
      compute_local[(6)] = (compute_local[(6)] + (pad_temp_shared_local[(6)] * kernel_shared_local[(0)]));
      compute_local[(7)] = (compute_local[(7)] + (pad_temp_shared_local[(7)] * kernel_shared_local[(0)]));
      compute_local[(8)] = (compute_local[(8)] + (pad_temp_shared_local[(8)] * kernel_shared_local[(0)]));
      compute_local[(9)] = (compute_local[(9)] + (pad_temp_shared_local[(9)] * kernel_shared_local[(0)]));
      compute_local[(10)] = (compute_local[(10)] + (pad_temp_shared_local[(10)] * kernel_shared_local[(0)]));
      compute_local[(11)] = (compute_local[(11)] + (pad_temp_shared_local[(11)] * kernel_shared_local[(0)]));
      compute_local[(12)] = (compute_local[(12)] + (pad_temp_shared_local[(12)] * kernel_shared_local[(0)]));
      compute_local[(13)] = (compute_local[(13)] + (pad_temp_shared_local[(13)] * kernel_shared_local[(0)]));
      compute_local[(14)] = (compute_local[(14)] + (pad_temp_shared_local[(14)] * kernel_shared_local[(0)]));
      compute_local[(15)] = (compute_local[(15)] + (pad_temp_shared_local[(15)] * kernel_shared_local[(0)]));
      pad_temp_shared_local[(0)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 3))];
      pad_temp_shared_local[(1)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 4))];
      pad_temp_shared_local[(2)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 5))];
      pad_temp_shared_local[(3)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 6))];
      pad_temp_shared_local[(4)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 23))];
      pad_temp_shared_local[(5)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 24))];
      pad_temp_shared_local[(6)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 25))];
      pad_temp_shared_local[(7)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 26))];
      pad_temp_shared_local[(8)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 43))];
      pad_temp_shared_local[(9)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 44))];
      pad_temp_shared_local[(10)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 45))];
      pad_temp_shared_local[(11)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 46))];
      pad_temp_shared_local[(12)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 63))];
      pad_temp_shared_local[(13)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 64))];
      pad_temp_shared_local[(14)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 65))];
      pad_temp_shared_local[(15)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 66))];
      kernel_shared_local[(0)] = kernel_shared[((((((int)threadIdx.z) * 100) + (rc_inner_outer * 25)) + 3))];
      compute_local[(0)] = (compute_local[(0)] + (pad_temp_shared_local[(0)] * kernel_shared_local[(0)]));
      compute_local[(1)] = (compute_local[(1)] + (pad_temp_shared_local[(1)] * kernel_shared_local[(0)]));
      compute_local[(2)] = (compute_local[(2)] + (pad_temp_shared_local[(2)] * kernel_shared_local[(0)]));
      compute_local[(3)] = (compute_local[(3)] + (pad_temp_shared_local[(3)] * kernel_shared_local[(0)]));
      compute_local[(4)] = (compute_local[(4)] + (pad_temp_shared_local[(4)] * kernel_shared_local[(0)]));
      compute_local[(5)] = (compute_local[(5)] + (pad_temp_shared_local[(5)] * kernel_shared_local[(0)]));
      compute_local[(6)] = (compute_local[(6)] + (pad_temp_shared_local[(6)] * kernel_shared_local[(0)]));
      compute_local[(7)] = (compute_local[(7)] + (pad_temp_shared_local[(7)] * kernel_shared_local[(0)]));
      compute_local[(8)] = (compute_local[(8)] + (pad_temp_shared_local[(8)] * kernel_shared_local[(0)]));
      compute_local[(9)] = (compute_local[(9)] + (pad_temp_shared_local[(9)] * kernel_shared_local[(0)]));
      compute_local[(10)] = (compute_local[(10)] + (pad_temp_shared_local[(10)] * kernel_shared_local[(0)]));
      compute_local[(11)] = (compute_local[(11)] + (pad_temp_shared_local[(11)] * kernel_shared_local[(0)]));
      compute_local[(12)] = (compute_local[(12)] + (pad_temp_shared_local[(12)] * kernel_shared_local[(0)]));
      compute_local[(13)] = (compute_local[(13)] + (pad_temp_shared_local[(13)] * kernel_shared_local[(0)]));
      compute_local[(14)] = (compute_local[(14)] + (pad_temp_shared_local[(14)] * kernel_shared_local[(0)]));
      compute_local[(15)] = (compute_local[(15)] + (pad_temp_shared_local[(15)] * kernel_shared_local[(0)]));
      pad_temp_shared_local[(0)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 4))];
      pad_temp_shared_local[(1)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 5))];
      pad_temp_shared_local[(2)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 6))];
      pad_temp_shared_local[(3)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 7))];
      pad_temp_shared_local[(4)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 24))];
      pad_temp_shared_local[(5)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 25))];
      pad_temp_shared_local[(6)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 26))];
      pad_temp_shared_local[(7)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 27))];
      pad_temp_shared_local[(8)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 44))];
      pad_temp_shared_local[(9)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 45))];
      pad_temp_shared_local[(10)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 46))];
      pad_temp_shared_local[(11)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 47))];
      pad_temp_shared_local[(12)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 64))];
      pad_temp_shared_local[(13)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 65))];
      pad_temp_shared_local[(14)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 66))];
      pad_temp_shared_local[(15)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 67))];
      kernel_shared_local[(0)] = kernel_shared[((((((int)threadIdx.z) * 100) + (rc_inner_outer * 25)) + 4))];
      compute_local[(0)] = (compute_local[(0)] + (pad_temp_shared_local[(0)] * kernel_shared_local[(0)]));
      compute_local[(1)] = (compute_local[(1)] + (pad_temp_shared_local[(1)] * kernel_shared_local[(0)]));
      compute_local[(2)] = (compute_local[(2)] + (pad_temp_shared_local[(2)] * kernel_shared_local[(0)]));
      compute_local[(3)] = (compute_local[(3)] + (pad_temp_shared_local[(3)] * kernel_shared_local[(0)]));
      compute_local[(4)] = (compute_local[(4)] + (pad_temp_shared_local[(4)] * kernel_shared_local[(0)]));
      compute_local[(5)] = (compute_local[(5)] + (pad_temp_shared_local[(5)] * kernel_shared_local[(0)]));
      compute_local[(6)] = (compute_local[(6)] + (pad_temp_shared_local[(6)] * kernel_shared_local[(0)]));
      compute_local[(7)] = (compute_local[(7)] + (pad_temp_shared_local[(7)] * kernel_shared_local[(0)]));
      compute_local[(8)] = (compute_local[(8)] + (pad_temp_shared_local[(8)] * kernel_shared_local[(0)]));
      compute_local[(9)] = (compute_local[(9)] + (pad_temp_shared_local[(9)] * kernel_shared_local[(0)]));
      compute_local[(10)] = (compute_local[(10)] + (pad_temp_shared_local[(10)] * kernel_shared_local[(0)]));
      compute_local[(11)] = (compute_local[(11)] + (pad_temp_shared_local[(11)] * kernel_shared_local[(0)]));
      compute_local[(12)] = (compute_local[(12)] + (pad_temp_shared_local[(12)] * kernel_shared_local[(0)]));
      compute_local[(13)] = (compute_local[(13)] + (pad_temp_shared_local[(13)] * kernel_shared_local[(0)]));
      compute_local[(14)] = (compute_local[(14)] + (pad_temp_shared_local[(14)] * kernel_shared_local[(0)]));
      compute_local[(15)] = (compute_local[(15)] + (pad_temp_shared_local[(15)] * kernel_shared_local[(0)]));
      pad_temp_shared_local[(0)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 20))];
      pad_temp_shared_local[(1)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 21))];
      pad_temp_shared_local[(2)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 22))];
      pad_temp_shared_local[(3)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 23))];
      pad_temp_shared_local[(4)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 40))];
      pad_temp_shared_local[(5)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 41))];
      pad_temp_shared_local[(6)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 42))];
      pad_temp_shared_local[(7)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 43))];
      pad_temp_shared_local[(8)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 60))];
      pad_temp_shared_local[(9)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 61))];
      pad_temp_shared_local[(10)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 62))];
      pad_temp_shared_local[(11)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 63))];
      pad_temp_shared_local[(12)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 80))];
      pad_temp_shared_local[(13)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 81))];
      pad_temp_shared_local[(14)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 82))];
      pad_temp_shared_local[(15)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 83))];
      kernel_shared_local[(0)] = kernel_shared[((((((int)threadIdx.z) * 100) + (rc_inner_outer * 25)) + 5))];
      compute_local[(0)] = (compute_local[(0)] + (pad_temp_shared_local[(0)] * kernel_shared_local[(0)]));
      compute_local[(1)] = (compute_local[(1)] + (pad_temp_shared_local[(1)] * kernel_shared_local[(0)]));
      compute_local[(2)] = (compute_local[(2)] + (pad_temp_shared_local[(2)] * kernel_shared_local[(0)]));
      compute_local[(3)] = (compute_local[(3)] + (pad_temp_shared_local[(3)] * kernel_shared_local[(0)]));
      compute_local[(4)] = (compute_local[(4)] + (pad_temp_shared_local[(4)] * kernel_shared_local[(0)]));
      compute_local[(5)] = (compute_local[(5)] + (pad_temp_shared_local[(5)] * kernel_shared_local[(0)]));
      compute_local[(6)] = (compute_local[(6)] + (pad_temp_shared_local[(6)] * kernel_shared_local[(0)]));
      compute_local[(7)] = (compute_local[(7)] + (pad_temp_shared_local[(7)] * kernel_shared_local[(0)]));
      compute_local[(8)] = (compute_local[(8)] + (pad_temp_shared_local[(8)] * kernel_shared_local[(0)]));
      compute_local[(9)] = (compute_local[(9)] + (pad_temp_shared_local[(9)] * kernel_shared_local[(0)]));
      compute_local[(10)] = (compute_local[(10)] + (pad_temp_shared_local[(10)] * kernel_shared_local[(0)]));
      compute_local[(11)] = (compute_local[(11)] + (pad_temp_shared_local[(11)] * kernel_shared_local[(0)]));
      compute_local[(12)] = (compute_local[(12)] + (pad_temp_shared_local[(12)] * kernel_shared_local[(0)]));
      compute_local[(13)] = (compute_local[(13)] + (pad_temp_shared_local[(13)] * kernel_shared_local[(0)]));
      compute_local[(14)] = (compute_local[(14)] + (pad_temp_shared_local[(14)] * kernel_shared_local[(0)]));
      compute_local[(15)] = (compute_local[(15)] + (pad_temp_shared_local[(15)] * kernel_shared_local[(0)]));
      pad_temp_shared_local[(0)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 21))];
      pad_temp_shared_local[(1)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 22))];
      pad_temp_shared_local[(2)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 23))];
      pad_temp_shared_local[(3)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 24))];
      pad_temp_shared_local[(4)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 41))];
      pad_temp_shared_local[(5)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 42))];
      pad_temp_shared_local[(6)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 43))];
      pad_temp_shared_local[(7)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 44))];
      pad_temp_shared_local[(8)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 61))];
      pad_temp_shared_local[(9)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 62))];
      pad_temp_shared_local[(10)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 63))];
      pad_temp_shared_local[(11)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 64))];
      pad_temp_shared_local[(12)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 81))];
      pad_temp_shared_local[(13)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 82))];
      pad_temp_shared_local[(14)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 83))];
      pad_temp_shared_local[(15)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 84))];
      kernel_shared_local[(0)] = kernel_shared[((((((int)threadIdx.z) * 100) + (rc_inner_outer * 25)) + 6))];
      compute_local[(0)] = (compute_local[(0)] + (pad_temp_shared_local[(0)] * kernel_shared_local[(0)]));
      compute_local[(1)] = (compute_local[(1)] + (pad_temp_shared_local[(1)] * kernel_shared_local[(0)]));
      compute_local[(2)] = (compute_local[(2)] + (pad_temp_shared_local[(2)] * kernel_shared_local[(0)]));
      compute_local[(3)] = (compute_local[(3)] + (pad_temp_shared_local[(3)] * kernel_shared_local[(0)]));
      compute_local[(4)] = (compute_local[(4)] + (pad_temp_shared_local[(4)] * kernel_shared_local[(0)]));
      compute_local[(5)] = (compute_local[(5)] + (pad_temp_shared_local[(5)] * kernel_shared_local[(0)]));
      compute_local[(6)] = (compute_local[(6)] + (pad_temp_shared_local[(6)] * kernel_shared_local[(0)]));
      compute_local[(7)] = (compute_local[(7)] + (pad_temp_shared_local[(7)] * kernel_shared_local[(0)]));
      compute_local[(8)] = (compute_local[(8)] + (pad_temp_shared_local[(8)] * kernel_shared_local[(0)]));
      compute_local[(9)] = (compute_local[(9)] + (pad_temp_shared_local[(9)] * kernel_shared_local[(0)]));
      compute_local[(10)] = (compute_local[(10)] + (pad_temp_shared_local[(10)] * kernel_shared_local[(0)]));
      compute_local[(11)] = (compute_local[(11)] + (pad_temp_shared_local[(11)] * kernel_shared_local[(0)]));
      compute_local[(12)] = (compute_local[(12)] + (pad_temp_shared_local[(12)] * kernel_shared_local[(0)]));
      compute_local[(13)] = (compute_local[(13)] + (pad_temp_shared_local[(13)] * kernel_shared_local[(0)]));
      compute_local[(14)] = (compute_local[(14)] + (pad_temp_shared_local[(14)] * kernel_shared_local[(0)]));
      compute_local[(15)] = (compute_local[(15)] + (pad_temp_shared_local[(15)] * kernel_shared_local[(0)]));
      pad_temp_shared_local[(0)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 22))];
      pad_temp_shared_local[(1)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 23))];
      pad_temp_shared_local[(2)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 24))];
      pad_temp_shared_local[(3)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 25))];
      pad_temp_shared_local[(4)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 42))];
      pad_temp_shared_local[(5)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 43))];
      pad_temp_shared_local[(6)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 44))];
      pad_temp_shared_local[(7)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 45))];
      pad_temp_shared_local[(8)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 62))];
      pad_temp_shared_local[(9)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 63))];
      pad_temp_shared_local[(10)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 64))];
      pad_temp_shared_local[(11)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 65))];
      pad_temp_shared_local[(12)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 82))];
      pad_temp_shared_local[(13)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 83))];
      pad_temp_shared_local[(14)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 84))];
      pad_temp_shared_local[(15)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 85))];
      kernel_shared_local[(0)] = kernel_shared[((((((int)threadIdx.z) * 100) + (rc_inner_outer * 25)) + 7))];
      compute_local[(0)] = (compute_local[(0)] + (pad_temp_shared_local[(0)] * kernel_shared_local[(0)]));
      compute_local[(1)] = (compute_local[(1)] + (pad_temp_shared_local[(1)] * kernel_shared_local[(0)]));
      compute_local[(2)] = (compute_local[(2)] + (pad_temp_shared_local[(2)] * kernel_shared_local[(0)]));
      compute_local[(3)] = (compute_local[(3)] + (pad_temp_shared_local[(3)] * kernel_shared_local[(0)]));
      compute_local[(4)] = (compute_local[(4)] + (pad_temp_shared_local[(4)] * kernel_shared_local[(0)]));
      compute_local[(5)] = (compute_local[(5)] + (pad_temp_shared_local[(5)] * kernel_shared_local[(0)]));
      compute_local[(6)] = (compute_local[(6)] + (pad_temp_shared_local[(6)] * kernel_shared_local[(0)]));
      compute_local[(7)] = (compute_local[(7)] + (pad_temp_shared_local[(7)] * kernel_shared_local[(0)]));
      compute_local[(8)] = (compute_local[(8)] + (pad_temp_shared_local[(8)] * kernel_shared_local[(0)]));
      compute_local[(9)] = (compute_local[(9)] + (pad_temp_shared_local[(9)] * kernel_shared_local[(0)]));
      compute_local[(10)] = (compute_local[(10)] + (pad_temp_shared_local[(10)] * kernel_shared_local[(0)]));
      compute_local[(11)] = (compute_local[(11)] + (pad_temp_shared_local[(11)] * kernel_shared_local[(0)]));
      compute_local[(12)] = (compute_local[(12)] + (pad_temp_shared_local[(12)] * kernel_shared_local[(0)]));
      compute_local[(13)] = (compute_local[(13)] + (pad_temp_shared_local[(13)] * kernel_shared_local[(0)]));
      compute_local[(14)] = (compute_local[(14)] + (pad_temp_shared_local[(14)] * kernel_shared_local[(0)]));
      compute_local[(15)] = (compute_local[(15)] + (pad_temp_shared_local[(15)] * kernel_shared_local[(0)]));
      pad_temp_shared_local[(0)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 23))];
      pad_temp_shared_local[(1)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 24))];
      pad_temp_shared_local[(2)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 25))];
      pad_temp_shared_local[(3)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 26))];
      pad_temp_shared_local[(4)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 43))];
      pad_temp_shared_local[(5)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 44))];
      pad_temp_shared_local[(6)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 45))];
      pad_temp_shared_local[(7)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 46))];
      pad_temp_shared_local[(8)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 63))];
      pad_temp_shared_local[(9)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 64))];
      pad_temp_shared_local[(10)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 65))];
      pad_temp_shared_local[(11)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 66))];
      pad_temp_shared_local[(12)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 83))];
      pad_temp_shared_local[(13)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 84))];
      pad_temp_shared_local[(14)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 85))];
      pad_temp_shared_local[(15)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 86))];
      kernel_shared_local[(0)] = kernel_shared[((((((int)threadIdx.z) * 100) + (rc_inner_outer * 25)) + 8))];
      compute_local[(0)] = (compute_local[(0)] + (pad_temp_shared_local[(0)] * kernel_shared_local[(0)]));
      compute_local[(1)] = (compute_local[(1)] + (pad_temp_shared_local[(1)] * kernel_shared_local[(0)]));
      compute_local[(2)] = (compute_local[(2)] + (pad_temp_shared_local[(2)] * kernel_shared_local[(0)]));
      compute_local[(3)] = (compute_local[(3)] + (pad_temp_shared_local[(3)] * kernel_shared_local[(0)]));
      compute_local[(4)] = (compute_local[(4)] + (pad_temp_shared_local[(4)] * kernel_shared_local[(0)]));
      compute_local[(5)] = (compute_local[(5)] + (pad_temp_shared_local[(5)] * kernel_shared_local[(0)]));
      compute_local[(6)] = (compute_local[(6)] + (pad_temp_shared_local[(6)] * kernel_shared_local[(0)]));
      compute_local[(7)] = (compute_local[(7)] + (pad_temp_shared_local[(7)] * kernel_shared_local[(0)]));
      compute_local[(8)] = (compute_local[(8)] + (pad_temp_shared_local[(8)] * kernel_shared_local[(0)]));
      compute_local[(9)] = (compute_local[(9)] + (pad_temp_shared_local[(9)] * kernel_shared_local[(0)]));
      compute_local[(10)] = (compute_local[(10)] + (pad_temp_shared_local[(10)] * kernel_shared_local[(0)]));
      compute_local[(11)] = (compute_local[(11)] + (pad_temp_shared_local[(11)] * kernel_shared_local[(0)]));
      compute_local[(12)] = (compute_local[(12)] + (pad_temp_shared_local[(12)] * kernel_shared_local[(0)]));
      compute_local[(13)] = (compute_local[(13)] + (pad_temp_shared_local[(13)] * kernel_shared_local[(0)]));
      compute_local[(14)] = (compute_local[(14)] + (pad_temp_shared_local[(14)] * kernel_shared_local[(0)]));
      compute_local[(15)] = (compute_local[(15)] + (pad_temp_shared_local[(15)] * kernel_shared_local[(0)]));
      pad_temp_shared_local[(0)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 24))];
      pad_temp_shared_local[(1)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 25))];
      pad_temp_shared_local[(2)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 26))];
      pad_temp_shared_local[(3)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 27))];
      pad_temp_shared_local[(4)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 44))];
      pad_temp_shared_local[(5)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 45))];
      pad_temp_shared_local[(6)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 46))];
      pad_temp_shared_local[(7)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 47))];
      pad_temp_shared_local[(8)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 64))];
      pad_temp_shared_local[(9)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 65))];
      pad_temp_shared_local[(10)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 66))];
      pad_temp_shared_local[(11)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 67))];
      pad_temp_shared_local[(12)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 84))];
      pad_temp_shared_local[(13)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 85))];
      pad_temp_shared_local[(14)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 86))];
      pad_temp_shared_local[(15)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 87))];
      kernel_shared_local[(0)] = kernel_shared[((((((int)threadIdx.z) * 100) + (rc_inner_outer * 25)) + 9))];
      compute_local[(0)] = (compute_local[(0)] + (pad_temp_shared_local[(0)] * kernel_shared_local[(0)]));
      compute_local[(1)] = (compute_local[(1)] + (pad_temp_shared_local[(1)] * kernel_shared_local[(0)]));
      compute_local[(2)] = (compute_local[(2)] + (pad_temp_shared_local[(2)] * kernel_shared_local[(0)]));
      compute_local[(3)] = (compute_local[(3)] + (pad_temp_shared_local[(3)] * kernel_shared_local[(0)]));
      compute_local[(4)] = (compute_local[(4)] + (pad_temp_shared_local[(4)] * kernel_shared_local[(0)]));
      compute_local[(5)] = (compute_local[(5)] + (pad_temp_shared_local[(5)] * kernel_shared_local[(0)]));
      compute_local[(6)] = (compute_local[(6)] + (pad_temp_shared_local[(6)] * kernel_shared_local[(0)]));
      compute_local[(7)] = (compute_local[(7)] + (pad_temp_shared_local[(7)] * kernel_shared_local[(0)]));
      compute_local[(8)] = (compute_local[(8)] + (pad_temp_shared_local[(8)] * kernel_shared_local[(0)]));
      compute_local[(9)] = (compute_local[(9)] + (pad_temp_shared_local[(9)] * kernel_shared_local[(0)]));
      compute_local[(10)] = (compute_local[(10)] + (pad_temp_shared_local[(10)] * kernel_shared_local[(0)]));
      compute_local[(11)] = (compute_local[(11)] + (pad_temp_shared_local[(11)] * kernel_shared_local[(0)]));
      compute_local[(12)] = (compute_local[(12)] + (pad_temp_shared_local[(12)] * kernel_shared_local[(0)]));
      compute_local[(13)] = (compute_local[(13)] + (pad_temp_shared_local[(13)] * kernel_shared_local[(0)]));
      compute_local[(14)] = (compute_local[(14)] + (pad_temp_shared_local[(14)] * kernel_shared_local[(0)]));
      compute_local[(15)] = (compute_local[(15)] + (pad_temp_shared_local[(15)] * kernel_shared_local[(0)]));
      pad_temp_shared_local[(0)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 40))];
      pad_temp_shared_local[(1)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 41))];
      pad_temp_shared_local[(2)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 42))];
      pad_temp_shared_local[(3)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 43))];
      pad_temp_shared_local[(4)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 60))];
      pad_temp_shared_local[(5)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 61))];
      pad_temp_shared_local[(6)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 62))];
      pad_temp_shared_local[(7)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 63))];
      pad_temp_shared_local[(8)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 80))];
      pad_temp_shared_local[(9)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 81))];
      pad_temp_shared_local[(10)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 82))];
      pad_temp_shared_local[(11)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 83))];
      pad_temp_shared_local[(12)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 100))];
      pad_temp_shared_local[(13)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 101))];
      pad_temp_shared_local[(14)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 102))];
      pad_temp_shared_local[(15)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 103))];
      kernel_shared_local[(0)] = kernel_shared[((((((int)threadIdx.z) * 100) + (rc_inner_outer * 25)) + 10))];
      compute_local[(0)] = (compute_local[(0)] + (pad_temp_shared_local[(0)] * kernel_shared_local[(0)]));
      compute_local[(1)] = (compute_local[(1)] + (pad_temp_shared_local[(1)] * kernel_shared_local[(0)]));
      compute_local[(2)] = (compute_local[(2)] + (pad_temp_shared_local[(2)] * kernel_shared_local[(0)]));
      compute_local[(3)] = (compute_local[(3)] + (pad_temp_shared_local[(3)] * kernel_shared_local[(0)]));
      compute_local[(4)] = (compute_local[(4)] + (pad_temp_shared_local[(4)] * kernel_shared_local[(0)]));
      compute_local[(5)] = (compute_local[(5)] + (pad_temp_shared_local[(5)] * kernel_shared_local[(0)]));
      compute_local[(6)] = (compute_local[(6)] + (pad_temp_shared_local[(6)] * kernel_shared_local[(0)]));
      compute_local[(7)] = (compute_local[(7)] + (pad_temp_shared_local[(7)] * kernel_shared_local[(0)]));
      compute_local[(8)] = (compute_local[(8)] + (pad_temp_shared_local[(8)] * kernel_shared_local[(0)]));
      compute_local[(9)] = (compute_local[(9)] + (pad_temp_shared_local[(9)] * kernel_shared_local[(0)]));
      compute_local[(10)] = (compute_local[(10)] + (pad_temp_shared_local[(10)] * kernel_shared_local[(0)]));
      compute_local[(11)] = (compute_local[(11)] + (pad_temp_shared_local[(11)] * kernel_shared_local[(0)]));
      compute_local[(12)] = (compute_local[(12)] + (pad_temp_shared_local[(12)] * kernel_shared_local[(0)]));
      compute_local[(13)] = (compute_local[(13)] + (pad_temp_shared_local[(13)] * kernel_shared_local[(0)]));
      compute_local[(14)] = (compute_local[(14)] + (pad_temp_shared_local[(14)] * kernel_shared_local[(0)]));
      compute_local[(15)] = (compute_local[(15)] + (pad_temp_shared_local[(15)] * kernel_shared_local[(0)]));
      pad_temp_shared_local[(0)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 41))];
      pad_temp_shared_local[(1)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 42))];
      pad_temp_shared_local[(2)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 43))];
      pad_temp_shared_local[(3)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 44))];
      pad_temp_shared_local[(4)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 61))];
      pad_temp_shared_local[(5)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 62))];
      pad_temp_shared_local[(6)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 63))];
      pad_temp_shared_local[(7)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 64))];
      pad_temp_shared_local[(8)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 81))];
      pad_temp_shared_local[(9)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 82))];
      pad_temp_shared_local[(10)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 83))];
      pad_temp_shared_local[(11)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 84))];
      pad_temp_shared_local[(12)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 101))];
      pad_temp_shared_local[(13)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 102))];
      pad_temp_shared_local[(14)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 103))];
      pad_temp_shared_local[(15)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 104))];
      kernel_shared_local[(0)] = kernel_shared[((((((int)threadIdx.z) * 100) + (rc_inner_outer * 25)) + 11))];
      compute_local[(0)] = (compute_local[(0)] + (pad_temp_shared_local[(0)] * kernel_shared_local[(0)]));
      compute_local[(1)] = (compute_local[(1)] + (pad_temp_shared_local[(1)] * kernel_shared_local[(0)]));
      compute_local[(2)] = (compute_local[(2)] + (pad_temp_shared_local[(2)] * kernel_shared_local[(0)]));
      compute_local[(3)] = (compute_local[(3)] + (pad_temp_shared_local[(3)] * kernel_shared_local[(0)]));
      compute_local[(4)] = (compute_local[(4)] + (pad_temp_shared_local[(4)] * kernel_shared_local[(0)]));
      compute_local[(5)] = (compute_local[(5)] + (pad_temp_shared_local[(5)] * kernel_shared_local[(0)]));
      compute_local[(6)] = (compute_local[(6)] + (pad_temp_shared_local[(6)] * kernel_shared_local[(0)]));
      compute_local[(7)] = (compute_local[(7)] + (pad_temp_shared_local[(7)] * kernel_shared_local[(0)]));
      compute_local[(8)] = (compute_local[(8)] + (pad_temp_shared_local[(8)] * kernel_shared_local[(0)]));
      compute_local[(9)] = (compute_local[(9)] + (pad_temp_shared_local[(9)] * kernel_shared_local[(0)]));
      compute_local[(10)] = (compute_local[(10)] + (pad_temp_shared_local[(10)] * kernel_shared_local[(0)]));
      compute_local[(11)] = (compute_local[(11)] + (pad_temp_shared_local[(11)] * kernel_shared_local[(0)]));
      compute_local[(12)] = (compute_local[(12)] + (pad_temp_shared_local[(12)] * kernel_shared_local[(0)]));
      compute_local[(13)] = (compute_local[(13)] + (pad_temp_shared_local[(13)] * kernel_shared_local[(0)]));
      compute_local[(14)] = (compute_local[(14)] + (pad_temp_shared_local[(14)] * kernel_shared_local[(0)]));
      compute_local[(15)] = (compute_local[(15)] + (pad_temp_shared_local[(15)] * kernel_shared_local[(0)]));
      pad_temp_shared_local[(0)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 42))];
      pad_temp_shared_local[(1)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 43))];
      pad_temp_shared_local[(2)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 44))];
      pad_temp_shared_local[(3)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 45))];
      pad_temp_shared_local[(4)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 62))];
      pad_temp_shared_local[(5)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 63))];
      pad_temp_shared_local[(6)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 64))];
      pad_temp_shared_local[(7)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 65))];
      pad_temp_shared_local[(8)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 82))];
      pad_temp_shared_local[(9)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 83))];
      pad_temp_shared_local[(10)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 84))];
      pad_temp_shared_local[(11)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 85))];
      pad_temp_shared_local[(12)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 102))];
      pad_temp_shared_local[(13)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 103))];
      pad_temp_shared_local[(14)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 104))];
      pad_temp_shared_local[(15)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 105))];
      kernel_shared_local[(0)] = kernel_shared[((((((int)threadIdx.z) * 100) + (rc_inner_outer * 25)) + 12))];
      compute_local[(0)] = (compute_local[(0)] + (pad_temp_shared_local[(0)] * kernel_shared_local[(0)]));
      compute_local[(1)] = (compute_local[(1)] + (pad_temp_shared_local[(1)] * kernel_shared_local[(0)]));
      compute_local[(2)] = (compute_local[(2)] + (pad_temp_shared_local[(2)] * kernel_shared_local[(0)]));
      compute_local[(3)] = (compute_local[(3)] + (pad_temp_shared_local[(3)] * kernel_shared_local[(0)]));
      compute_local[(4)] = (compute_local[(4)] + (pad_temp_shared_local[(4)] * kernel_shared_local[(0)]));
      compute_local[(5)] = (compute_local[(5)] + (pad_temp_shared_local[(5)] * kernel_shared_local[(0)]));
      compute_local[(6)] = (compute_local[(6)] + (pad_temp_shared_local[(6)] * kernel_shared_local[(0)]));
      compute_local[(7)] = (compute_local[(7)] + (pad_temp_shared_local[(7)] * kernel_shared_local[(0)]));
      compute_local[(8)] = (compute_local[(8)] + (pad_temp_shared_local[(8)] * kernel_shared_local[(0)]));
      compute_local[(9)] = (compute_local[(9)] + (pad_temp_shared_local[(9)] * kernel_shared_local[(0)]));
      compute_local[(10)] = (compute_local[(10)] + (pad_temp_shared_local[(10)] * kernel_shared_local[(0)]));
      compute_local[(11)] = (compute_local[(11)] + (pad_temp_shared_local[(11)] * kernel_shared_local[(0)]));
      compute_local[(12)] = (compute_local[(12)] + (pad_temp_shared_local[(12)] * kernel_shared_local[(0)]));
      compute_local[(13)] = (compute_local[(13)] + (pad_temp_shared_local[(13)] * kernel_shared_local[(0)]));
      compute_local[(14)] = (compute_local[(14)] + (pad_temp_shared_local[(14)] * kernel_shared_local[(0)]));
      compute_local[(15)] = (compute_local[(15)] + (pad_temp_shared_local[(15)] * kernel_shared_local[(0)]));
      pad_temp_shared_local[(0)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 43))];
      pad_temp_shared_local[(1)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 44))];
      pad_temp_shared_local[(2)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 45))];
      pad_temp_shared_local[(3)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 46))];
      pad_temp_shared_local[(4)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 63))];
      pad_temp_shared_local[(5)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 64))];
      pad_temp_shared_local[(6)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 65))];
      pad_temp_shared_local[(7)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 66))];
      pad_temp_shared_local[(8)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 83))];
      pad_temp_shared_local[(9)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 84))];
      pad_temp_shared_local[(10)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 85))];
      pad_temp_shared_local[(11)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 86))];
      pad_temp_shared_local[(12)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 103))];
      pad_temp_shared_local[(13)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 104))];
      pad_temp_shared_local[(14)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 105))];
      pad_temp_shared_local[(15)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 106))];
      kernel_shared_local[(0)] = kernel_shared[((((((int)threadIdx.z) * 100) + (rc_inner_outer * 25)) + 13))];
      compute_local[(0)] = (compute_local[(0)] + (pad_temp_shared_local[(0)] * kernel_shared_local[(0)]));
      compute_local[(1)] = (compute_local[(1)] + (pad_temp_shared_local[(1)] * kernel_shared_local[(0)]));
      compute_local[(2)] = (compute_local[(2)] + (pad_temp_shared_local[(2)] * kernel_shared_local[(0)]));
      compute_local[(3)] = (compute_local[(3)] + (pad_temp_shared_local[(3)] * kernel_shared_local[(0)]));
      compute_local[(4)] = (compute_local[(4)] + (pad_temp_shared_local[(4)] * kernel_shared_local[(0)]));
      compute_local[(5)] = (compute_local[(5)] + (pad_temp_shared_local[(5)] * kernel_shared_local[(0)]));
      compute_local[(6)] = (compute_local[(6)] + (pad_temp_shared_local[(6)] * kernel_shared_local[(0)]));
      compute_local[(7)] = (compute_local[(7)] + (pad_temp_shared_local[(7)] * kernel_shared_local[(0)]));
      compute_local[(8)] = (compute_local[(8)] + (pad_temp_shared_local[(8)] * kernel_shared_local[(0)]));
      compute_local[(9)] = (compute_local[(9)] + (pad_temp_shared_local[(9)] * kernel_shared_local[(0)]));
      compute_local[(10)] = (compute_local[(10)] + (pad_temp_shared_local[(10)] * kernel_shared_local[(0)]));
      compute_local[(11)] = (compute_local[(11)] + (pad_temp_shared_local[(11)] * kernel_shared_local[(0)]));
      compute_local[(12)] = (compute_local[(12)] + (pad_temp_shared_local[(12)] * kernel_shared_local[(0)]));
      compute_local[(13)] = (compute_local[(13)] + (pad_temp_shared_local[(13)] * kernel_shared_local[(0)]));
      compute_local[(14)] = (compute_local[(14)] + (pad_temp_shared_local[(14)] * kernel_shared_local[(0)]));
      compute_local[(15)] = (compute_local[(15)] + (pad_temp_shared_local[(15)] * kernel_shared_local[(0)]));
      pad_temp_shared_local[(0)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 44))];
      pad_temp_shared_local[(1)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 45))];
      pad_temp_shared_local[(2)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 46))];
      pad_temp_shared_local[(3)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 47))];
      pad_temp_shared_local[(4)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 64))];
      pad_temp_shared_local[(5)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 65))];
      pad_temp_shared_local[(6)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 66))];
      pad_temp_shared_local[(7)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 67))];
      pad_temp_shared_local[(8)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 84))];
      pad_temp_shared_local[(9)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 85))];
      pad_temp_shared_local[(10)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 86))];
      pad_temp_shared_local[(11)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 87))];
      pad_temp_shared_local[(12)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 104))];
      pad_temp_shared_local[(13)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 105))];
      pad_temp_shared_local[(14)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 106))];
      pad_temp_shared_local[(15)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 107))];
      kernel_shared_local[(0)] = kernel_shared[((((((int)threadIdx.z) * 100) + (rc_inner_outer * 25)) + 14))];
      compute_local[(0)] = (compute_local[(0)] + (pad_temp_shared_local[(0)] * kernel_shared_local[(0)]));
      compute_local[(1)] = (compute_local[(1)] + (pad_temp_shared_local[(1)] * kernel_shared_local[(0)]));
      compute_local[(2)] = (compute_local[(2)] + (pad_temp_shared_local[(2)] * kernel_shared_local[(0)]));
      compute_local[(3)] = (compute_local[(3)] + (pad_temp_shared_local[(3)] * kernel_shared_local[(0)]));
      compute_local[(4)] = (compute_local[(4)] + (pad_temp_shared_local[(4)] * kernel_shared_local[(0)]));
      compute_local[(5)] = (compute_local[(5)] + (pad_temp_shared_local[(5)] * kernel_shared_local[(0)]));
      compute_local[(6)] = (compute_local[(6)] + (pad_temp_shared_local[(6)] * kernel_shared_local[(0)]));
      compute_local[(7)] = (compute_local[(7)] + (pad_temp_shared_local[(7)] * kernel_shared_local[(0)]));
      compute_local[(8)] = (compute_local[(8)] + (pad_temp_shared_local[(8)] * kernel_shared_local[(0)]));
      compute_local[(9)] = (compute_local[(9)] + (pad_temp_shared_local[(9)] * kernel_shared_local[(0)]));
      compute_local[(10)] = (compute_local[(10)] + (pad_temp_shared_local[(10)] * kernel_shared_local[(0)]));
      compute_local[(11)] = (compute_local[(11)] + (pad_temp_shared_local[(11)] * kernel_shared_local[(0)]));
      compute_local[(12)] = (compute_local[(12)] + (pad_temp_shared_local[(12)] * kernel_shared_local[(0)]));
      compute_local[(13)] = (compute_local[(13)] + (pad_temp_shared_local[(13)] * kernel_shared_local[(0)]));
      compute_local[(14)] = (compute_local[(14)] + (pad_temp_shared_local[(14)] * kernel_shared_local[(0)]));
      compute_local[(15)] = (compute_local[(15)] + (pad_temp_shared_local[(15)] * kernel_shared_local[(0)]));
      pad_temp_shared_local[(0)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 60))];
      pad_temp_shared_local[(1)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 61))];
      pad_temp_shared_local[(2)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 62))];
      pad_temp_shared_local[(3)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 63))];
      pad_temp_shared_local[(4)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 80))];
      pad_temp_shared_local[(5)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 81))];
      pad_temp_shared_local[(6)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 82))];
      pad_temp_shared_local[(7)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 83))];
      pad_temp_shared_local[(8)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 100))];
      pad_temp_shared_local[(9)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 101))];
      pad_temp_shared_local[(10)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 102))];
      pad_temp_shared_local[(11)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 103))];
      pad_temp_shared_local[(12)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 120))];
      pad_temp_shared_local[(13)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 121))];
      pad_temp_shared_local[(14)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 122))];
      pad_temp_shared_local[(15)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 123))];
      kernel_shared_local[(0)] = kernel_shared[((((((int)threadIdx.z) * 100) + (rc_inner_outer * 25)) + 15))];
      compute_local[(0)] = (compute_local[(0)] + (pad_temp_shared_local[(0)] * kernel_shared_local[(0)]));
      compute_local[(1)] = (compute_local[(1)] + (pad_temp_shared_local[(1)] * kernel_shared_local[(0)]));
      compute_local[(2)] = (compute_local[(2)] + (pad_temp_shared_local[(2)] * kernel_shared_local[(0)]));
      compute_local[(3)] = (compute_local[(3)] + (pad_temp_shared_local[(3)] * kernel_shared_local[(0)]));
      compute_local[(4)] = (compute_local[(4)] + (pad_temp_shared_local[(4)] * kernel_shared_local[(0)]));
      compute_local[(5)] = (compute_local[(5)] + (pad_temp_shared_local[(5)] * kernel_shared_local[(0)]));
      compute_local[(6)] = (compute_local[(6)] + (pad_temp_shared_local[(6)] * kernel_shared_local[(0)]));
      compute_local[(7)] = (compute_local[(7)] + (pad_temp_shared_local[(7)] * kernel_shared_local[(0)]));
      compute_local[(8)] = (compute_local[(8)] + (pad_temp_shared_local[(8)] * kernel_shared_local[(0)]));
      compute_local[(9)] = (compute_local[(9)] + (pad_temp_shared_local[(9)] * kernel_shared_local[(0)]));
      compute_local[(10)] = (compute_local[(10)] + (pad_temp_shared_local[(10)] * kernel_shared_local[(0)]));
      compute_local[(11)] = (compute_local[(11)] + (pad_temp_shared_local[(11)] * kernel_shared_local[(0)]));
      compute_local[(12)] = (compute_local[(12)] + (pad_temp_shared_local[(12)] * kernel_shared_local[(0)]));
      compute_local[(13)] = (compute_local[(13)] + (pad_temp_shared_local[(13)] * kernel_shared_local[(0)]));
      compute_local[(14)] = (compute_local[(14)] + (pad_temp_shared_local[(14)] * kernel_shared_local[(0)]));
      compute_local[(15)] = (compute_local[(15)] + (pad_temp_shared_local[(15)] * kernel_shared_local[(0)]));
      pad_temp_shared_local[(0)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 61))];
      pad_temp_shared_local[(1)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 62))];
      pad_temp_shared_local[(2)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 63))];
      pad_temp_shared_local[(3)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 64))];
      pad_temp_shared_local[(4)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 81))];
      pad_temp_shared_local[(5)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 82))];
      pad_temp_shared_local[(6)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 83))];
      pad_temp_shared_local[(7)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 84))];
      pad_temp_shared_local[(8)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 101))];
      pad_temp_shared_local[(9)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 102))];
      pad_temp_shared_local[(10)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 103))];
      pad_temp_shared_local[(11)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 104))];
      pad_temp_shared_local[(12)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 121))];
      pad_temp_shared_local[(13)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 122))];
      pad_temp_shared_local[(14)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 123))];
      pad_temp_shared_local[(15)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 124))];
      kernel_shared_local[(0)] = kernel_shared[((((((int)threadIdx.z) * 100) + (rc_inner_outer * 25)) + 16))];
      compute_local[(0)] = (compute_local[(0)] + (pad_temp_shared_local[(0)] * kernel_shared_local[(0)]));
      compute_local[(1)] = (compute_local[(1)] + (pad_temp_shared_local[(1)] * kernel_shared_local[(0)]));
      compute_local[(2)] = (compute_local[(2)] + (pad_temp_shared_local[(2)] * kernel_shared_local[(0)]));
      compute_local[(3)] = (compute_local[(3)] + (pad_temp_shared_local[(3)] * kernel_shared_local[(0)]));
      compute_local[(4)] = (compute_local[(4)] + (pad_temp_shared_local[(4)] * kernel_shared_local[(0)]));
      compute_local[(5)] = (compute_local[(5)] + (pad_temp_shared_local[(5)] * kernel_shared_local[(0)]));
      compute_local[(6)] = (compute_local[(6)] + (pad_temp_shared_local[(6)] * kernel_shared_local[(0)]));
      compute_local[(7)] = (compute_local[(7)] + (pad_temp_shared_local[(7)] * kernel_shared_local[(0)]));
      compute_local[(8)] = (compute_local[(8)] + (pad_temp_shared_local[(8)] * kernel_shared_local[(0)]));
      compute_local[(9)] = (compute_local[(9)] + (pad_temp_shared_local[(9)] * kernel_shared_local[(0)]));
      compute_local[(10)] = (compute_local[(10)] + (pad_temp_shared_local[(10)] * kernel_shared_local[(0)]));
      compute_local[(11)] = (compute_local[(11)] + (pad_temp_shared_local[(11)] * kernel_shared_local[(0)]));
      compute_local[(12)] = (compute_local[(12)] + (pad_temp_shared_local[(12)] * kernel_shared_local[(0)]));
      compute_local[(13)] = (compute_local[(13)] + (pad_temp_shared_local[(13)] * kernel_shared_local[(0)]));
      compute_local[(14)] = (compute_local[(14)] + (pad_temp_shared_local[(14)] * kernel_shared_local[(0)]));
      compute_local[(15)] = (compute_local[(15)] + (pad_temp_shared_local[(15)] * kernel_shared_local[(0)]));
      pad_temp_shared_local[(0)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 62))];
      pad_temp_shared_local[(1)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 63))];
      pad_temp_shared_local[(2)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 64))];
      pad_temp_shared_local[(3)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 65))];
      pad_temp_shared_local[(4)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 82))];
      pad_temp_shared_local[(5)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 83))];
      pad_temp_shared_local[(6)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 84))];
      pad_temp_shared_local[(7)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 85))];
      pad_temp_shared_local[(8)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 102))];
      pad_temp_shared_local[(9)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 103))];
      pad_temp_shared_local[(10)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 104))];
      pad_temp_shared_local[(11)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 105))];
      pad_temp_shared_local[(12)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 122))];
      pad_temp_shared_local[(13)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 123))];
      pad_temp_shared_local[(14)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 124))];
      pad_temp_shared_local[(15)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 125))];
      kernel_shared_local[(0)] = kernel_shared[((((((int)threadIdx.z) * 100) + (rc_inner_outer * 25)) + 17))];
      compute_local[(0)] = (compute_local[(0)] + (pad_temp_shared_local[(0)] * kernel_shared_local[(0)]));
      compute_local[(1)] = (compute_local[(1)] + (pad_temp_shared_local[(1)] * kernel_shared_local[(0)]));
      compute_local[(2)] = (compute_local[(2)] + (pad_temp_shared_local[(2)] * kernel_shared_local[(0)]));
      compute_local[(3)] = (compute_local[(3)] + (pad_temp_shared_local[(3)] * kernel_shared_local[(0)]));
      compute_local[(4)] = (compute_local[(4)] + (pad_temp_shared_local[(4)] * kernel_shared_local[(0)]));
      compute_local[(5)] = (compute_local[(5)] + (pad_temp_shared_local[(5)] * kernel_shared_local[(0)]));
      compute_local[(6)] = (compute_local[(6)] + (pad_temp_shared_local[(6)] * kernel_shared_local[(0)]));
      compute_local[(7)] = (compute_local[(7)] + (pad_temp_shared_local[(7)] * kernel_shared_local[(0)]));
      compute_local[(8)] = (compute_local[(8)] + (pad_temp_shared_local[(8)] * kernel_shared_local[(0)]));
      compute_local[(9)] = (compute_local[(9)] + (pad_temp_shared_local[(9)] * kernel_shared_local[(0)]));
      compute_local[(10)] = (compute_local[(10)] + (pad_temp_shared_local[(10)] * kernel_shared_local[(0)]));
      compute_local[(11)] = (compute_local[(11)] + (pad_temp_shared_local[(11)] * kernel_shared_local[(0)]));
      compute_local[(12)] = (compute_local[(12)] + (pad_temp_shared_local[(12)] * kernel_shared_local[(0)]));
      compute_local[(13)] = (compute_local[(13)] + (pad_temp_shared_local[(13)] * kernel_shared_local[(0)]));
      compute_local[(14)] = (compute_local[(14)] + (pad_temp_shared_local[(14)] * kernel_shared_local[(0)]));
      compute_local[(15)] = (compute_local[(15)] + (pad_temp_shared_local[(15)] * kernel_shared_local[(0)]));
      pad_temp_shared_local[(0)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 63))];
      pad_temp_shared_local[(1)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 64))];
      pad_temp_shared_local[(2)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 65))];
      pad_temp_shared_local[(3)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 66))];
      pad_temp_shared_local[(4)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 83))];
      pad_temp_shared_local[(5)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 84))];
      pad_temp_shared_local[(6)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 85))];
      pad_temp_shared_local[(7)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 86))];
      pad_temp_shared_local[(8)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 103))];
      pad_temp_shared_local[(9)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 104))];
      pad_temp_shared_local[(10)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 105))];
      pad_temp_shared_local[(11)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 106))];
      pad_temp_shared_local[(12)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 123))];
      pad_temp_shared_local[(13)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 124))];
      pad_temp_shared_local[(14)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 125))];
      pad_temp_shared_local[(15)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 126))];
      kernel_shared_local[(0)] = kernel_shared[((((((int)threadIdx.z) * 100) + (rc_inner_outer * 25)) + 18))];
      compute_local[(0)] = (compute_local[(0)] + (pad_temp_shared_local[(0)] * kernel_shared_local[(0)]));
      compute_local[(1)] = (compute_local[(1)] + (pad_temp_shared_local[(1)] * kernel_shared_local[(0)]));
      compute_local[(2)] = (compute_local[(2)] + (pad_temp_shared_local[(2)] * kernel_shared_local[(0)]));
      compute_local[(3)] = (compute_local[(3)] + (pad_temp_shared_local[(3)] * kernel_shared_local[(0)]));
      compute_local[(4)] = (compute_local[(4)] + (pad_temp_shared_local[(4)] * kernel_shared_local[(0)]));
      compute_local[(5)] = (compute_local[(5)] + (pad_temp_shared_local[(5)] * kernel_shared_local[(0)]));
      compute_local[(6)] = (compute_local[(6)] + (pad_temp_shared_local[(6)] * kernel_shared_local[(0)]));
      compute_local[(7)] = (compute_local[(7)] + (pad_temp_shared_local[(7)] * kernel_shared_local[(0)]));
      compute_local[(8)] = (compute_local[(8)] + (pad_temp_shared_local[(8)] * kernel_shared_local[(0)]));
      compute_local[(9)] = (compute_local[(9)] + (pad_temp_shared_local[(9)] * kernel_shared_local[(0)]));
      compute_local[(10)] = (compute_local[(10)] + (pad_temp_shared_local[(10)] * kernel_shared_local[(0)]));
      compute_local[(11)] = (compute_local[(11)] + (pad_temp_shared_local[(11)] * kernel_shared_local[(0)]));
      compute_local[(12)] = (compute_local[(12)] + (pad_temp_shared_local[(12)] * kernel_shared_local[(0)]));
      compute_local[(13)] = (compute_local[(13)] + (pad_temp_shared_local[(13)] * kernel_shared_local[(0)]));
      compute_local[(14)] = (compute_local[(14)] + (pad_temp_shared_local[(14)] * kernel_shared_local[(0)]));
      compute_local[(15)] = (compute_local[(15)] + (pad_temp_shared_local[(15)] * kernel_shared_local[(0)]));
      pad_temp_shared_local[(0)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 64))];
      pad_temp_shared_local[(1)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 65))];
      pad_temp_shared_local[(2)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 66))];
      pad_temp_shared_local[(3)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 67))];
      pad_temp_shared_local[(4)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 84))];
      pad_temp_shared_local[(5)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 85))];
      pad_temp_shared_local[(6)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 86))];
      pad_temp_shared_local[(7)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 87))];
      pad_temp_shared_local[(8)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 104))];
      pad_temp_shared_local[(9)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 105))];
      pad_temp_shared_local[(10)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 106))];
      pad_temp_shared_local[(11)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 107))];
      pad_temp_shared_local[(12)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 124))];
      pad_temp_shared_local[(13)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 125))];
      pad_temp_shared_local[(14)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 126))];
      pad_temp_shared_local[(15)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 127))];
      kernel_shared_local[(0)] = kernel_shared[((((((int)threadIdx.z) * 100) + (rc_inner_outer * 25)) + 19))];
      compute_local[(0)] = (compute_local[(0)] + (pad_temp_shared_local[(0)] * kernel_shared_local[(0)]));
      compute_local[(1)] = (compute_local[(1)] + (pad_temp_shared_local[(1)] * kernel_shared_local[(0)]));
      compute_local[(2)] = (compute_local[(2)] + (pad_temp_shared_local[(2)] * kernel_shared_local[(0)]));
      compute_local[(3)] = (compute_local[(3)] + (pad_temp_shared_local[(3)] * kernel_shared_local[(0)]));
      compute_local[(4)] = (compute_local[(4)] + (pad_temp_shared_local[(4)] * kernel_shared_local[(0)]));
      compute_local[(5)] = (compute_local[(5)] + (pad_temp_shared_local[(5)] * kernel_shared_local[(0)]));
      compute_local[(6)] = (compute_local[(6)] + (pad_temp_shared_local[(6)] * kernel_shared_local[(0)]));
      compute_local[(7)] = (compute_local[(7)] + (pad_temp_shared_local[(7)] * kernel_shared_local[(0)]));
      compute_local[(8)] = (compute_local[(8)] + (pad_temp_shared_local[(8)] * kernel_shared_local[(0)]));
      compute_local[(9)] = (compute_local[(9)] + (pad_temp_shared_local[(9)] * kernel_shared_local[(0)]));
      compute_local[(10)] = (compute_local[(10)] + (pad_temp_shared_local[(10)] * kernel_shared_local[(0)]));
      compute_local[(11)] = (compute_local[(11)] + (pad_temp_shared_local[(11)] * kernel_shared_local[(0)]));
      compute_local[(12)] = (compute_local[(12)] + (pad_temp_shared_local[(12)] * kernel_shared_local[(0)]));
      compute_local[(13)] = (compute_local[(13)] + (pad_temp_shared_local[(13)] * kernel_shared_local[(0)]));
      compute_local[(14)] = (compute_local[(14)] + (pad_temp_shared_local[(14)] * kernel_shared_local[(0)]));
      compute_local[(15)] = (compute_local[(15)] + (pad_temp_shared_local[(15)] * kernel_shared_local[(0)]));
      pad_temp_shared_local[(0)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 80))];
      pad_temp_shared_local[(1)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 81))];
      pad_temp_shared_local[(2)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 82))];
      pad_temp_shared_local[(3)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 83))];
      pad_temp_shared_local[(4)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 100))];
      pad_temp_shared_local[(5)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 101))];
      pad_temp_shared_local[(6)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 102))];
      pad_temp_shared_local[(7)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 103))];
      pad_temp_shared_local[(8)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 120))];
      pad_temp_shared_local[(9)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 121))];
      pad_temp_shared_local[(10)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 122))];
      pad_temp_shared_local[(11)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 123))];
      pad_temp_shared_local[(12)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 140))];
      pad_temp_shared_local[(13)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 141))];
      pad_temp_shared_local[(14)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 142))];
      pad_temp_shared_local[(15)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 143))];
      kernel_shared_local[(0)] = kernel_shared[((((((int)threadIdx.z) * 100) + (rc_inner_outer * 25)) + 20))];
      compute_local[(0)] = (compute_local[(0)] + (pad_temp_shared_local[(0)] * kernel_shared_local[(0)]));
      compute_local[(1)] = (compute_local[(1)] + (pad_temp_shared_local[(1)] * kernel_shared_local[(0)]));
      compute_local[(2)] = (compute_local[(2)] + (pad_temp_shared_local[(2)] * kernel_shared_local[(0)]));
      compute_local[(3)] = (compute_local[(3)] + (pad_temp_shared_local[(3)] * kernel_shared_local[(0)]));
      compute_local[(4)] = (compute_local[(4)] + (pad_temp_shared_local[(4)] * kernel_shared_local[(0)]));
      compute_local[(5)] = (compute_local[(5)] + (pad_temp_shared_local[(5)] * kernel_shared_local[(0)]));
      compute_local[(6)] = (compute_local[(6)] + (pad_temp_shared_local[(6)] * kernel_shared_local[(0)]));
      compute_local[(7)] = (compute_local[(7)] + (pad_temp_shared_local[(7)] * kernel_shared_local[(0)]));
      compute_local[(8)] = (compute_local[(8)] + (pad_temp_shared_local[(8)] * kernel_shared_local[(0)]));
      compute_local[(9)] = (compute_local[(9)] + (pad_temp_shared_local[(9)] * kernel_shared_local[(0)]));
      compute_local[(10)] = (compute_local[(10)] + (pad_temp_shared_local[(10)] * kernel_shared_local[(0)]));
      compute_local[(11)] = (compute_local[(11)] + (pad_temp_shared_local[(11)] * kernel_shared_local[(0)]));
      compute_local[(12)] = (compute_local[(12)] + (pad_temp_shared_local[(12)] * kernel_shared_local[(0)]));
      compute_local[(13)] = (compute_local[(13)] + (pad_temp_shared_local[(13)] * kernel_shared_local[(0)]));
      compute_local[(14)] = (compute_local[(14)] + (pad_temp_shared_local[(14)] * kernel_shared_local[(0)]));
      compute_local[(15)] = (compute_local[(15)] + (pad_temp_shared_local[(15)] * kernel_shared_local[(0)]));
      pad_temp_shared_local[(0)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 81))];
      pad_temp_shared_local[(1)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 82))];
      pad_temp_shared_local[(2)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 83))];
      pad_temp_shared_local[(3)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 84))];
      pad_temp_shared_local[(4)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 101))];
      pad_temp_shared_local[(5)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 102))];
      pad_temp_shared_local[(6)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 103))];
      pad_temp_shared_local[(7)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 104))];
      pad_temp_shared_local[(8)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 121))];
      pad_temp_shared_local[(9)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 122))];
      pad_temp_shared_local[(10)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 123))];
      pad_temp_shared_local[(11)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 124))];
      pad_temp_shared_local[(12)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 141))];
      pad_temp_shared_local[(13)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 142))];
      pad_temp_shared_local[(14)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 143))];
      pad_temp_shared_local[(15)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 144))];
      kernel_shared_local[(0)] = kernel_shared[((((((int)threadIdx.z) * 100) + (rc_inner_outer * 25)) + 21))];
      compute_local[(0)] = (compute_local[(0)] + (pad_temp_shared_local[(0)] * kernel_shared_local[(0)]));
      compute_local[(1)] = (compute_local[(1)] + (pad_temp_shared_local[(1)] * kernel_shared_local[(0)]));
      compute_local[(2)] = (compute_local[(2)] + (pad_temp_shared_local[(2)] * kernel_shared_local[(0)]));
      compute_local[(3)] = (compute_local[(3)] + (pad_temp_shared_local[(3)] * kernel_shared_local[(0)]));
      compute_local[(4)] = (compute_local[(4)] + (pad_temp_shared_local[(4)] * kernel_shared_local[(0)]));
      compute_local[(5)] = (compute_local[(5)] + (pad_temp_shared_local[(5)] * kernel_shared_local[(0)]));
      compute_local[(6)] = (compute_local[(6)] + (pad_temp_shared_local[(6)] * kernel_shared_local[(0)]));
      compute_local[(7)] = (compute_local[(7)] + (pad_temp_shared_local[(7)] * kernel_shared_local[(0)]));
      compute_local[(8)] = (compute_local[(8)] + (pad_temp_shared_local[(8)] * kernel_shared_local[(0)]));
      compute_local[(9)] = (compute_local[(9)] + (pad_temp_shared_local[(9)] * kernel_shared_local[(0)]));
      compute_local[(10)] = (compute_local[(10)] + (pad_temp_shared_local[(10)] * kernel_shared_local[(0)]));
      compute_local[(11)] = (compute_local[(11)] + (pad_temp_shared_local[(11)] * kernel_shared_local[(0)]));
      compute_local[(12)] = (compute_local[(12)] + (pad_temp_shared_local[(12)] * kernel_shared_local[(0)]));
      compute_local[(13)] = (compute_local[(13)] + (pad_temp_shared_local[(13)] * kernel_shared_local[(0)]));
      compute_local[(14)] = (compute_local[(14)] + (pad_temp_shared_local[(14)] * kernel_shared_local[(0)]));
      compute_local[(15)] = (compute_local[(15)] + (pad_temp_shared_local[(15)] * kernel_shared_local[(0)]));
      pad_temp_shared_local[(0)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 82))];
      pad_temp_shared_local[(1)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 83))];
      pad_temp_shared_local[(2)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 84))];
      pad_temp_shared_local[(3)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 85))];
      pad_temp_shared_local[(4)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 102))];
      pad_temp_shared_local[(5)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 103))];
      pad_temp_shared_local[(6)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 104))];
      pad_temp_shared_local[(7)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 105))];
      pad_temp_shared_local[(8)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 122))];
      pad_temp_shared_local[(9)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 123))];
      pad_temp_shared_local[(10)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 124))];
      pad_temp_shared_local[(11)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 125))];
      pad_temp_shared_local[(12)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 142))];
      pad_temp_shared_local[(13)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 143))];
      pad_temp_shared_local[(14)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 144))];
      pad_temp_shared_local[(15)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 145))];
      kernel_shared_local[(0)] = kernel_shared[((((((int)threadIdx.z) * 100) + (rc_inner_outer * 25)) + 22))];
      compute_local[(0)] = (compute_local[(0)] + (pad_temp_shared_local[(0)] * kernel_shared_local[(0)]));
      compute_local[(1)] = (compute_local[(1)] + (pad_temp_shared_local[(1)] * kernel_shared_local[(0)]));
      compute_local[(2)] = (compute_local[(2)] + (pad_temp_shared_local[(2)] * kernel_shared_local[(0)]));
      compute_local[(3)] = (compute_local[(3)] + (pad_temp_shared_local[(3)] * kernel_shared_local[(0)]));
      compute_local[(4)] = (compute_local[(4)] + (pad_temp_shared_local[(4)] * kernel_shared_local[(0)]));
      compute_local[(5)] = (compute_local[(5)] + (pad_temp_shared_local[(5)] * kernel_shared_local[(0)]));
      compute_local[(6)] = (compute_local[(6)] + (pad_temp_shared_local[(6)] * kernel_shared_local[(0)]));
      compute_local[(7)] = (compute_local[(7)] + (pad_temp_shared_local[(7)] * kernel_shared_local[(0)]));
      compute_local[(8)] = (compute_local[(8)] + (pad_temp_shared_local[(8)] * kernel_shared_local[(0)]));
      compute_local[(9)] = (compute_local[(9)] + (pad_temp_shared_local[(9)] * kernel_shared_local[(0)]));
      compute_local[(10)] = (compute_local[(10)] + (pad_temp_shared_local[(10)] * kernel_shared_local[(0)]));
      compute_local[(11)] = (compute_local[(11)] + (pad_temp_shared_local[(11)] * kernel_shared_local[(0)]));
      compute_local[(12)] = (compute_local[(12)] + (pad_temp_shared_local[(12)] * kernel_shared_local[(0)]));
      compute_local[(13)] = (compute_local[(13)] + (pad_temp_shared_local[(13)] * kernel_shared_local[(0)]));
      compute_local[(14)] = (compute_local[(14)] + (pad_temp_shared_local[(14)] * kernel_shared_local[(0)]));
      compute_local[(15)] = (compute_local[(15)] + (pad_temp_shared_local[(15)] * kernel_shared_local[(0)]));
      pad_temp_shared_local[(0)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 83))];
      pad_temp_shared_local[(1)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 84))];
      pad_temp_shared_local[(2)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 85))];
      pad_temp_shared_local[(3)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 86))];
      pad_temp_shared_local[(4)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 103))];
      pad_temp_shared_local[(5)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 104))];
      pad_temp_shared_local[(6)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 105))];
      pad_temp_shared_local[(7)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 106))];
      pad_temp_shared_local[(8)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 123))];
      pad_temp_shared_local[(9)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 124))];
      pad_temp_shared_local[(10)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 125))];
      pad_temp_shared_local[(11)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 126))];
      pad_temp_shared_local[(12)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 143))];
      pad_temp_shared_local[(13)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 144))];
      pad_temp_shared_local[(14)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 145))];
      pad_temp_shared_local[(15)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 146))];
      kernel_shared_local[(0)] = kernel_shared[((((((int)threadIdx.z) * 100) + (rc_inner_outer * 25)) + 23))];
      compute_local[(0)] = (compute_local[(0)] + (pad_temp_shared_local[(0)] * kernel_shared_local[(0)]));
      compute_local[(1)] = (compute_local[(1)] + (pad_temp_shared_local[(1)] * kernel_shared_local[(0)]));
      compute_local[(2)] = (compute_local[(2)] + (pad_temp_shared_local[(2)] * kernel_shared_local[(0)]));
      compute_local[(3)] = (compute_local[(3)] + (pad_temp_shared_local[(3)] * kernel_shared_local[(0)]));
      compute_local[(4)] = (compute_local[(4)] + (pad_temp_shared_local[(4)] * kernel_shared_local[(0)]));
      compute_local[(5)] = (compute_local[(5)] + (pad_temp_shared_local[(5)] * kernel_shared_local[(0)]));
      compute_local[(6)] = (compute_local[(6)] + (pad_temp_shared_local[(6)] * kernel_shared_local[(0)]));
      compute_local[(7)] = (compute_local[(7)] + (pad_temp_shared_local[(7)] * kernel_shared_local[(0)]));
      compute_local[(8)] = (compute_local[(8)] + (pad_temp_shared_local[(8)] * kernel_shared_local[(0)]));
      compute_local[(9)] = (compute_local[(9)] + (pad_temp_shared_local[(9)] * kernel_shared_local[(0)]));
      compute_local[(10)] = (compute_local[(10)] + (pad_temp_shared_local[(10)] * kernel_shared_local[(0)]));
      compute_local[(11)] = (compute_local[(11)] + (pad_temp_shared_local[(11)] * kernel_shared_local[(0)]));
      compute_local[(12)] = (compute_local[(12)] + (pad_temp_shared_local[(12)] * kernel_shared_local[(0)]));
      compute_local[(13)] = (compute_local[(13)] + (pad_temp_shared_local[(13)] * kernel_shared_local[(0)]));
      compute_local[(14)] = (compute_local[(14)] + (pad_temp_shared_local[(14)] * kernel_shared_local[(0)]));
      compute_local[(15)] = (compute_local[(15)] + (pad_temp_shared_local[(15)] * kernel_shared_local[(0)]));
      pad_temp_shared_local[(0)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 84))];
      pad_temp_shared_local[(1)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 85))];
      pad_temp_shared_local[(2)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 86))];
      pad_temp_shared_local[(3)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 87))];
      pad_temp_shared_local[(4)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 104))];
      pad_temp_shared_local[(5)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 105))];
      pad_temp_shared_local[(6)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 106))];
      pad_temp_shared_local[(7)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 107))];
      pad_temp_shared_local[(8)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 124))];
      pad_temp_shared_local[(9)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 125))];
      pad_temp_shared_local[(10)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 126))];
      pad_temp_shared_local[(11)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 127))];
      pad_temp_shared_local[(12)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 144))];
      pad_temp_shared_local[(13)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 145))];
      pad_temp_shared_local[(14)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 146))];
      pad_temp_shared_local[(15)] = pad_temp_shared[((((rc_inner_outer * 160) + (((int)threadIdx.x) * 4)) + 147))];
      kernel_shared_local[(0)] = kernel_shared[((((((int)threadIdx.z) * 100) + (rc_inner_outer * 25)) + 24))];
      compute_local[(0)] = (compute_local[(0)] + (pad_temp_shared_local[(0)] * kernel_shared_local[(0)]));
      compute_local[(1)] = (compute_local[(1)] + (pad_temp_shared_local[(1)] * kernel_shared_local[(0)]));
      compute_local[(2)] = (compute_local[(2)] + (pad_temp_shared_local[(2)] * kernel_shared_local[(0)]));
      compute_local[(3)] = (compute_local[(3)] + (pad_temp_shared_local[(3)] * kernel_shared_local[(0)]));
      compute_local[(4)] = (compute_local[(4)] + (pad_temp_shared_local[(4)] * kernel_shared_local[(0)]));
      compute_local[(5)] = (compute_local[(5)] + (pad_temp_shared_local[(5)] * kernel_shared_local[(0)]));
      compute_local[(6)] = (compute_local[(6)] + (pad_temp_shared_local[(6)] * kernel_shared_local[(0)]));
      compute_local[(7)] = (compute_local[(7)] + (pad_temp_shared_local[(7)] * kernel_shared_local[(0)]));
      compute_local[(8)] = (compute_local[(8)] + (pad_temp_shared_local[(8)] * kernel_shared_local[(0)]));
      compute_local[(9)] = (compute_local[(9)] + (pad_temp_shared_local[(9)] * kernel_shared_local[(0)]));
      compute_local[(10)] = (compute_local[(10)] + (pad_temp_shared_local[(10)] * kernel_shared_local[(0)]));
      compute_local[(11)] = (compute_local[(11)] + (pad_temp_shared_local[(11)] * kernel_shared_local[(0)]));
      compute_local[(12)] = (compute_local[(12)] + (pad_temp_shared_local[(12)] * kernel_shared_local[(0)]));
      compute_local[(13)] = (compute_local[(13)] + (pad_temp_shared_local[(13)] * kernel_shared_local[(0)]));
      compute_local[(14)] = (compute_local[(14)] + (pad_temp_shared_local[(14)] * kernel_shared_local[(0)]));
      compute_local[(15)] = (compute_local[(15)] + (pad_temp_shared_local[(15)] * kernel_shared_local[(0)]));
    }
  }
  compute[((((((((int)blockIdx.z) * 2097152) + (((int)threadIdx.z) * 65536)) + (((int)blockIdx.y) * 1024)) + (((int)blockIdx.x) * 16)) + (((int)threadIdx.x) * 4)))] = compute_local[(0)];
  compute[(((((((((int)blockIdx.z) * 2097152) + (((int)threadIdx.z) * 65536)) + (((int)blockIdx.y) * 1024)) + (((int)blockIdx.x) * 16)) + (((int)threadIdx.x) * 4)) + 1))] = compute_local[(1)];
  compute[(((((((((int)blockIdx.z) * 2097152) + (((int)threadIdx.z) * 65536)) + (((int)blockIdx.y) * 1024)) + (((int)blockIdx.x) * 16)) + (((int)threadIdx.x) * 4)) + 2))] = compute_local[(2)];
  compute[(((((((((int)blockIdx.z) * 2097152) + (((int)threadIdx.z) * 65536)) + (((int)blockIdx.y) * 1024)) + (((int)blockIdx.x) * 16)) + (((int)threadIdx.x) * 4)) + 3))] = compute_local[(3)];
  compute[(((((((((int)blockIdx.z) * 2097152) + (((int)threadIdx.z) * 65536)) + (((int)blockIdx.y) * 1024)) + (((int)blockIdx.x) * 16)) + (((int)threadIdx.x) * 4)) + 256))] = compute_local[(4)];
  compute[(((((((((int)blockIdx.z) * 2097152) + (((int)threadIdx.z) * 65536)) + (((int)blockIdx.y) * 1024)) + (((int)blockIdx.x) * 16)) + (((int)threadIdx.x) * 4)) + 257))] = compute_local[(5)];
  compute[(((((((((int)blockIdx.z) * 2097152) + (((int)threadIdx.z) * 65536)) + (((int)blockIdx.y) * 1024)) + (((int)blockIdx.x) * 16)) + (((int)threadIdx.x) * 4)) + 258))] = compute_local[(6)];
  compute[(((((((((int)blockIdx.z) * 2097152) + (((int)threadIdx.z) * 65536)) + (((int)blockIdx.y) * 1024)) + (((int)blockIdx.x) * 16)) + (((int)threadIdx.x) * 4)) + 259))] = compute_local[(7)];
  compute[(((((((((int)blockIdx.z) * 2097152) + (((int)threadIdx.z) * 65536)) + (((int)blockIdx.y) * 1024)) + (((int)blockIdx.x) * 16)) + (((int)threadIdx.x) * 4)) + 512))] = compute_local[(8)];
  compute[(((((((((int)blockIdx.z) * 2097152) + (((int)threadIdx.z) * 65536)) + (((int)blockIdx.y) * 1024)) + (((int)blockIdx.x) * 16)) + (((int)threadIdx.x) * 4)) + 513))] = compute_local[(9)];
  compute[(((((((((int)blockIdx.z) * 2097152) + (((int)threadIdx.z) * 65536)) + (((int)blockIdx.y) * 1024)) + (((int)blockIdx.x) * 16)) + (((int)threadIdx.x) * 4)) + 514))] = compute_local[(10)];
  compute[(((((((((int)blockIdx.z) * 2097152) + (((int)threadIdx.z) * 65536)) + (((int)blockIdx.y) * 1024)) + (((int)blockIdx.x) * 16)) + (((int)threadIdx.x) * 4)) + 515))] = compute_local[(11)];
  compute[(((((((((int)blockIdx.z) * 2097152) + (((int)threadIdx.z) * 65536)) + (((int)blockIdx.y) * 1024)) + (((int)blockIdx.x) * 16)) + (((int)threadIdx.x) * 4)) + 768))] = compute_local[(12)];
  compute[(((((((((int)blockIdx.z) * 2097152) + (((int)threadIdx.z) * 65536)) + (((int)blockIdx.y) * 1024)) + (((int)blockIdx.x) * 16)) + (((int)threadIdx.x) * 4)) + 769))] = compute_local[(13)];
  compute[(((((((((int)blockIdx.z) * 2097152) + (((int)threadIdx.z) * 65536)) + (((int)blockIdx.y) * 1024)) + (((int)blockIdx.x) * 16)) + (((int)threadIdx.x) * 4)) + 770))] = compute_local[(14)];
  compute[(((((((((int)blockIdx.z) * 2097152) + (((int)threadIdx.z) * 65536)) + (((int)blockIdx.y) * 1024)) + (((int)blockIdx.x) * 16)) + (((int)threadIdx.x) * 4)) + 771))] = compute_local[(15)];
}

int main() {
  int batch = 1;
  int in_channel = 32;
  int in_height = 256;
  int in_width = 256;
  int num_filter = 64;

  float* images;
  float* kernelsf;
  float* computef;
  float* kernels5;
  float* compute5;
  float* kernels3;
  float* compute3;

  cudaMalloc((void**)&images, batch * in_channel * in_height * in_width * sizeof(float));

  cudaMalloc((void**)&kernelsf, 2 * num_filter * in_channel * 5 * 5 * sizeof(float));
  cudaMalloc((void**)&computef, 2 * batch * in_width * in_height * num_filter * sizeof(float));

  cudaMalloc((void**)&kernels5, num_filter * in_channel * 5 * 5 * sizeof(float));
  cudaMalloc((void**)&compute5, batch * in_width * in_height * num_filter * sizeof(float));

  cudaMalloc((void**)&kernels3, 2 * num_filter * in_channel * 3 * 3 * sizeof(float));
  cudaMalloc((void**)&compute3, batch * in_width * in_height * num_filter * sizeof(float));

  int w_iters = 1000;
  int iters = 1000 + w_iters;
  float no_fused5 = 0;
  float no_fused3 = 0;
  float partially_fused = 0;
  float fully_fused = 0;

  dim3 ugrid3 = dim3(16, 32, 1);
  dim3 ublock3 = dim3(16, 1, 8);
  dim3 ugrid5 = dim3(4, 64, 1);
  dim3 ublock5 = dim3(16, 1, 8);

  // dim3 pgrid = dim3(16, 32, 1);
  // dim3 pblock = dim3(4, 2, 8);
  dim3 pgrid = dim3(4, 64, 1);
  dim3 pblock = dim3(16, 1, 8);

  dim3 fgrid = dim3(16, 64, 2);
  dim3 fblock = dim3(4, 1, 32);

  for (int i = 0; i < iters; ++i) {
    {
      cudaEvent_t start, end;
      float elapsed = 0;
      cudaEventCreate(&start);
      cudaEventCreate(&end);
      cudaEventRecord(start);

      conv5<<<ugrid5, ublock5>>>(images, kernels5, compute5);

      cudaEventRecord(end);
      cudaEventSynchronize(end);
      cudaEventElapsedTime(&elapsed, start, end);
      if (i >= w_iters) no_fused5 += elapsed;
    }
    {
      cudaEvent_t start, end;
      float elapsed = 0;
      cudaEventCreate(&start);
      cudaEventCreate(&end);
      cudaEventRecord(start);

      conv3<<<ugrid3, ublock3>>>(images, kernels3, compute3);

      cudaEventRecord(end);
      cudaEventSynchronize(end);
      cudaEventElapsedTime(&elapsed, start, end);
      if (i >= w_iters) no_fused3 += elapsed;
    }
    {
      cudaEvent_t start, end;
      float elapsed = 0;
      cudaEventCreate(&start);
      cudaEventCreate(&end);
      cudaEventRecord(start);

      conv_partially_fused<<<pgrid, pblock>>>(images, kernels5, kernels3, compute5, compute3);

      cudaEventRecord(end);
      cudaEventSynchronize(end);
      cudaEventElapsedTime(&elapsed, start, end);
      if (i >= w_iters) partially_fused += elapsed;
    }
    {
      cudaEvent_t start, end;
      float elapsed = 0;
      cudaEventCreate(&start);
      cudaEventCreate(&end);
      cudaEventRecord(start);

      conv_fused<<<fgrid, fblock>>>(images, kernelsf, computef);

      cudaEventRecord(end);
      cudaEventSynchronize(end);
      cudaEventElapsedTime(&elapsed, start, end);
      if (i >= w_iters) fully_fused += elapsed;
    }
  }

  float no_fused = no_fused5 + no_fused3;
  std::cout << "No Fusion      : " << no_fused / iters << " (" << no_fused5 / iters << ", " << no_fused3 / iters << ")" << std::endl;
  std::cout << "Partial Fusion : " << partially_fused / iters << std::endl;
  std::cout << "Full Fusion    : " << fully_fused / iters << std::endl;
}
