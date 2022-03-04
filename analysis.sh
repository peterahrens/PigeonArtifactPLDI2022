# Initialize environment variables

export PATH=./julia:$PATH
export JULIA_PROJECT=.

julia analysis.jl spmv_data.json spgemm_data.json spmv2_data.json