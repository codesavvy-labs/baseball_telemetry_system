# Baseball Telemetry System

A multi-language telemetry and CI/CD laboratory project demonstrating:

* Cross-platform build orchestration
* Python, Rust, and C++ integration
* Static analysis and unit testing
* Architecture documentation generation
* QEMU-based embedded Linux smoke testing
* Artifact generation and telemetry capture
* Self-hosted GitHub Actions runners

---

# Project Goals

This project began as an exploration into:

* Modern CI/CD workflows
* Cross-platform software validation
* Infrastructure automation
* Embedded Linux tooling
* QEMU-based virtualization workflows
* Multi-language build orchestration
* Architecture visualization and dependency analysis

The repository has evolved into a systems engineering sandbox combining:

* Python
* Rust
* C++
* PowerShell
* GitHub Actions
* QEMU
* Embedded Linux concepts

---

# Current Pipeline Capabilities

## Windows Runner

* Python linting and unit testing
* Rust formatting, clippy, unit tests, release builds
* C++ build using CMake + Ninja + MSVC
* clang-tidy static analysis
* Artifact publishing
* Dependency caching

## Linux Runner

* Python linting and unit testing
* Rust formatting, clippy, unit tests, release builds
* C++ build using CMake + Ninja
* clang-tidy static analysis
* QEMU-based Linux boot testing
* initramfs packaging
* Serial telemetry capture
* Architecture graph generation
* Dependency graph generation
* Artifact publishing
* Dependency caching

---

# QEMU Embedded Linux Smoke Test

The Linux pipeline includes a lightweight embedded Linux style smoke test using:

* QEMU
* BusyBox
* initramfs
* Ubuntu kernel image
* Serial console telemetry logging

The workflow:

1. Creates an initramfs
2. Injects BusyBox and a custom `/init` script
3. Boots Linux in QEMU
4. Emits JSON telemetry records
5. Captures serial output as build artifacts
6. Powers down the guest automatically

This allows the CI pipeline to validate more than compilation alone.

---

# Repository Structure

```text
.github/workflows/
    GitHub Actions pipelines

cpp_app/
    C++ telemetry application

python_app/
    Python telemetry tooling and tests

rust_collector/
    Rust telemetry collector

docs/
    Architecture diagrams and documentation

scripts/
    PowerShell automation and QEMU provisioning

qemu-test/
    initramfs generation and telemetry guest artifacts
```

---

# Tooling

## Languages

* Python
* Rust
* C++
* PowerShell

## Build Systems & Tooling

* GitHub Actions
* CMake
* Ninja
* cargo
* pytest
* clang-tidy
* GraphViz

## Virtualization & Embedded Linux

* QEMU
* BusyBox
* initramfs
* OVMF

---

# Example Pipeline Stages

## Validation

* Python linting and tests
* Rust formatting and clippy
* Rust unit tests
* C++ compilation and static analysis

## Architecture

* Rust dependency tree generation
* GraphViz architecture rendering

## Embedded Linux

* initramfs generation
* Linux kernel boot
* Guest telemetry emission
* Serial log artifact capture

---

# Artifacts Generated

Examples of generated artifacts include:

* Rust binaries
* C++ binaries
* Rust dependency trees
* Architecture diagrams
* QEMU telemetry logs

---

# Future Directions

Planned areas of exploration include:

* ARM and RISC-V QEMU targets
* Cross-compilation toolchains
* Profile-driven QEMU boot configuration
* Embedded Rust experimentation
* Additional telemetry pipelines
* Build orchestration improvements
* Enhanced architecture visualization
* Runner capability labeling and provisioning

---

# Why This Project Exists

This repository is intended to serve as:

* A systems engineering laboratory
* A CI/CD experimentation platform
* A cross-platform build environment
* An embedded Linux learning environment
* A demonstration of modern infrastructure automation concepts

The emphasis is on understanding how software systems are built, validated, packaged, tested, and orchestrated across platforms.

---

# License

TBD
