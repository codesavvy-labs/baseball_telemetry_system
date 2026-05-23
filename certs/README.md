# Binary Signing Proof of Concept

## Overview

This repository contains a proof-of-concept implementation demonstrating binary signing and signature verification using OpenSSL.

The primary goals of this effort are:

* Explore software supply-chain security concepts
* Understand certificate trust chains and PKI fundamentals
* Demonstrate detached binary signing workflows
* Validate artifact integrity verification
* Build foundational knowledge for future CI/CD signing integration

This implementation intentionally focuses on learning and architectural understanding rather than production deployment.

---

# Trust Chain Architecture

The signing model implemented here uses a simple private certificate hierarchy:

```text
Root CA
    ↓ signs
Code Signing Certificate
    ↓ signs
Application Binary
```

The repository currently uses:

* A private root certificate authority (CA)
* A code-signing certificate issued by that CA
* Detached OpenSSL signatures for binaries

This is conceptually similar to real-world PKI systems used throughout modern software engineering and deployment environments.

---

# Repository Structure

```text
certs/
├── root/
│   ├── root-ca.crt
│   └── root-ca.key
│
├── issued/
│   ├── code-signing.crt
│   ├── code-signing.csr
│   ├── code-signing.ext
│   ├── code-signing.key
│   └── code-signing.pfx

signing_test/
├── signing_probe.exe
├── signing_probe.sig
└── test-signing.ps1
```

---

# Important Security Notes

Private keys and PFX bundles must never be committed to source control.

The following files are excluded using `.gitignore`:

```gitignore
certs/**/*.key
certs/**/*.pfx
certs/**/*.srl
certs/**/public.pem
```

Only public certificates (`.crt`) and configuration files should be committed.

---

# Detached Signature Model

This proof-of-concept currently uses detached signatures.

In this model:

```text
Binary File
    +
Detached Signature File
```

The executable itself is not modified.

Instead:

* OpenSSL computes a SHA-256 digest of the binary
* The digest is signed using the private signing key
* Verification is performed using the public certificate key

This approach is:

* cross-platform
* CI/CD friendly
* toolchain independent
* easy to automate
* educational for understanding PKI fundamentals

---

# Creating a Detached Signature

Example:

```powershell
openssl dgst -sha256 `
    -sign certs/issued/code-signing.key `
    -out signing_test/signing_probe.sig `
    signing_test/signing_probe.exe
```

---

# Exporting the Public Key

```powershell
openssl x509 `
    -in certs/issued/code-signing.crt `
    -pubkey `
    -noout `
    -out certs/issued/public.pem
```

---

# Verifying a Signature

```powershell
openssl dgst -sha256 `
    -verify certs/issued/public.pem `
    -signature signing_test/signing_probe.sig `
    signing_test/signing_probe.exe
```

Expected successful output:

```text
Verified OK
```

---

# Verification Failure Testing

Several failure scenarios were intentionally tested:

| Scenario                                | Expected Result |
| --------------------------------------- | --------------- |
| Original binary + matching signature    | PASS            |
| Modified/rebuilt binary + old signature | FAIL            |
| Missing signature file                  | FAIL            |
| Incorrect public key                    | FAIL            |

These tests demonstrate that artifact integrity verification is functioning correctly.

---

# Why OpenSSL?

This proof-of-concept intentionally uses OpenSSL rather than platform-specific signing tools.

Advantages include:

* Cross-platform support
* Linux and Windows compatibility
* Easier CI/CD automation
* Transparent PKI workflow visibility
* Better educational value for cryptographic concepts

Future work may include integration with:

* Windows Authenticode
* `signtool.exe`
* GitHub Actions signing workflows
* Secure secret management
* Hardware-backed signing
* Software Bill of Materials (SBOM) generation

---

# Future CI/CD Direction

This repository may eventually evolve toward a release pipeline resembling:

```text
Build
    ↓
Static Analysis
    ↓
Unit Tests
    ↓
Generate SBOM
    ↓
Sign Artifacts
    ↓
Verify Signatures
    ↓
Publish Release
```

At present, certificate generation and signing remain manual developer-controlled activities.

Private keys are intentionally not stored on CI runners.

---

# Disclaimer

This implementation is intended for educational and architectural exploration purposes only.

The certificates used here are private self-generated certificates and are not publicly trusted certificate authority roots.
