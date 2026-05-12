# QEMU Lab Bring-Up Notes (Ubuntu VM)

## Purpose

Establish a working local QEMU development lab for x86_64 and ARM experimentation, including UEFI firmware support.

---

## 1) Install Required Packages

Update package lists and install QEMU components:

```bash
sudo apt update
sudo apt install \
    qemu-system-x86 \
    qemu-utils \
    qemu-system-arm \
    ovmf
```

### Package Summary

* **qemu-system-x86**
  Provides x86 / x86_64 machine emulation

* **qemu-utils**
  Includes useful utilities such as:

  * `qemu-img`
  * image conversion tools
  * disk image creation / inspection

* **qemu-system-arm**
  Provides ARM / AArch64 emulation support

* **ovmf**
  UEFI firmware images for QEMU virtual machines

---

## 2) Verify Installation

Confirm binaries are installed and operational:

```bash
qemu-system-x86_64 --version
qemu-system-aarch64 --version
qemu-img --version
```

Expected result:

* version information displayed
* commands execute without error

Example:

```text
QEMU emulator version 8.2.2
```

---

## 3) Verify Firmware Installation

Inspect installed UEFI firmware files:

```bash
ls /usr/share/OVMF
```

Important files:

* `OVMF_CODE_4M.fd`
* `OVMF_VARS_4M.fd`

### Meaning

**OVMF_CODE_4M.fd**

* firmware executable code
* read-only
* shared across VMs

**OVMF_VARS_4M.fd**

* firmware variable storage
* writable
* stores boot variables / UEFI settings
* typically copied per VM

---

## 4) Create QEMU Lab Workspace

Create a dedicated working directory:

```bash
mkdir -p ~/qemu-lab/{images,firmware,kernel,isos}
cd ~/qemu-lab
```

Directory layout:

```text
~/qemu-lab/
    images/
    firmware/
    kernel/
    isos/
```

Copy writable firmware variables file:

```bash
cp /usr/share/OVMF/OVMF_VARS_4M.fd firmware/
```

Result:

```text
~/qemu-lab/firmware/OVMF_VARS_4M.fd
```

This becomes your VM's writable firmware state.

---

## 5) First QEMU Boot

Launch a basic x86_64 virtual machine:

```bash
qemu-system-x86_64 \
  -machine q35 \
  -m 1024 \
  -bios /usr/share/OVMF/OVMF_CODE_4M.fd \
  -drive if=pflash,format=raw,file=firmware/OVMF_VARS_4M.fd
```

### Parameter Notes

**-machine q35**

* modern chipset emulation

**-m 1024**

* allocate 1 GB RAM

**-bios**

* load UEFI firmware code image

**-drive if=pflash**

* attach writable firmware variable storage

---

### Expected Result

QEMU window opens.

Possible message:

```text
Guest has not initialized the display (yet)
```

Interpretation:

**Success**

Firmware loaded, but:

* no OS installed
* no bootable disk attached
* no ISO attached

VM is waiting for boot media.

---

## 6) Terminate QEMU

Reliable shutdown method:

Go to the terminal where QEMU was launched and press:

```text
Ctrl+C
```

QEMU exits cleanly.

### Notes

Alternative monitor shortcuts exist, but for early lab work:

**Ctrl+C is simplest and most reliable**

---

## Outcome

Completed:

✅ Installed QEMU
✅ Installed UEFI firmware
✅ Verified binaries
✅ Created lab workspace
✅ Performed first VM boot
✅ Verified clean shutdown

Result:

**Working QEMU development lab established**
