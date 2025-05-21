/* Provide Declarations */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#ifndef __cplusplus
typedef unsigned char bool;
#endif

#ifndef _MSC_VER
#define __forceinline __attribute__((always_inline)) inline
#endif

#if defined(__GNUC__)
#define  __ATTRIBUTELIST__(x) __attribute__(x)
#else
#define  __ATTRIBUTELIST__(x)  
#endif

#ifdef _MSC_VER  /* Can only support "linkonce" vars with GCC */
#define __attribute__(X)
#endif



/* Global Declarations */

/* Types Declarations */
struct l_struct_struct_OC__IO_FILE;
struct l_struct_struct_OC_dim3;
struct l_unnamed_1;

/* Function definitions */

/* Types Definitions */
struct l_array_1_uint8_t {
  uint8_t array[1];
};
struct l_array_20_uint8_t {
  uint8_t array[20];
};
struct l_struct_struct_OC__IO_FILE {
  uint32_t field0;
  uint8_t* field1;
  uint8_t* field2;
  uint8_t* field3;
  uint8_t* field4;
  uint8_t* field5;
  uint8_t* field6;
  uint8_t* field7;
  uint8_t* field8;
  uint8_t* field9;
  uint8_t* field10;
  uint8_t* field11;
  void* field12;
  struct l_struct_struct_OC__IO_FILE* field13;
  uint32_t field14;
  uint32_t field15;
  uint64_t field16;
  uint16_t field17;
  uint8_t field18;
  uint8_t field19[1];
  uint8_t* field20;
  uint64_t field21;
  void* field22;
  void* field23;
  struct l_struct_struct_OC__IO_FILE* field24;
  uint8_t* field25;
  uint64_t field26;
  uint32_t field27;
  uint8_t field28[20];
};
struct l_struct_struct_OC_dim3 {
  uint32_t field0;
  uint32_t field1;
  uint32_t field2;
};
struct l_unnamed_1 {
  uint64_t field0;
  uint32_t field1;
};

/* External Global Variable Declarations */

/* Function Declarations */
uint32_t cudaSetupArgument(uint8_t*, uint64_t, uint64_t);
uint32_t cudaLaunch(uint8_t*);
int main(int, char **) __ATTRIBUTELIST__((noinline));
uint32_t cudaMemcpy(uint8_t*, uint8_t*, uint64_t, uint32_t);
uint32_t _ZL10num_blocksii(uint32_t, uint32_t) __ATTRIBUTELIST__((noinline, nothrow));
uint32_t cudaConfigureCall(uint64_t, uint32_t, uint64_t, uint32_t, uint64_t, void*);
uint32_t cudaDeviceSynchronize(void);
uint32_t cudaFree(uint8_t*);
uint32_t cudaMalloc(uint8_t**, uint64_t);
void _Z10vector_addPfS_S_i_OC_1(float*, float*, float*, uint32_t, uint32_t, uint32_t, uint32_t, uint32_t, uint32_t, uint32_t, uint32_t, uint32_t, uint32_t, uint32_t, uint32_t, uint32_t) __ATTRIBUTELIST__((noinline, nothrow));


/* Global Variable Definitions and Initialization */
uint8_t _OC_str[13] = { "Usage: %s N\n" };
uint8_t _OC_str_OC_1[20] = { "Host malloc failed\n" };
uint8_t _OC_str_OC_2[20] = { "%.1f + %.1f = %.1f\n" };


/* LLVM Intrinsic Builtin Function Bodies */
static __forceinline uint32_t llvm_add_u32(uint32_t a, uint32_t b) {
  uint32_t r = a + b;
  return r;
}
static __forceinline uint64_t llvm_add_u64(uint64_t a, uint64_t b) {
  uint64_t r = a + b;
  return r;
}
static __forceinline float llvm_fadd_f32(float a, float b) {
  float r = a + b;
  return r;
}
static __forceinline uint32_t llvm_sub_u32(uint32_t a, uint32_t b) {
  uint32_t r = a - b;
  return r;
}
static __forceinline uint32_t llvm_mul_u32(uint32_t a, uint32_t b) {
  uint32_t r = a * b;
  return r;
}
static __forceinline uint64_t llvm_mul_u64(uint64_t a, uint64_t b) {
  uint64_t r = a * b;
  return r;
}
static __forceinline float llvm_fmul_f32(float a, float b) {
  float r = a * b;
  return r;
}
static __forceinline uint32_t llvm_sdiv_u32(int32_t a, int32_t b) {
  uint32_t r = a / b;
  return r;
}


/* Function Bodies */

int main(int argc, char ** argv) {
  struct l_struct_struct_OC_dim3 agg_2e_tmp;    /* Address-exposed local */
  struct l_struct_struct_OC_dim3 agg_2e_tmp39;    /* Address-exposed local */
  struct l_unnamed_1 agg_2e_tmp_2e_coerce;    /* Address-exposed local */
  struct l_unnamed_1 agg_2e_tmp39_2e_coerce;    /* Address-exposed local */
  int32_t call;
  int32_t N;
  uint8_t* h_a;
  uint8_t* h_b;
  uint8_t* h_c;
  int32_t call14;
  int64_t i;
  int32_t call34;
  int32_t blocksNeeded;
  uint8_t* _1;
  uint8_t* _2;
  uint32_t j;
  int32_t call45;
  uint32_t retval_2e_0;

  if (argc < 2) {
  fprintf(stderr, (_OC_str), argv[0]);
  retval_2e_0 = 1;
  } else {
  N = atoi(argv[1]);
  h_a = malloc(N * 4);
  h_b = malloc(N * 4);
  h_c = malloc(N * 4);
  if (((float*)h_a) != ((float*)0)) {
  if (((float*)h_b) != ((float*)0)) {
  if (((float*)h_c) != ((float*)0)) {

for(int64_t i = 0; i < N;   i = i + 1){
  ((float*)h_a)[i] = (float)(i);
  ((float*)h_b)[i] = (float)(i) * 2;
}
  blocksNeeded = _ZL10num_blocksii(N, 256);
  agg_2e_tmp.field0 = blocksNeeded;
  agg_2e_tmp.field1 = 1;
  agg_2e_tmp.field2 = 1;
  agg_2e_tmp39.field0 = 256;
  agg_2e_tmp39.field1 = 1;
  agg_2e_tmp39.field2 = 1;
  memcpy(((uint8_t*)(&agg_2e_tmp_2e_coerce)), ((uint8_t*)(&agg_2e_tmp)), 12);
  memcpy(((uint8_t*)(&agg_2e_tmp39_2e_coerce)), ((uint8_t*)(&agg_2e_tmp39)), 12);
#pragma omp parallel for collapse(2)
for(int32_t i = 0; i < blocksNeeded;   i = i + 1){

for(int32_t j = 0; j < 256;   j = j + 1){
_Z10vector_addPfS_S_i_OC_1(((float*)h_a), ((float*)h_b), ((float*)h_c), N, blocksNeeded, 1, 1, 256, 1, 1, i, 0, 0, j, 0, 0);
}
}

for(int64_t i = 0; i < N;   i = i + 1){
  printf((_OC_str_OC_2), ((double)((float*)h_a)[i]), ((double)((float*)h_b)[i]), ((double)((float*)h_c)[i]));
}
free(((uint8_t*)((float*)h_a)));
free(((uint8_t*)((float*)h_b)));
free(((uint8_t*)((float*)h_c)));
  retval_2e_0 = 0;
  } else {
  fprintf(stderr, (_OC_str_OC_1));
  retval_2e_0 = 1;
  }
  } else {
  fprintf(stderr, (_OC_str_OC_1));
  retval_2e_0 = 1;
  }
  } else {
  fprintf(stderr, (_OC_str_OC_1));
  retval_2e_0 = 1;
  }
  }
  return retval_2e_0;
}


uint32_t _ZL10num_blocksii(uint32_t num, uint32_t factor) {
  return ((num + factor) - 1) / factor;
}


void _Z10vector_addPfS_S_i_OC_1(float* a, float* b, float* c, uint32_t n, uint32_t gridDim_2e_x, uint32_t gridDim_2e_y, uint32_t gridDim_2e_z, uint32_t blockDim_2e_x, uint32_t blockDim_2e_y, uint32_t blockDim_2e_z, uint32_t blockIdx_2e_x, uint32_t blockIdx_2e_y, uint32_t blockIdx_2e_z, uint32_t threadIdx_2e_x, uint32_t threadIdx_2e_y, uint32_t threadIdx_2e_z) {
  int64_t i;

  i = blockDim_2e_x * blockIdx_2e_x + threadIdx_2e_x;
  if (i < n) {
  c[i] = a[i] + b[i];
  }
  return;
}

