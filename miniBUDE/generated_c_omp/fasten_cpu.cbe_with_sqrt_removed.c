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

static __forceinline int llvm_fcmp_olt(double X, double Y) { return X <  Y; }


/* Global Declarations */

/* Types Declarations */
struct l_struct_struct_OC_timeval;
struct l_struct_struct_OC_tm;
struct l_struct_struct_OC_Atom;
struct l_struct_struct_OC_FFParams;
struct l_struct_struct_OC_dim3;
struct l_unnamed_1;

/* Function definitions */

/* Types Definitions */
struct l_struct_struct_OC_timeval {
  uint64_t field0;
  uint64_t field1;
};
struct l_struct_struct_OC_tm {
  uint32_t field0;
  uint32_t field1;
  uint32_t field2;
  uint32_t field3;
  uint32_t field4;
  uint32_t field5;
  uint32_t field6;
  uint32_t field7;
  uint32_t field8;
  uint64_t field9;
  uint8_t* field10;
};
struct l_struct_struct_OC_Atom {
  float field0;
  float field1;
  float field2;
  uint32_t field3;
};
struct l_struct_struct_OC_FFParams {
  uint32_t field0;
  float field1;
  float field2;
  float field3;
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
double _Z9getTimeMsv(void) __ATTRIBUTELIST__((noinline, nothrow));
uint32_t gettimeofday(struct l_struct_struct_OC_timeval*, uint8_t*) __ATTRIBUTELIST__((nothrow));
void _Z13getTimeStringPcm(uint8_t*, uint64_t) __ATTRIBUTELIST__((noinline, nothrow));
uint64_t time(uint64_t*) __ATTRIBUTELIST__((nothrow));
struct l_struct_struct_OC_tm* localtime(uint64_t*) __ATTRIBUTELIST__((nothrow));
uint64_t strftime(uint8_t*, uint64_t, uint8_t*, struct l_struct_struct_OC_tm*) __ATTRIBUTELIST__((nothrow));
int main(void) __ATTRIBUTELIST__((noinline));
uint32_t cudaMemcpy(uint8_t*, uint8_t*, uint64_t, uint32_t);
uint32_t cudaConfigureCall(uint64_t, uint32_t, uint64_t, uint32_t, uint64_t, void*);
uint32_t cudaDeviceSynchronize(void);
uint32_t cudaFree(uint8_t*);
uint32_t cudaMalloc(uint8_t**, uint64_t);
//float sqrt(float);
void _Z13fasten_kerneliiPK4AtomS1_PKfS3_S3_S3_S3_S3_PfPK8FFParamsii_OC_1(uint32_t, uint32_t, struct l_struct_struct_OC_Atom*, struct l_struct_struct_OC_Atom*, float*, float*, float*, float*, float*, float*, float*, struct l_struct_struct_OC_FFParams*, uint32_t, uint32_t, uint32_t, uint32_t, uint32_t, uint32_t, uint32_t, uint32_t, uint32_t, uint32_t, uint32_t, uint32_t, uint32_t, uint32_t) __ATTRIBUTELIST__((noinline, nothrow));


/* Global Variable Definitions and Initialization */
uint8_t _OC_str[18] = { "%Y-%m-%d %H:%M:%S" };
uint8_t _OC_str_OC_1[36] = { "=== FASTEN CUDA Implementation ===\n" };
uint8_t _OC_str_OC_2[11] = { "Time: %s\n\n" };
uint8_t _OC_str_OC_3[75] = { "Using sample data: %d ligands, %d proteins, %d forcefield types, %d poses\n" };
uint8_t _OC_str_OC_4[66] = { "\nRunning FASTEN kernel with %d blocks of %d threads for %d poses\n" };
uint8_t _OC_str_OC_5[34] = { "Settings: %d iterations, PPWI=%d\n" };


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
static __forceinline float llvm_fsub_f32(float a, float b) {
  float r = a - b;
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
static __forceinline float llvm_fdiv_f32(float a, float b) {
  float r = a / b;
  return r;
}
static __forceinline uint32_t llvm_urem_u32(uint32_t a, uint32_t b) {
  uint32_t r = a % b;
  return r;
}


/* Function Bodies */

double _Z9getTimeMsv(void) {
  struct l_struct_struct_OC_timeval tv;    /* Address-exposed local */
  int32_t call;

  gettimeofday((&tv), ((uint8_t*)0));
  return (((double)(tv.field0) * 1000) + ((double)(tv.field1) / 1000));
}


void _Z13getTimeStringPcm(uint8_t* buf, uint64_t len) {
  uint64_t now;    /* Address-exposed local */
  int64_t call;
  struct l_struct_struct_OC_tm* call1;
  int64_t call2;

  call = time(((uint64_t*)0));
  now = call;
  call1 = localtime((&now));
  strftime(buf, len, (_OC_str), call1);
}


int main(void) {
  uint8_t timeStr[64];    /* Address-exposed local */
  struct l_struct_struct_OC_dim3 agg_2e_tmp;    /* Address-exposed local */
  struct l_struct_struct_OC_dim3 agg_2e_tmp203;    /* Address-exposed local */
  struct l_unnamed_1 agg_2e_tmp_2e_coerce;    /* Address-exposed local */
  struct l_unnamed_1 agg_2e_tmp203_2e_coerce;    /* Address-exposed local */
  int32_t call;
  int32_t call2;
  int32_t call3;
  uint8_t* call4;
  uint8_t* call7;
  uint8_t* call10;
  uint8_t* call13;
  uint8_t* call16;
  uint8_t* call19;
  uint8_t* call22;
  uint8_t* call25;
  uint8_t* call28;
  uint8_t* call31;
  int64_t i;
  int32_t call163;
  uint32_t div;
  int32_t call195;
  int32_t call196;
  double call197;
  uint32_t j;
  uint32_t k;
  double call209;
  int32_t call215;
  float avgEnergy_2e_0;

_Z13getTimeStringPcm(timeStr, 64);
  printf((_OC_str_OC_1));
  printf((_OC_str_OC_2), timeStr);
  printf((_OC_str_OC_3), 3, 5, 10, 32);
  call4 = malloc(5 * 16);
  call7 = malloc(3 * 16);
  call10 = malloc(10 * 16);
  call13 = malloc(32 * 4);
  call16 = malloc(32 * 4);
  call19 = malloc(32 * 4);
  call22 = malloc(32 * 4);
  call25 = malloc(32 * 4);
  call28 = malloc(32 * 4);
  call31 = malloc(32 * 4);

for(int64_t i = 0; i < 5;   i = i + 1){
  (((struct l_struct_struct_OC_Atom*)call4)+i)->field0 = (float)(i) * 0.100000001;
  (((struct l_struct_struct_OC_Atom*)call4)+i)->field1 = (float)(i) * 0.200000003;
  (((struct l_struct_struct_OC_Atom*)call4)+i)->field2 = (float)(i) * 0.300000012;
  (((struct l_struct_struct_OC_Atom*)call4)+i)->field3 = i;
}

for(int64_t i = 0; i < 3;   i = i + 1){
  (((struct l_struct_struct_OC_Atom*)call7)+i)->field0 = (float)(i) * 0.5;
  (((struct l_struct_struct_OC_Atom*)call7)+i)->field1 = (float)(i) * 0.600000024;
  (((struct l_struct_struct_OC_Atom*)call7)+i)->field2 = (float)(i) * 0.699999988;
  (((struct l_struct_struct_OC_Atom*)call7)+i)->field3 = i;
}

for(int64_t i = 0; i < 10;   i = i + 1){
  (((struct l_struct_struct_OC_FFParams*)call10)+i)->field0 = (i % 2 == 0 ? 70 : 69);
  (((struct l_struct_struct_OC_FFParams*)call10)+i)->field1 = 1.5 + (float)(i) * 0.100000001;
  (((struct l_struct_struct_OC_FFParams*)call10)+i)->field2 = (i % 2 == 0 ? -1 : 1);
  (((struct l_struct_struct_OC_FFParams*)call10)+i)->field3 = 0.5 + (float)(i) * 0.0500000007;
}

for(int64_t i = 0; i < 32;   i = i + 1){
  ((float*)call13)[i] = 0.100000001 * (float)(i);
  ((float*)call16)[i] = 0.200000003 * (float)(i);
  ((float*)call19)[i] = 0.300000012 * (float)(i);
  ((float*)call22)[i] = 10 + (float)(i) * 0.100000001;
  ((float*)call25)[i] = (5 - (float)(i) * 0.0500000007);
  ((float*)call28)[i] = -3 + (float)(i) * 0.0199999996;
}
  div = ((32 + 64 * 64) - 1) / 64 * 64;
  printf((_OC_str_OC_4), div, 64, 32);
  printf((_OC_str_OC_5), 1, 64);
  _Z9getTimeMsv();

for(int32_t i = 0; i < 1;   i = i + 1){
  agg_2e_tmp.field0 = div;
  agg_2e_tmp.field1 = 1;
  agg_2e_tmp.field2 = 1;
  agg_2e_tmp203.field0 = 64;
  agg_2e_tmp203.field1 = 1;
  agg_2e_tmp203.field2 = 1;
  memcpy(((uint8_t*)(&agg_2e_tmp_2e_coerce)), ((uint8_t*)(&agg_2e_tmp)), 12);
  memcpy(((uint8_t*)(&agg_2e_tmp203_2e_coerce)), ((uint8_t*)(&agg_2e_tmp203)), 12);
#pragma omp parallel for collapse(2)
for(int32_t j = 0; j < div;   j = j + 1){

for(int32_t k = 0; k < 64;   k = k + 1){
_Z13fasten_kerneliiPK4AtomS1_PKfS3_S3_S3_S3_S3_PfPK8FFParamsii_OC_1(3, 5, ((struct l_struct_struct_OC_Atom*)call4), ((struct l_struct_struct_OC_Atom*)call7), ((float*)call13), ((float*)call16), ((float*)call19), ((float*)call22), ((float*)call25), ((float*)call28), ((float*)call31), ((struct l_struct_struct_OC_FFParams*)call10), 32, 10, div, 1, 1, 64, 1, 1, j, 0, 0, k, 0, 0);
}
}
}
  _Z9getTimeMsv();
  float minEnergy_2e_0 = ((float*)call31)[0];
  float maxEnergy_2e_0 = ((float*)call31)[0];
  avgEnergy_2e_0 = 0;

for(int64_t i = 0; i < 32;   i = i + 1){
  if (llvm_fcmp_olt(((float*)call31)[i], minEnergy_2e_0)) {
  minEnergy_2e_0 = ((float*)call31)[i];
  }
}
free(((uint8_t*)((struct l_struct_struct_OC_Atom*)call4)));
free(((uint8_t*)((struct l_struct_struct_OC_Atom*)call7)));
free(((uint8_t*)((struct l_struct_struct_OC_FFParams*)call10)));
free(((uint8_t*)((float*)call13)));
free(((uint8_t*)((float*)call16)));
free(((uint8_t*)((float*)call19)));
free(((uint8_t*)((float*)call22)));
free(((uint8_t*)((float*)call25)));
free(((uint8_t*)((float*)call28)));
free(((uint8_t*)((float*)call31)));
  return 0;
}


void _Z13fasten_kerneliiPK4AtomS1_PKfS3_S3_S3_S3_S3_PfPK8FFParamsii_OC_1(uint32_t natlig, uint32_t natpro, struct l_struct_struct_OC_Atom* protein_molecule, struct l_struct_struct_OC_Atom* ligand_molecule, float* transforms_0, float* transforms_1, float* transforms_2, float* transforms_3, float* transforms_4, float* transforms_5, float* etotals, struct l_struct_struct_OC_FFParams* forcefield, uint32_t numTransforms, uint32_t ntypes, uint32_t gridDim_2e_x, uint32_t gridDim_2e_y, uint32_t gridDim_2e_z, uint32_t blockDim_2e_x, uint32_t blockDim_2e_y, uint32_t blockDim_2e_z, uint32_t blockIdx_2e_x, uint32_t blockIdx_2e_y, uint32_t blockIdx_2e_z, uint32_t threadIdx_2e_x, uint32_t threadIdx_2e_y, uint32_t threadIdx_2e_z) {
  float transform[64][3][4];    /* Address-exposed local */
  float etot[64];    /* Address-exposed local */
  struct l_struct_struct_OC_Atom l_atom;    /* Address-exposed local */
  struct l_struct_struct_OC_FFParams l_params;    /* Address-exposed local */
  float lpos[64][3];    /* Address-exposed local */
  struct l_struct_struct_OC_Atom p_atom;    /* Address-exposed local */
  struct l_struct_struct_OC_FFParams p_params;    /* Address-exposed local */
  int64_t cond;
  int64_t i;
  int64_t j;
  bool _1;
  bool _2;
  bool _3;
  bool _4;
  bool _5;
  float cond234;
  int64_t k;
  float cond281;
  float cond_2e_i;
  float cond292;
  bool _6;
  float cond309;
  uint32_t add328;

  cond = blockIdx_2e_x * blockDim_2e_x * 64 + threadIdx_2e_x;
  if (cond < numTransforms) {
  }
  cond = (numTransforms - 64);

for(int64_t i = 0; i < 64;   i = i + 1){
  uint64_t add9 = cond + i * blockDim_2e_x;
  if (((uint64_t)add9) >= numTransforms) {
  } else {
  transform[i][0][0] = transforms_0[add9];
  transform[i][0][1] = transforms_1[add9];
  transform[i][0][2] = transforms_2[add9];
  transform[i][0][3] = transforms_3[add9];
  transform[i][1][0] = transforms_0[add9];
  transform[i][1][1] = transforms_1[add9];
  transform[i][1][2] = transforms_2[add9];
  transform[i][1][3] = transforms_4[add9];
  transform[i][2][0] = transforms_0[add9];
  transform[i][2][1] = transforms_1[add9];
  transform[i][2][2] = transforms_2[add9];
  transform[i][2][3] = transforms_5[add9];
  }
}

for(int64_t i = 0; i < 64;   i = i + 1){
  etot[i] = 0;
}

for(int64_t i = 0; i < natlig;   i = i + 1){
  memcpy(((uint8_t*)(&l_atom)), ((uint8_t*)(ligand_molecule+i)), 16);
  memcpy(((uint8_t*)(&l_params)), ((uint8_t*)(forcefield+l_atom.field3)), 16);

for(int64_t j = 0; j < 64;   j = j + 1){
  lpos[j][0] = transform[j][0][3] + l_atom.field0 * transform[j][0][0] + l_atom.field1 * transform[j][0][1] + l_atom.field2 * transform[j][0][2];
  lpos[j][1] = transform[j][1][3] + l_atom.field0 * transform[j][1][0] + l_atom.field1 * transform[j][1][1] + l_atom.field2 * transform[j][1][2];
  lpos[j][2] = transform[j][2][3] + l_atom.field0 * transform[j][2][0] + l_atom.field1 * transform[j][2][1] + l_atom.field2 * transform[j][2][2];
}

for(int64_t j = 0; j < natpro;   j = j + 1){
  uint8_t* _7 = memcpy(((uint8_t*)(&p_atom)), ((uint8_t*)(protein_molecule+j)), 16);
  uint8_t* _8 = memcpy(((uint8_t*)(&p_params)), ((uint8_t*)(forcefield+p_atom.field3)), 16);
  float add187 = p_params.field1 + l_params.field1;
  float div = (1 / add187);
  if (p_params.field0 == 70) {
  }
}
}
  add328 = blockIdx_2e_x * blockDim_2e_x * 64 + threadIdx_2e_x;

for(int64_t i = 0; i < 64;   i = i + 1){
  uint32_t add335 = add328 + i * blockDim_2e_x;
  if (add335 < numTransforms) {
  etotals[add335] = etot[i] * 0.5;
  }
}
  return;
}

