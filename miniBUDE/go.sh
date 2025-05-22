#!/bin/bash

echo -e "\nPHASE 1: Compiling CUDA source to LLVM IR"
clang -Xclang -disable-O0-optnone -std=c++17 -S -emit-llvm -g fasten.cu

echo -e "\nPHASE 2: Linking CUDA device and host code"
llvm-link-cudafe fasten-cuda-nvptx64-nvidia-cuda-sm_20.ll fasten.ll -o fasten_linked.bc

echo -e "\nPHASE 3: Optimizing linked bytecode"
# opt -load libLLVMCudaFE.so -merge-kernel -mem2reg -indvars -dce fasten_linked.bc -o fasten_cpu.bc > cudafe_debug.txt 2>&1
opt -load libLLVMCudaFE.so -merge-kernel -mem2reg -indvars -dce -strip-debug  fasten_linked.bc -o fasten_cpu.bc > cudafe_debug.txt 2>&1

echo -e "\nPHASE 4: Running splendid decompiler on optimized bytecode"
/home/shudson/xcellent/llvm-install-debug/bin/splendid fasten_cpu.bc > splendid_debug.txt 2>&1

echo -e "\nPHASE 5: Compiling final executable with OpenMP"
clang -fopenmp -O3 fasten_cpu.cbe.c -o tulip.clang.fasten.exe
