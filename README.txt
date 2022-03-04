Welcome Artifact Evaluator!

#-----------------------#
| Getting Started Guide |
#-----------------------#

1. For your convenience, we have included a Dockerfile to build the required
project dependencies. If it's possible for you to execute `docker build -t
pigeon Dockerfile` from the project directory, skip to step 5.

2. If you'd rather not use the Dockerfile, there are three main dependencies to
the project that you must build. Each dependency is included in it's own
directory in the artifact, and we expect them to be built locally.

    - `julia` 1.7.2 is our chosen version of the julia programming language.
    You can build by running `sh build_julia.sh` from the toplevel directory.
    Julia contains a README explaining build steps in detail.
        
    - taco is the project that writes the tensor expressions we autotune. We
    have included a special version of taco that contains some interface
    modifications needed to replicate our results. You can build by running `sh
    build_taco.sh` from the toplevel directory. The taco directory contains a
    README explaining build steps in detail. You'll need to install `cmake` for
    this step.

    - `Pigeon.jl` is the julia project which contains our autotuner
    implementation.  You can download project dependencies by running `sh
    build_project.sh` from the toplevel directory.  For those familiar with
    Julia, the project dependencies for all the scripts are contained in the
    `Project.toml` and `Manifest.toml` files in the toplevel directory,
    including a dependency on the locally developed package `Pigeon.jl`.

#---------------------------#
| Step-by-Step Instructions |
#---------------------------#

Our paper contains experiments with 6 test kernels, named spmv, spmv2,
spgemm, spgemm2, spgemmh, and spmttkrp. They are described in Figure 6. The
results for spgemm2, spgemmh, and spmttkrp each take a very long time to collect
(several hours).  Therefore, we only expect the artifact evaluation to consider
the results for the core kernels, spmv, spmv2, and spgemm. The other kernels are
optional. Scheduling the reduced set of kernels is fairly representative of the
full space of scheduling decisions. Spmv2 requires an intermediate tensor to
minimize loop depth, and spgemm requires a specific loop ordering for
appropriate iteration space filtering. Spmv is not a hard kernel to schedule, so
this is the trivial input, and we do not expect to improve on the default
schedule.

Only Figures 6 and 7 require evaluation. The code to collect all the data for a
particular kernel is included in a `*.jl` file named after the kernel, so
running `julia spmv.jl` will collect data for the spmv kernel. You can collect
data for all three core kernels by running `sh run.sh`. Running one of these
scripts will generate a `.json` file with the same name to hold the data. The
`.json` files we produced are included in the `reference_results` folder.

The names of the fields in each `.json` file are as follows:

N: The default dimension of square tensors used in the kernel. This is set by
measuring the runtime of the default kernel on your machine, it may not match
the value in the paper.

universe_build_time: The time required to enumerate all minimum depth schedules.
universe_length: The number of minimum depth schedules.
frontier_filter_time: The time required to filter out the asymptotically
    undominated frontier of minimum depth schedules.
frontier_length: The size of the asymptotically undominated frontier of minimum
    depth schedules.

tacoverse_build_time: The time required to enumerate all minimum depth
    taco-compatible schedules.
tacoverse_length: The number of minimum depth taco-compatible schedules.
tacotier_filter_time: The time required to filter out the asymptotically
    undominated frontier of minimum depth taco-compatible schedules.
tacotier_length: The size of the asymptotically undominated frontier of minimum
    depth taco-compatible schedules.

tacotier_bench: The runtime of each kernel in the taco frontier on uniformly
    distributed square inputs of dimension N and density 0.01.
default_kernel_bench: The runtime of the default kernel on the same inputs.

n_series: A series of square dimension sizes for tensors of density 0.01.
default_n_series: The runtime of the default kernel on these inputs.
default_n_series: The runtime of the autotuned kernel on these inputs.

p_series: A series of densities for tensors of size N. We have truncated this
range to reduce the probability of taco segfaults at extremely low tensor
density on some systems.
default_p_series: The runtime of the default kernel on these inputs.
default_p_series: The runtime of the autotuned kernel on these inputs.

The `analysis.jl` script will gather all `*.json` files passed to it and visualize
the results as they are presented in the paper.

3. Run the `run.sh` script to autotune and benchmark all three kernels.
4. Run the `analysis.sh` script to interpret the results and compare to figures 6
and 7 in the paper.
5. A table for figure 6 will be written to the file "figure6.txt", and tables
for figure 7 will be written to the file "figure7.txt".  Additionally, the table
for figure 6 and unicode plots for figure7 will be output to the command line by
the `analysis.jl` script.  You can compare the output of these scripts to the
contents of the paper. Any counts of schedules should match exactly, but
performance variations might be noticed.  Even so, there should be an obvious
trend showing a big speedup of the autotuned kernels over the default ones for
spmv2 and spgemm, since the default for these kernels is asymptotically bad. The
performance for spmv should be roughly the same. If you would like to run the
analysis script again to see its output, try

`docker run -t pigeon sh analysis.sh`