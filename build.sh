#!/bin/bash

# Build our special version of taco

cd taco
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make -j8
cd ../..

# Build julia 1.7.2

export JULIA_DEPOT_PATH=./julia_depot
cd julia
make -j
cd ..

# Initialize environment variables

export PATH=./julia:$PATH
export JULIA_PROJECT=.
export LD_LIBRARY_PATH=./taco/build/lib:$LD_LIBRARY_PATH

# Install Julia dependencies

julia -e "using Pkg; Pkg.update(); Pkg.resolve()"
