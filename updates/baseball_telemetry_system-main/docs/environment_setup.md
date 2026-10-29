# 🛠️ Development Environment Setup

This document describes how to create a reproducible cross-platform development environment for the **Baseball Telemetry Learning System**.

## Technologies Used

* **Windows 11** (primary host and Windows CI runner)
* **Ubuntu Desktop 24.04 LTS** (Linux CI runner / development VM)
* **GitHub Organization:** `codesavvy-labs`
* SSH-based Git access
* **Rust** (telemetry collector)
* **Python** (analytics layer)
* **C++** (logging / observability)
* **QEMU** (generic ARM MCU telemetry simulation)
* **VirtualBox** (runner VMs)

---

# 📌 Overview

This project is intentionally cross-platform:

```text
Windows
Linux
GitHub Actions
Rust
Python
C++
QEMU
```

The goal is:

* Reproducible setup
* Consistent toolchains
* Portable builds
* Repeatable CI runner provisioning
* Documented environment setup

Repositories and self-hosted runners are managed under:

**codesavvy-labs**

---

# Windows 11 CI Runner Setup

## 1) Create VM

Create a Windows 11 VM using VirtualBox.

### Recommended resources

```text
RAM:        8 GB minimum
CPUs:       4
Disk:       100–120 GB
OS:         Windows 11 Home / Pro
```

### Install

* Windows 11 64-bit ISO from Microsoft
* Microsoft account (recommended)
* VirtualBox Guest Additions
* Shared clipboard
* Shared folders (optional)

### Guest Additions benefits

* Clipboard sharing
* Display resizing
* Folder sharing

---

## 2) Configure GitHub Runner

Create a self-hosted runner in:

**codesavvy-labs**

Follow GitHub runner install instructions.

### Important

When installing the runner service:

**Do NOT run as SYSTEM**

Run the service as your normal Windows account:

```text
codesavvy\<username>
```

### Why

SYSTEM causes:

* PATH mismatches
* Rust toolchain issues
* rustup configuration issues
* SSH key visibility problems
* Profile differences

Running as your normal user keeps:

```text
interactive shell == runner environment
```

This greatly simplifies CI setup.

---

## 3) Install Software

Install:

* Git
* Python 3.12+
* CMake
* Clang
* clang-tidy
* Ninja
* Rust / rustup
* Visual Studio Community

  * Install **Desktop C++** workload

### Verify Rust

```powershell
rustup default stable
cargo --version
rustc --version
```

---

## 4) Verify Runner Environment

Run:

```powershell
whoami
$env:USERPROFILE
git --version
python --version
cargo --version
rustc --version
cmake --version
clang --version
ninja --version
```

Everything should succeed.

---

# Ubuntu Linux CI Runner Setup

## 1) Create VM

Create Ubuntu Desktop VM in VirtualBox.

### Recommended resources

```text
RAM:        8 GB minimum
CPUs:       4
Disk:       80–100 GB
OS:         Ubuntu Desktop 24.04 LTS
```

### Install Guest Additions

Enable:

* Clipboard sharing
* Dynamic display resizing
* Shared folders (optional)

---

## 2) Install Base Packages

Update:

```bash
sudo apt update
sudo apt upgrade -y
```

Install tools:

```bash
sudo apt install -y \
    build-essential \
    clang \
    clang-tidy \
    cmake \
    ninja-build \
    git \
    curl \
    python3 \
    python3-pip \
    python3-venv \
    qemu-system-arm
```

Install Rust:

```bash
curl https://sh.rustup.rs -sSf | sh
source ~/.cargo/env

rustup default stable
cargo --version
rustc --version
```

---

## 3) Configure SSH for GitHub

Generate key:

```bash
ssh-keygen -t ed25519 -C "codesavvy-linux-dev"
```

Display public key:

```bash
cat ~/.ssh/id_ed25519.pub
```

Add key to GitHub SSH keys.

Verify:

```bash
ssh -T git@github.com
```

Clone repo:

```bash
mkdir ~/dev
cd ~/dev
git clone git@github.com:codesavvy-labs/baseball_telemetry_system.git
```

---

## 4) Optional GitHub Runner

Install self-hosted runner for Linux.

Run service as normal Linux user.

Avoid root-owned service environments unless required.

---

## 5) Verify Runner Environment

Run:

```bash
whoami
echo $HOME
git --version
python3 --version
cargo --version
rustc --version
clang --version
cmake --version
ninja --version
qemu-system-arm --version
```

Everything should succeed.

---

# Key Lesson Learned

```text
Account that owns toolchain
=
Account that runs runner service
```

Keeping those aligned makes CI setup dramatically easier.
