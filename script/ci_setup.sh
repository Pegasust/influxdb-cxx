#!/bin/bash

set -ex

apt-get update
apt-get install -y python3-pip libcurl4-openssl-dev
pip3 install -U conan

conan profile new default --detect


if [[ "${CXX}" == clang* ]]
then
    # export CXXFLAGS="-stdlib=libc++"
    # conan profile update settings.compiler.libcxx=libc++ default
    echo "*** skip ***"
else
    conan profile update settings.compiler.libcxx=libstdc++11 default
fi

conan profile update settings.compiler.cppstd=17 default

cp script/settings.yml ~/.conan/

conan install \
    -o influxdb-cxx:system=True \
    -o influxdb-cxx:tests=True \
    -s compiler.cppstd=17 \
    --build=missing \
    .
