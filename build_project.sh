
#!/bin/bash

# Install julia dependencies

export PATH=./julia:$PATH
export JULIA_PROJECT=.
export JULIA_DEPOT_PATH=./julia_depot

julia -e "using Pkg; Pkg.update(); Pkg.resolve(); Pkg.instantiate()"
