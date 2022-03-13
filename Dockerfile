FROM docker.io/library/julia:1.7.2-bullseye

RUN apt-get -y update 
RUN apt-get -y install cmake 
RUN apt-get -y install gcc
RUN apt-get -y install g++
RUN apt-get -y install python
RUN apt-get -y install python3
RUN apt-get -y install git

WORKDIR PigeonArtifactPLDI2022

COPY ./taco /PigeonArtifactPLDI2022/taco
COPY ./build_taco.sh /PigeonArtifactPLDI2022
RUN bash -e build_taco.sh

COPY ./Project.toml /PigeonArtifactPLDI2022/
COPY ./Manifest.toml /PigeonArtifactPLDI2022/
COPY ./Pigeon.jl /PigeonArtifactPLDI2022/Pigeon.jl
COPY ./build_project.sh /PigeonArtifactPLDI2022
RUN bash -e build_project.sh

#COPY ./julia /PigeonArtifactPLDI2022/julia
#COPY ./build_julia.sh /PigeonArtifactPLDI2022
#RUN bash -e build_julia.sh

COPY ./paper.jl /PigeonArtifactPLDI2022
COPY ./spmv.jl /PigeonArtifactPLDI2022
COPY ./spgemm.jl /PigeonArtifactPLDI2022
COPY ./spmv2.jl /PigeonArtifactPLDI2022
COPY ./run.sh /PigeonArtifactPLDI2022

RUN bash -e run.sh

COPY . /PigeonArtifactPLDI2022

RUN bash -e analysis.sh