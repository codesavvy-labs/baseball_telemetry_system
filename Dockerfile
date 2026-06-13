FROM ubuntu:24.04

RUN apt-get update && \
    apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    build-essential \
    clang \
    clang-tidy \
    cmake \
    ninja-build \
    curl \
    qemu-system-x86 \
    qemu-utils \
    graphviz \
    ovmf \
    cpio \
    linux-image-generic \
    busybox \
    wget apt-transport-https software-properties-common && \
    wget -q https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y powershell &&\
    rm -rf /var/lib/apt/lists/*

RUN test -f /usr/share/OVMF/OVMF_CODE_4M.fd && \
    test -f /usr/share/OVMF/OVMF_VARS_4M.fd

RUN mkdir -p /opt/qemu-test/kernels && \
    cp /boot/vmlinuz-* /opt/qemu-test/kernels/

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

ENV PATH="/root/.cargo/bin:${PATH}"

RUN rustup default stable

CMD ["bash"]

