#!/bin/bash

echo -e "\nPHASE 1: Compiling CUDA source to LLVM IR"
clang -Xclang -disable-O0-optnone -std=c++17 -S -emit-llvm -g vec_acc.cu

echo -e "\nPHASE 2: Linking CUDA device and host code"
llvm-link-cudafe vec_acc-cuda-nvptx64-nvidia-cuda-sm_20.ll vec_acc.ll -o vec_acc_linked.bc

echo -e "\nPHASE 3: Optimizing linked bytecode"
opt -load libLLVMCudaFE.so -merge-kernel -mem2reg -indvars -dce vec_acc_linked.bc -o vec_acc_cpu.bc > cudafe_debug.txt 2>&1

echo -e "\nPHASE 4: Running splendid decompiler on optimized bytecode"
/home/shudson/xcellent/llvm-install-debug/bin/splendid vec_acc_cpu.bc > splendid_debug.txt 2>&1

echo -e "\nPHASE 5: Compiling final executable with OpenMP"
clang -fopenmp -O3 vec_acc_cpu.cbe.c -o tulip.clang.vec_acc.exe
