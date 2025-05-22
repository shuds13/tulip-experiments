#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <time.h> 
#include <sys/time.h>

#define ZERO 0.0f
#define QUARTER 0.25f
#define HALF 0.5f
#define ONE 1.0f
#define TWO 2.0f
#define FOUR 4.0f
#define CNSTNT 45.0f
#define HARDNESS 38.0f
#define PPWI 64
#define HBTYPE_F 70
#define HBTYPE_E 69
#define NPNPDIST 5.5f
#define NPPDIST 1.0f
#define FloatMax 3.40282347e+38f  // std::numeric_limits<float>::max()
// #define USE_SHARED 0  // SH Changed from empty definition to value 1 for evaluation in expressions

// Define a simple Atom structure
struct Atom {
  float x, y, z;
  int type;
};

// Define FFParams structure like the original
struct FFParams {
  int hbtype;
  float radius;
  float hphb;
  float elsc;
};

// SH fabsf fails in splendid
// LLVM ERROR: Code generator does not support intrinsic function 'llvm.nvvm.fabs.f'!
static __forceinline__ __device__ __host__
float fasten_fabsf(float x) {
    return x < 0.0f ? -x : x;
}

// A simplified kernel implementation that avoids sin/cos and complex memory patterns
__global__ void fasten_kernel(int natlig, int natpro,
                           const Atom* protein_molecule,
                           const Atom* ligand_molecule,
                           const float* transforms_0, const float* transforms_1, const float* transforms_2,
                           const float* transforms_3, const float* transforms_4, const float* transforms_5,
                           float* etotals, const FFParams* forcefield, int numTransforms, int ntypes) {
  // Get index of first transform
  int ix = blockIdx.x * blockDim.x * PPWI + threadIdx.x;
  
  // Have extra threads do the last member instead of returning
  ix = ix < numTransforms ? ix : numTransforms - PPWI;
  
  // Use shared memory for forcefield parameters
// #ifdef USE_SHARED
//   extern __shared__ FFParams forcefield[];
//   if (threadIdx.x < ntypes) {
//     forcefield[threadIdx.x] = global_forcefield[threadIdx.x];
//   }
//   __syncthreads(); // Ensure all threads have loaded the forcefield data
// #else
//   const FFParams* forcefield = global_forcefield;
// #endif
  
  // Compute transformation matrices for all poses in this work item
  float transform[PPWI][3][4]; // [pose][row][column]
  
  const size_t lsz = blockDim.x;
  for (int i = 0; i < PPWI; i++) {
    size_t index = ix + i * lsz;
    if (index >= numTransforms) continue;
    
    // Load transform values for this pose
    transform[i][0][0] = transforms_0[index]; // transform_0_x
    transform[i][0][1] = transforms_1[index]; // transform_0_y
    transform[i][0][2] = transforms_2[index]; // transform_0_z
    transform[i][0][3] = transforms_3[index]; // transform_0_w
    transform[i][1][0] = transforms_0[index]; // transform_1_x - reusing
    transform[i][1][1] = transforms_1[index]; // transform_1_y - reusing
    transform[i][1][2] = transforms_2[index]; // transform_1_z - reusing
    transform[i][1][3] = transforms_4[index]; // transform_1_w
    transform[i][2][0] = transforms_0[index]; // transform_2_x - reusing
    transform[i][2][1] = transforms_1[index]; // transform_2_y - reusing
    transform[i][2][2] = transforms_2[index]; // transform_2_z - reusing
    transform[i][2][3] = transforms_5[index]; // transform_2_w
  }
  
  // Initialize energy results for all poses in this work item
  float etot[PPWI];
  for (int i = 0; i < PPWI; i++) {
    etot[i] = ZERO;
  }
  
  // Loop over ligand atoms
  for (int il = 0; il < natlig; il++) {
    // Load ligand atom data
    const Atom l_atom = ligand_molecule[il];
    const FFParams l_params = forcefield[l_atom.type];
    
    // Determine ligand atom parameters
    const bool lhphb_ltz = l_params.hphb < ZERO;
    const bool lhphb_gtz = l_params.hphb > ZERO;
    
    // Apply transforms to ligand atom for all poses in this work item
    float lpos[PPWI][3]; // [pose][coordinate]
    for (int i = 0; i < PPWI; i++) {
      // Apply transform
      lpos[i][0] = transform[i][0][3] + l_atom.x * transform[i][0][0] + l_atom.y * transform[i][0][1] + l_atom.z * transform[i][0][2];
      lpos[i][1] = transform[i][1][3] + l_atom.x * transform[i][1][0] + l_atom.y * transform[i][1][1] + l_atom.z * transform[i][1][2];
      lpos[i][2] = transform[i][2][3] + l_atom.x * transform[i][2][0] + l_atom.y * transform[i][2][1] + l_atom.z * transform[i][2][2];
    }
    
    // Loop over protein atoms
    for (int ip = 0; ip < natpro; ip++) {
      // Load protein atom data
      const Atom p_atom = protein_molecule[ip];
      const FFParams p_params = forcefield[p_atom.type];
      
      // Precalculate atom-specific parameters
      const float radij = p_params.radius + l_params.radius;
      const float r_radij = ONE / radij;
      
      const float elcdst = (p_params.hbtype == HBTYPE_F && l_params.hbtype == HBTYPE_F) ? FOUR : TWO;
      const float elcdst1 = (p_params.hbtype == HBTYPE_F && l_params.hbtype == HBTYPE_F) ? QUARTER : HALF;
      const bool type_E = ((p_params.hbtype == HBTYPE_E || l_params.hbtype == HBTYPE_E));
      
      const bool phphb_ltz = p_params.hphb < ZERO;
      const bool phphb_gtz = p_params.hphb > ZERO;
      const bool phphb_nz = p_params.hphb != ZERO;
      const float p_hphb = p_params.hphb * (phphb_ltz && lhphb_gtz ? -ONE : ONE);
      const float l_hphb = l_params.hphb * (phphb_gtz && lhphb_ltz ? -ONE : ONE);
      
      const float distdslv = (phphb_ltz ? (lhphb_ltz ? NPNPDIST : NPPDIST) : (lhphb_ltz ? NPPDIST : -FloatMax));
      const float r_distdslv = ONE / distdslv;
      
      const float chrg_init = l_params.elsc * p_params.elsc;
      const float dslv_init = p_hphb + l_hphb;
      
      // Calculate energy contribution for each pose in this work item
      for (int i = 0; i < PPWI; i++) {
        // Calculate distance between atoms
        const float dx = lpos[i][0] - p_atom.x;
        const float dy = lpos[i][1] - p_atom.y;
        const float dz = lpos[i][2] - p_atom.z;
        const float dist2 = dx*dx + dy*dy + dz*dz;
        const float dist = sqrtf(dist2);
        
        // Calculate steric energy
        const float distbb = dist - radij;
        const bool zone1 = (distbb < ZERO);
        etot[i] += (ONE - (dist * r_radij)) * (zone1 ? TWO * HARDNESS : ZERO);
        
        // Calculate formal and dipole charge interactions
        float chrg_e = chrg_init;
        chrg_e *= ((zone1 ? ONE : (ONE - distbb * elcdst1)) * (distbb < elcdst ? ONE : ZERO));
        const float neg_chrg_e = -fasten_fabsf(chrg_e);
        chrg_e = type_E ? neg_chrg_e : chrg_e;
        etot[i] += chrg_e * CNSTNT;
        
        // Calculate the two cases for Nonpolar-Polar repulsive interactions
        float dslv_e = dslv_init * ((distbb < distdslv && phphb_nz) ? ONE : ZERO);
        dslv_e *= (zone1 ? ONE : (ONE - distbb * r_distdslv));
        etot[i] += dslv_e;
      }
    }
  }
  
  // Store results for all poses in this work item
  const int td_base = blockIdx.x * blockDim.x * PPWI + threadIdx.x;
  for (int i = 0; i < PPWI; i++) {
    const int out_index = td_base + i * blockDim.x;
    if (out_index < numTransforms) {
      etotals[out_index] = etot[i] * HALF;
    }
  }
}

// Function to get time in milliseconds
double getTimeMs() {
    struct timeval tv;
    gettimeofday(&tv, NULL);
    return (tv.tv_sec * 1000.0 + tv.tv_usec / 1000.0);
}

// Function to get formatted time string
void getTimeString(char *buf, size_t len) {
    time_t now = time(NULL);
    struct tm *timeinfo = localtime(&now);
    strftime(buf, len, "%Y-%m-%d %H:%M:%S", timeinfo);
}

// int main(int argc, char **argv)
int main(void)
{
    // Default parameters
    int iterations = 1;
    int numThreads = 64;
    
    // // Parse command line arguments
    // for (int i = 1; i < argc; i++) {
    //     if (strcmp(argv[i], "--iter") == 0 && i+1 < argc) {
    //         iterations = atoi(argv[++i]);
    //     } else if (strcmp(argv[i], "--wgsize") == 0 && i+1 < argc) {
    //         numThreads = atoi(argv[++i]);
    //     } else if (strcmp(argv[i], "--help") == 0 || strcmp(argv[i], "-h") == 0) {
    //         printf("Usage: %s [options]\n", argv[0]);
    //         printf("Options:\n");
    //         printf("  --iter N        Number of iterations (default: 1)\n");
    //         printf("  --wgsize N      Work group size (default: 64)\n");
    //         printf("  --help, -h      Show this help message\n");
    //         return 0;
    //     }
    // }
    
    // Display header with time
    char timeStr[64];
    getTimeString(timeStr, sizeof(timeStr));
    printf("=== FASTEN CUDA Implementation ===\n");
    printf("Time: %s\n\n", timeStr);
    
    // Initialize with sample data
    int natpro = 5;
    int natlig = 3;
    int ntypes = 10;
    int nposes = 32;
    
    printf("Using sample data: %d ligands, %d proteins, %d forcefield types, %d poses\n", 
          natlig, natpro, ntypes, nposes);
    
    // Allocate host memory
    Atom *h_protein = (Atom*)malloc(natpro * sizeof(Atom));
    Atom *h_ligand = (Atom*)malloc(natlig * sizeof(Atom));
    FFParams *h_forcefield = (FFParams*)malloc(ntypes * sizeof(FFParams));
    float *h_transforms_0 = (float*)malloc(nposes * sizeof(float));
    float *h_transforms_1 = (float*)malloc(nposes * sizeof(float));
    float *h_transforms_2 = (float*)malloc(nposes * sizeof(float));
    float *h_transforms_3 = (float*)malloc(nposes * sizeof(float));
    float *h_transforms_4 = (float*)malloc(nposes * sizeof(float));
    float *h_transforms_5 = (float*)malloc(nposes * sizeof(float));
    float *h_results = (float*)malloc(nposes * sizeof(float));
    
    // Initialize protein array
    for (int i = 0; i < natpro; i++) {
        h_protein[i].x = i * 0.1f;
        h_protein[i].y = i * 0.2f;
        h_protein[i].z = i * 0.3f;
        h_protein[i].type = i % ntypes;
    }
    
    // Initialize ligand array
    for (int i = 0; i < natlig; i++) {
        h_ligand[i].x = i * 0.5f;
        h_ligand[i].y = i * 0.6f;
        h_ligand[i].z = i * 0.7f;
        h_ligand[i].type = i % ntypes;
    }
    
    // Initialize forcefield parameters
    for (int i = 0; i < ntypes; i++) {
        h_forcefield[i].hbtype = (i % 2 == 0) ? HBTYPE_F : HBTYPE_E;
        h_forcefield[i].radius = 1.5f + i * 0.1f;
        h_forcefield[i].hphb = (i % 2 == 0) ? -1.0f : 1.0f; 
        h_forcefield[i].elsc = 0.5f + i * 0.05f;
    }
    
    // Initialize transform data - using angles directly
    for (int i = 0; i < nposes; i++) {
        h_transforms_0[i] = 0.1f * i;  // Angle X
        h_transforms_1[i] = 0.2f * i;  // Angle Y
        h_transforms_2[i] = 0.3f * i;  // Angle Z
        h_transforms_3[i] = 10.0f + i * 0.1f;  // Translation X
        h_transforms_4[i] = 5.0f - i * 0.05f;  // Translation Y
        h_transforms_5[i] = -3.0f + i * 0.02f; // Translation Z
    }
    
    // Allocate device memory - WITHOUT error checking
    Atom *d_protein;
    Atom *d_ligand;
    FFParams *d_forcefield;
    float *d_transforms_0, *d_transforms_1, *d_transforms_2;
    float *d_transforms_3, *d_transforms_4, *d_transforms_5;
    float *d_results;
    
    cudaMalloc(&d_protein, natpro * sizeof(Atom));
    cudaMalloc(&d_ligand, natlig * sizeof(Atom));
    cudaMalloc(&d_forcefield, ntypes * sizeof(FFParams));
    cudaMalloc(&d_transforms_0, nposes * sizeof(float));
    cudaMalloc(&d_transforms_1, nposes * sizeof(float));
    cudaMalloc(&d_transforms_2, nposes * sizeof(float));
    cudaMalloc(&d_transforms_3, nposes * sizeof(float));
    cudaMalloc(&d_transforms_4, nposes * sizeof(float));
    cudaMalloc(&d_transforms_5, nposes * sizeof(float));
    cudaMalloc(&d_results, nposes * sizeof(float));
    cudaMalloc(&d_forcefield, ntypes * sizeof(FFParams));
    cudaMemcpy(d_forcefield, h_forcefield, ntypes * sizeof(FFParams), cudaMemcpyHostToDevice);

    // Copy host memory to device - WITHOUT error checking
    cudaMemcpy(d_protein, h_protein, natpro * sizeof(Atom), cudaMemcpyHostToDevice);
    cudaMemcpy(d_ligand, h_ligand, natlig * sizeof(Atom), cudaMemcpyHostToDevice);
    cudaMemcpy(d_forcefield, h_forcefield, ntypes * sizeof(FFParams), cudaMemcpyHostToDevice);
    cudaMemcpy(d_transforms_0, h_transforms_0, nposes * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_transforms_1, h_transforms_1, nposes * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_transforms_2, h_transforms_2, nposes * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_transforms_3, h_transforms_3, nposes * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_transforms_4, h_transforms_4, nposes * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_transforms_5, h_transforms_5, nposes * sizeof(float), cudaMemcpyHostToDevice);
    
    // Calculate grid and block dimensions
    int threadsPerBlock = numThreads;
    int blocksPerGrid = (nposes + threadsPerBlock * PPWI - 1) / (threadsPerBlock * PPWI);
    
    printf("\nRunning FASTEN kernel with %d blocks of %d threads for %d poses\n", 
           blocksPerGrid, threadsPerBlock, nposes);
    printf("Settings: %d iterations, PPWI=%d\n", iterations, PPWI);
    
    // Start timing
    double startTime = getTimeMs();
    
    // Calculate shared memory size for forcefield parameters
    size_t sharedMemSize = ntypes * sizeof(FFParams);
    
    // Run for multiple iterations if specified
    for (int iter = 0; iter < iterations; iter++) {
        // Execute kernel with multiple threads/blocks and shared memory
        fasten_kernel<<<blocksPerGrid, threadsPerBlock, sharedMemSize>>>(
            natlig, natpro, d_protein, d_ligand,
            d_transforms_0, d_transforms_1, d_transforms_2,
            d_transforms_3, d_transforms_4, d_transforms_5,
            d_results, d_forcefield, nposes, ntypes
        );
        
        // Simple synchronization - without error checking
        cudaDeviceSynchronize();
    }
    
    // End timing
    double endTime = getTimeMs();
    double totalTime = endTime - startTime;
    double timePerIteration = totalTime / iterations;
    
    // Copy device memory to host - WITHOUT error checking
    cudaMemcpy(h_results, d_results, nposes * sizeof(float), cudaMemcpyDeviceToHost);
    
    // Calculate statistics
    float minEnergy = h_results[0];
    float maxEnergy = h_results[0];
    float avgEnergy = 0.0f;
    
    for (int i = 0; i < nposes; i++) {
        if (h_results[i] < minEnergy) minEnergy = h_results[i];
        if (h_results[i] > maxEnergy) maxEnergy = h_results[i];
        avgEnergy += h_results[i];
    }
    avgEnergy /= nposes;
    
    // // Print timing and performance information
    // printf("\nPerformance Results:\n");
    // printf("  Total Time: %.3f ms\n", totalTime);
    // printf("  Time per Iteration: %.3f ms\n", timePerIteration);
    // printf("  Poses Processed: %d\n", nposes * iterations);
    // printf("  Processing Rate: %.2f poses/ms (%.2f poses/second)\n",
    //        (nposes * iterations) / totalTime,
    //        (nposes * iterations) / totalTime * 1000.0);
    
    // // Print energy statistics
    // printf("\nEnergy Statistics:\n");
    // printf("  Min Energy: %.4f\n", minEnergy);
    // printf("  Max Energy: %.4f\n", maxEnergy);
    // printf("  Avg Energy: %.4f\n", avgEnergy);
    
    // // Print sample energy values
    // printf("\nEnergy results (showing %d):\n", nposes < 10 ? nposes : 10);
    // for (int i = 0; i < nposes && i < 10; i++) {
    //     printf("  Pose %d: %.4f\n", i, h_results[i]);
    // }
    
    // Free memory
    free(h_protein);
    free(h_ligand);
    free(h_forcefield);
    free(h_transforms_0);
    free(h_transforms_1);
    free(h_transforms_2);
    free(h_transforms_3);
    free(h_transforms_4);
    free(h_transforms_5);
    free(h_results);
    
    cudaFree(d_protein);
    cudaFree(d_ligand);
    cudaFree(d_forcefield);
    cudaFree(d_transforms_0);
    cudaFree(d_transforms_1);
    cudaFree(d_transforms_2);
    cudaFree(d_transforms_3);
    cudaFree(d_transforms_4);
    cudaFree(d_transforms_5);
    cudaFree(d_results);
    
    return 0;
}
