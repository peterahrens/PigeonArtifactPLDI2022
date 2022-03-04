
#!/bin/bash

# Install julia dependencies

export PATH=./julia:$PATH
export JULIA_PROJECT=.

julia -e "using Pkg; Pkg.update(); Pkg.resolve(); Pkg.instantiate()"
