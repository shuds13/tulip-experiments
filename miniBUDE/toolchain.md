LLVM: Fork based off of version 9.0.0
Repo: https://github.com/SusanTan/llvm-project
Branch: main

CudaFE: Cuda Front End
Two places where this is used in the tool chain.
First it takes the two files created by clang CUDA front-end compilation (e.g. host.ll and device.ll)
and merges them into one bitcode (LLVM IR) file. Secondly, it is used in an Optimizer step which
extracts the parallelism into LLVM metadata which can be used later to produce OpenMP for the CPU.
Repo: https://github.com/SusanTan/CudaFE
Branch: main

SPLENDID:  A decompiler that translates LLVM-IR to C/OpenMP code. Based on a fork of the
llvm-cbe (decompiles LLVM to C) which was previously part of the official llvm project but
is no longer maintained as part of the main LLVM project.
Repo: https://github.com/SusanTan/llvm-cbe
Branch: CPU
