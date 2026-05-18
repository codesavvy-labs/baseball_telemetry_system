$RequiredFiles = @(
    "/usr/share/OVMF/OVMF_CODE_4M.fd",
    "/usr/share/OVMF/OVMF_VARS_4M.fd"
)

foreach ($File in $RequiredFiles) {
    if (-not (Test-Path $File)) {
        throw "Missing required firmware file: $File"
    }
}

python3 --version
gcc --version
dot -V
qemu-system-x86_64 --version
qemu-system-arm --version
qemu-system-aarch64 --version
qemu-img --version

