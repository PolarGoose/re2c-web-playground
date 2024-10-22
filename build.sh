#!/usr/bin/env bash

set -x
set -o errexit
set -o nounset
set -o pipefail

scriptRoot=`dirname "$(realpath -s "${BASH_SOURCE[0]}")"`

buildDir="$scriptRoot/build"

rm -rf "$buildDir"
mkdir -p "$buildDir"

# Download and configure emscripten
git clone --depth=1 https://github.com/emscripten-core/emsdk.git "$buildDir/emsdk"
"$buildDir/emsdk/emsdk" install latest
"$buildDir/emsdk/emsdk" activate latest
source "$buildDir/emsdk/emsdk_env.sh"

# Download and build re2c
git clone --depth=1 https://github.com/skvadrik/re2c.git "$buildDir/re2c"
emcmake cmake \
  -G Ninja \
  -S "$buildDir/re2c" \
  -B "$buildDir/re2c-build" \
  -D CMAKE_CXX_FLAGS="\
    -s INVOKE_RUN=0 \
    -s SINGLE_FILE \
    -w" \
  -D RE2C_BUILD_RE2D=0 \
  -D RE2C_BUILD_RE2GO=0 \
  -D RE2C_BUILD_RE2HS=0 \
  -D RE2C_BUILD_RE2JAVA=0 \
  -D RE2C_BUILD_RE2JS=0 \
  -D RE2C_BUILD_RE2OCAML=0 \
  -D RE2C_BUILD_RE2PY=0 \
  -D RE2C_BUILD_RE2RUST=0 \
  -D RE2C_BUILD_RE2V=0 \
  -D RE2C_BUILD_RE2ZIG=0 \
  -D RE2C_BUILD_TESTS=0
emmake cmake --build "$buildDir/re2c-build"

cp --force "$buildDir/re2c-build/re2c.js" "$scriptRoot/docs"
