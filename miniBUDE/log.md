# fasten kernel

## Requirements

Tulip variant of LLVM, CudaFE, Splendid, 

libLLVMCudaFE.so is created from CudaFE.

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

Also see [go.sh].

## Viewing output

Small error logs referred to here can be found in the [errors](errors/) directory. Some larger error outputs are in the [tulip_data_files](https://github.com/shuds13/tulip_data_files) repository.

## Files

### fasten.cu

Converted c++ to C, including removal of templates.

Removed sin/cos functions as these cause failure in LLVM kernel merger (opt -load ...) - see [errors/sin_cos_err.txt](errors/sin_cos_err.txt).

This passes the kernel merge, but fails in the Splendid decompiler. The crash occurs in `llvm_cbe::IfElseRegion::createSubIfElseRegions` when trying to analyze control flow structures, trying to process a value without a name. See [errors/splendid_err1.txt](errors/splendid_err1.txt).

### fasten_simple_1.cu:

Very simplified example that makes it through the full tool chain and produces output.

***Old***: 
 - Simplified logic passes splendid step but fails in the linker when try to compile the generated file `undefined reference to `cudaMalloc'` suggesting that CUDA calls were not substitued properly.
  - See [errors/linker_error1.txt](errors/linker_error1.txt).
  - the cudaMallocs were not tagged by Splendid with `!tulip.target.mapdata` as they are for xstack examples.
 - fixed by removing void declarations.




