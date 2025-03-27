ARG LLVM_VERSION=17
#ARG LLVM_VERSION=20
FROM silkeh/clang:${LLVM_VERSION}-bookworm
#FROM silkeh/clang:${LLVM_VERSION}-focal
#FROM silkeh/clang:latest

ARG LLVM_VERSION

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    make \
    zlib1g-dev \
    libzstd-dev \
    cmake

WORKDIR /llvm-lua
COPY .. .

RUN mkdir -p build
WORKDIR /llvm-lua/build

#-DLLVM_PATH=/usr/lib/llvm-${LLVM_VERSION}
#-DCMAKE_CXX_COMPILER=/usr/lib/llvm-${LLVM_VERSION}/bin/clang++
#-DCMAKE_C_COMPILER=/usr/lib/llvm-${LLVM_VERSION}/bin/clang

RUN cmake \
  -DLLVM_DIR=/usr/lib/llvm-${LLVM_VERSION}/lib/cmake/llvm \
  -DCMAKE_BUILD_TYPE=Debug \
  -DLUA_USE_CURSES=OFF \
  -DCMAKE_VERBOSE_MAKEFILE=ON \
  -DLLVM_BUILD_LLVM_DYLIB=ON \
  -DBUILD_SHARED_LIBS=ON \
  -DLLVM_LINK_LLVM_DYLIB=ON \
  -WANT_STATIC_LIBRARY=ON \
  ../

#RUN cmake .. -DENABLE_LLVM_SHARED=1 -DLLVM_PATH=/usr/lib/llvm-${LLVM_VERSION} -DCMAKE_BUILD_TYPE=Debug

#RUN cmake .. -DENABLE_LLVM_SHARED=1 -DLLVM_PATH=/usr/lib/llvm-${LLVM_VERSION} -DLLVM_DIR=/usr/lib/llvm-${LLVM_VERSION}/lib/cmake/llvm -DCMAKE_BUILD_TYPE=Release
#RUN cmake .. -DLLVM_PATH=/usr/lib/llvm-${LLVM_VERSION} -DCMAKE_BUILD_TYPE=Debug

#RUN make -j12 && make install
RUN make -j12
