FROM silkeh/clang:17-bookworm

RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    make \
    zlib1g-dev \
    libzstd-dev \
    cmake

WORKDIR /llvm-lua
COPY .. .

RUN mkdir -p /llvm-lua/build

WORKDIR /llvm-lua/build

RUN cmake \
  -DLLVM_PATH=/usr/lib/llvm-17 \
  -DCMAKE_CXX_COMPILER=/usr/lib/llvm-17/bin/clang++ \
  -DCMAKE_C_COMPILER=/usr/lib/llvm-17/bin/clang \
  -DCMAKE_BUILD_TYPE=Release \
  -DLUA_USE_CURSES=OFF \
  -DCMAKE_VERBOSE_MAKEFILE=ON \
  -DLLVM_BUILD_LLVM_DYLIB=ON \
  -DBUILD_SHARED_LIBS=ON \
  -DLLVM_LINK_LLVM_DYLIB=ON \
  ../

RUN make -j12
