#!/bin/bash
set -e

python3 --version
cargo --version
cmake --version
clang++ --version
gcc --version
dot -V
qemu-system-x86_64 --version
qemu-system-arm --version
qemu-system-aarch64 --version
qemu-img --version
clang-tidy --version

echo "Toolchain validation passed."