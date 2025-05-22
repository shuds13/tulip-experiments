# fasten kernel

## Requirements

Tulip variant of LLVM, CudaFE, Splendid, 

`libLLVMCudaFE.so` is created from CudaFE.

For the versions of these packages see [toolchain.md](toolchain.md).

The runs were performed on Argonne GCE node compute-386-08. This node has 2 x 12-core Intel Xeon Gold 5317 (Ice Lake) CPU @ 3.00GHz (total of 24 cores or 48 logical cores). and one NVIDIA A30 GPU.

## Running the tool-chain

```
clang -Xclang -disable-O0-optnone -std=c++17 -S -emit-llvm -g fasten.cu

llvm-link-cudafe fasten-cuda-nvptx64-nvidia-cuda-sm_20.ll fasten.ll -o fasten_linked.bc

opt -load libLLVMCudaFE.so -merge-kernel -mem2reg -indvars -dce fasten_linked.bc -o fasten_cpu.bc

/home/shudson/xcellent/llvm-install-debug/bin/splendid fasten_cpu.bc

clang -fopenmp -O3 fasten_cpu.cbe.c -o tulip.clang.fasten.exe

```

Also see [go.sh](go.sh).

## Viewing output

Small error logs referred to here can be found in the [errors](errors/) directory. Some larger error outputs are in the [tulip_data_files](https://github.com/shuds13/tulip_data_files) repository.

## Files

### fasten.cu

Converted c++ to C, including removal of templates.

Removed sin/cos functions as these cause failure in LLVM kernel merger (opt -load ...) - see [errors/sin_cos_err.txt](errors/sin_cos_err.txt).

This passes the kernel merge, but fails in the Splendid decompiler. The crash occurs in `llvm_cbe::IfElseRegion::createSubIfElseRegions` when trying to analyze control flow structures, trying to process a value without a name. See [errors/splendid_err1.txt](errors/splendid_err1.txt).

Some further fixes for `splendid`:

Cannot handle multi‐variable, conditional update inside a single loop.
- commented out the loop handling inputs and used hardcoded values for now as this code is not CUDA/OpenMP specific.

```
    // Parse command line arguments
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "--iter") == 0 && i+1 < argc) {
            iterations = atoi(argv[++i]);
        } else if (strcmp(argv[i], "--wgsize") == 0 && i+1 < argc) {
            numThreads = atoi(argv[++i]);
        } else if (strcmp(argv[i], "--help") == 0 || strcmp(argv[i], "-h") == 0) {
            printf("Usage: %s [options]\n", argv[0]);
            printf("Options:\n");
            printf("  --iter N        Number of iterations (default: 1)\n");
            printf("  --wgsize N      Work group size (default: 64)\n");
            printf("  --help, -h      Show this help message\n");
            return 0;
        }
    }
```

Other issues with I/O - reading files and printing the energies.
Commented out and used hardcode values - not CUDA/OpenMP specific.

Needed to add  `-strip-debug` to remove debugging tags in the opt stage.

`opt -load libLLVMCudaFE.so -merge-kernel -mem2reg -indvars -dce -strip-debug fasten_linked.bc -o fasten_cpu.bc > cudafe_debug.txt 2>&1`

```
CBackend: varname: argv
  call void @llvm.dbg.value(metadata i8** %argv, metadata …), !dbg …
splendid: … Assertion `0 && "SUSAN: 1st argument is not a Value?\n"' failed.
```
Cannot handle `fabsf` function  in device code
  `LLVM ERROR: Code generator does not support intrinsic function 'llvm.nvvm.fabs.f'!`
Substituted with my own fabs function for device.

Cannot handle device constants 
e.g. in cuda kernel.
 - `const FFParams* forcefield = global_forcefield`

```
CWriter Error: Unhandled constant expression: [0 x %struct.FFParams]* addrspacecast …  
unhandled constant expression in:   %arrayidx9 = getelementptr inbounds [0 x %struct.FFParams], …  
UNREACHABLE executed at … CBackend.cpp:10795!
```
Removed device constants - just used regular variables.

Sucessfully generated C/OMP code with these adjustments:

Compiling generated code:

```
fasten_cpu.cbe.c:97:7: error: conflicting types for 'sqrt'
float sqrt(float);
```

The generated C has math
#include <math.h>

which contains 
double sqrt(double);

and declares
float sqrt(float);

For the sake of testing the output, I commented out the sqrt declaration. Code then compiles.

See [generated code](generated_c_omp/fasten_cpu.cbe_with_sqrt_removed.c).

## Old versions




### fasten_simple_1.cu

Very simplified example that makes it through the full tool chain and produces output.

***Old***: 
 - Simplified logic passes splendid step but fails in the linker when try to compile the generated file `undefined reference to 'cudaMalloc'` suggesting that CUDA calls were not substitued properly.
  - See [errors/linker_error1.txt](errors/linker_error1.txt).
  - The `cudaMalloc`s were not getting tagged by Splendid (should have `!tulip.target.mapdata`).
 - Fixed by removing void declarations.




