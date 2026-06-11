#!/usr/bin/env bash
set -euo pipefail

python3 --version
cargo --version
cmake --version | head -n 1
clang --version | head -n 1
clang-tidy --version | head -n 1
gcc --version | head -n 1
dot -V
qemu-system-x86_64 --version | head -n 1
qemu-img --version | head -n 1
pwsh --version | head -n 1
ls -l /usr/share/OVMF/OVMF_CODE_4M.fd
ls -l /usr/share/OVMF/OVMF_VARS_4M.fd
ls -l /bin/busybox
echo "Toolchain validation passed."