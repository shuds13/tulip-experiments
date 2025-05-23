## miniBUDE kernels

This directory includes code derived from miniBUDE (https://github.com/UoB-HPC/miniBUDE), licensed under the Apache License 2.0.

### fasten kernel

The fasten kernel calculates the binding energy between a ligand and a protein (i.e. drug docking). Energy for each pose (configuration) is worked out by accumulating the interaction energy of each ligand-protein atom pair. A pose is determined by an initial positional transformation applied to the ligand.

The aim is to evaluate the Tulip transpiler on the fasten kernel. These files are a work in progress and are used to share current issues.

In the first instance from CUDA to OpenMP for the CPU.

The Tulip tool-chain requires standalone examples (with a main function), which means the following files need to be combined:

- `src/main.cpp` - Host code.
- `src/bude.h` - defines the common data types.
- `src/cuda/fasten.hpp` - CUDA implementation of fasten kernel.

These have been combined into a file:

`fasten.cu`

Modifications also need to be made as there are several features that are currently unsupported, such as C++ templates.

At time of writing this is not fully working - [log.md](log.md) details the current variants of these files and the required source modifications to run through the tool-chain.
