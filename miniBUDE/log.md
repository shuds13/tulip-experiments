# fasten kernel

## Requirements

Tulip variant of LLVM, CudaFE, Splendid, 

libLLVMCudaFE.so is created from CudaFE.

For versions see `toolchain.md`

The runs were performed on Argonne GCE node compute-386-08. This node has 2 x 12-core Intel Xeon Gold 5317 (Ice Lake) CPU @ 3.00GHz (total of 24 cores or 48 logical cores). and one NVIDIA A30 GPU.

## Running the tool-chain

clang -Xclang -disable-O0-optnone -std=c++17 -S -emit-llvm -g fasten.cu

llvm-link-cudafe fasten-cuda-nvptx64-nvidia-cuda-sm_20.ll fasten.ll -o fasten_linked.bc

opt -load libLLVMCudaFE.so -merge-kernel -mem2reg -indvars -dce fasten_linked.bc -o fasten_cpu.bc

/home/shudson/xcellent/llvm-install-debug/bin/splendid fasten_cpu.bc

clang -fopenmp -O3 fasten_cpu.cbe.c -o tulip.clang.fasten.exe
