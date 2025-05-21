#include <stdio.h>
#include <stdlib.h>

// Define a simple Atom structure
struct Atom {
    float x, y, z;
    int type;
};

#define N 10

__global__ void vector_add(float *a, float *b, float *c, int n)
{
    int i = threadIdx.x;
    if (i < n)
        c[i] = a[i] + b[i];
}

// A simple kernel that uses Atom structure but has same structure as vector_add
__global__ void atom_add(Atom *atoms_a, Atom *atoms_b, Atom *atoms_c, int n)
{
    int i = threadIdx.x;
    if (i < n) {
        atoms_c[i].x = atoms_a[i].x + atoms_b[i].x;
        atoms_c[i].y = atoms_a[i].y + atoms_b[i].y;
        atoms_c[i].z = atoms_a[i].z + atoms_b[i].z;
        atoms_c[i].type = atoms_a[i].type;
    }
}

int main()
{
    // Test vector_add first to verify it still works
    // Allocate host memory
    float *h_a = (float*)malloc(N * sizeof(float));
    float *h_b = (float*)malloc(N * sizeof(float));
    float *h_c = (float*)malloc(N * sizeof(float));

    // Initialize host arrays
    for (int i = 0; i < N; i++)
    {
        h_a[i] = i;
        h_b[i] = i * 2.0f;
    }

    // Allocate device memory
    float *d_a, *d_b, *d_c;
    cudaMalloc(&d_a, N * sizeof(float));
    cudaMalloc(&d_b, N * sizeof(float));
    cudaMalloc(&d_c, N * sizeof(float));

    // Copy host memory to device
    cudaMemcpy(d_a, h_a, N * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, h_b, N * sizeof(float), cudaMemcpyHostToDevice);

    // Execute kernel
    vector_add<<<1, N>>>(d_a, d_b, d_c, N);

    // Copy device memory to host
    cudaMemcpy(h_c, d_c, N * sizeof(float), cudaMemcpyDeviceToHost);

    // Verify results
    printf("Vector addition results:\n");
    for (int i = 0; i < 3; i++) // Only print first few results
    {
        printf("%.1f + %.1f = %.1f\n", h_a[i], h_b[i], h_c[i]);
    }

    // Free memory
    free(h_a);
    free(h_b);
    free(h_c);
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

    // Now test atom_add
    // Allocate host memory for Atoms
    Atom *h_atoms_a = (Atom*)malloc(N * sizeof(Atom));
    Atom *h_atoms_b = (Atom*)malloc(N * sizeof(Atom));
    Atom *h_atoms_c = (Atom*)malloc(N * sizeof(Atom));

    // Initialize host arrays
    for (int i = 0; i < N; i++)
    {
        h_atoms_a[i].x = i * 0.1f;
        h_atoms_a[i].y = i * 0.2f;
        h_atoms_a[i].z = i * 0.3f;
        h_atoms_a[i].type = i;
        
        h_atoms_b[i].x = i * 0.5f;
        h_atoms_b[i].y = i * 0.6f;
        h_atoms_b[i].z = i * 0.7f;
        h_atoms_b[i].type = i;
    }

    // Allocate device memory
    Atom *d_atoms_a, *d_atoms_b, *d_atoms_c;
    cudaMalloc(&d_atoms_a, N * sizeof(Atom));
    cudaMalloc(&d_atoms_b, N * sizeof(Atom));
    cudaMalloc(&d_atoms_c, N * sizeof(Atom));

    // Copy host memory to device
    cudaMemcpy(d_atoms_a, h_atoms_a, N * sizeof(Atom), cudaMemcpyHostToDevice);
    cudaMemcpy(d_atoms_b, h_atoms_b, N * sizeof(Atom), cudaMemcpyHostToDevice);

    // Execute kernel
    atom_add<<<1, N>>>(d_atoms_a, d_atoms_b, d_atoms_c, N);

    // Copy device memory to host
    cudaMemcpy(h_atoms_c, d_atoms_c, N * sizeof(Atom), cudaMemcpyDeviceToHost);

    // Verify results
    printf("\nAtom addition results:\n");
    for (int i = 0; i < 3; i++) // Only print first few results
    {
        printf("Atom %d: (%.1f,%.1f,%.1f) + (%.1f,%.1f,%.1f) = (%.1f,%.1f,%.1f)\n", 
               i,
               h_atoms_a[i].x, h_atoms_a[i].y, h_atoms_a[i].z,
               h_atoms_b[i].x, h_atoms_b[i].y, h_atoms_b[i].z,
               h_atoms_c[i].x, h_atoms_c[i].y, h_atoms_c[i].z);
    }

    // Free memory
    free(h_atoms_a);
    free(h_atoms_b);
    free(h_atoms_c);
    cudaFree(d_atoms_a);
    cudaFree(d_atoms_b);
    cudaFree(d_atoms_c);

    return 0;
}
