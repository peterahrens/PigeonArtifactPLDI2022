DIR = dirname "$0"

# Build our special version of taco

cd $DIR/taco
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make -j4
cd $DIR

# Build julia 1.7.2

cd $DIR/julia
make -j4
cd $DIR

# Initialize environment variables

export PATH = $DIR/julia:$PATH
export JULIA_DEPOT_PATH = $DIR/julia_depot
export JULIA_PROJECT = $DIR
export LD_LIBRARY_PATH = /data/scratch/pahrens/taco/build/lib:$LD_LIBRARY_PATH

# Install Julia dependencies

julia -e "using Pkg; Pkg.resolve()"
