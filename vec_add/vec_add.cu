#include <stdio.h>
#include <stdlib.h>

__global__ void vector_add(float *a, float *b, float *c, int n)
{
    int i = blockDim.x * blockIdx.x + threadIdx.x;
    if (i < n)
        c[i] = a[i] + b[i];
}

// Calculate number of blocks needed
static unsigned num_blocks(int num, int factor) {
    return (num + factor - 1) / factor;
}

int main(int argc, char** argv)
{
    if (argc < 2) {
        fprintf(stderr, "Usage: %s N\n", argv[0]);
        return 1;
    }
    int N = atoi(argv[1]);

    float *h_a = (float*)malloc(N * sizeof(float));
    float *h_b = (float*)malloc(N * sizeof(float));
    float *h_c = (float*)malloc(N * sizeof(float));
    if (!h_a || !h_b || !h_c) {
        fprintf(stderr, "Host malloc failed\n");
        return 1;
    }

    for (int i = 0; i < N; i++) {
        h_a[i] = i;
        h_b[i] = i * 2.0f;
    }

    float *d_a, *d_b, *d_c;
    cudaMalloc(&d_a, N * sizeof(float));
    cudaMalloc(&d_b, N * sizeof(float));
    cudaMalloc(&d_c, N * sizeof(float));

    cudaMemcpy(d_a, h_a, N * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, h_b, N * sizeof(float), cudaMemcpyHostToDevice);

    const int threadsPerBlock = 256;
    int blocksNeeded = num_blocks(N, threadsPerBlock);
    vector_add<<<blocksNeeded, threadsPerBlock>>>(d_a, d_b, d_c, N);
    cudaDeviceSynchronize();

    cudaMemcpy(h_c, d_c, N * sizeof(float), cudaMemcpyDeviceToHost);

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

    for (int i = 0; i < N; i++)
        printf("%.1f + %.1f = %.1f\n", h_a[i], h_b[i], h_c[i]);

    free(h_a);
    free(h_b);
    free(h_c);
    return 0;
}

