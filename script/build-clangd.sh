#!/usr/bin/env bash

set -ex

# assuming we're at project root
# apt update
# apt install -y python3-pip libcurl4-openssl-dev

pip3 install -U conan
source ~/.profile

cp script/settings.yml ~/.conan/

conan install -o influxdb-cxx:system=True -o influxdb-cxx:tests=True -if cmake -of build .

cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=True \
    -DCMAKE_TOOLCHAIN_FILE=./cmake/conan_paths.cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DINFLUXCXX_WITH_BOOST=True \
    .
cmake --build build
# make sure compile_commands.json is on the root project so
# clangd can provide intelligence
cp build/compile_commands.json ./

