# Baseball Telemetry System – Definition of Consistent Builds

## 1) Build Reproducibility

### Windows Runner

* [ ] Clean checkout builds successfully
* [ ] No manual intervention required
* [ ] All dependencies documented
* [ ] Toolchain versions documented
* [ ] Runner setup procedure repeatable
* [ ] Build artifacts generated consistently

### Linux Runner

* [ ] Clean checkout builds successfully
* [ ] Python virtual environment setup documented
* [ ] Compiler / linker dependencies documented
* [ ] Runner service setup documented
* [ ] Build artifacts generated consistently

---

## 2) Test Reliability

### Python

* [ ] `pytest` executes cleanly
* [ ] Import paths stable
* [ ] Test discovery deterministic
* [ ] Sample data fixtures documented

### Rust

* [ ] `cargo test` passes cleanly
* [ ] Release build completes successfully
* [ ] Warnings reviewed / minimized

### C++

* [ ] Compilation warnings documented
* [ ] Warning policy defined
* [ ] Unit test strategy defined

---

## 3) CI Pipeline Quality

* [ ] Workflow YAML organized logically
* [ ] PowerShell scripts modularized
* [ ] Linux shell scripts modularized
* [ ] Logs are readable
* [ ] Failures are actionable
* [ ] Artifacts preserved
* [ ] Runner labels documented

---

## 4) Static Analysis (Phase 2)

* [ ] `clang-tidy` integration
* [ ] Rust `clippy` integration
* [ ] Python linting integration
* [ ] Warning gates defined in CI pipeline

---

## 5) Documentation

* [ ] Architecture overview
* [ ] Repository layout documented
* [ ] Setup guide created
* [ ] Troubleshooting guide created
* [ ] Restore-from-snapshot procedure documented
* [ ] Known issues list maintained

---

## 6) Stretch Goals

* [ ] Code coverage reporting
* [ ] Release packaging automation
* [ ] Reusable workflow templates
* [ ] Build badges / reporting dashboard
* [ ] Deployment automation

---

## 7) Definition of Done

> A new machine can be provisioned from documentation, runners attached, repository cloned, and builds/tests pass consistently on Windows and Linux without tribal knowledge.

---

## Notes

This document defines **Consistent Builds** for the Baseball Telemetry System.
It serves as the project’s operational readiness checklist and engineering quality baseline.

**Primary objective:**
Create a repeatable, documented, cross-platform software delivery system that is:

* Reliable
* Reproducible
* Understandable
* Maintainable
* Extensible
