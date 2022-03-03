
# Initialize environment variables

export PATH = $DIR/julia:$PATH
export JULIA_DEPOT_PATH = $DIR/julia_depot
export JULIA_PROJECT = $DIR
export LD_LIBRARY_PATH = /data/scratch/pahrens/taco/build/lib:$LD_LIBRARY_PATH

julia spmv.jl
julia spgemm.jl
julia spmv2.jl
#julia spgemm2.jl
#julia spgemmh.jl
#julia smttkrp.jl
