🛠️ Development Environment Setup

This document describes how to set up a cross-platform development environment for the Baseball Telemetry Learning System using:

Windows (primary host)
WSL2 (Linux environment)
GitHub (SSH-based access)
Rust (telemetry collector)
Python (analytics layer)
📌 Overview

This project is designed to run across both:

Windows (primary development + CI runner)
Linux (WSL2) (validation + portability)

The goal is a reproducible, clean development setup.

1. Install WSL2
Install

Open PowerShell:

wsl --install
Verify Installation
wsl --list --verbose

Expected output:

NAME      STATE     VERSION
Ubuntu    Stopped   2
Launch WSL
wsl

On first launch:

Create Linux username
Create password
2. Understand WSL Filesystem (Important)

WSL exposes two environments:

Location	Meaning
/mnt/c/...	Windows filesystem
/home/<user>/...	Linux filesystem
Recommendation

Always work inside the Linux filesystem:

cd ~
mkdir -p ~/projects
cd ~/projects
Why
Better performance
Avoid permission issues
Prevent cross-platform build problems
3. Install Base Linux Tooling
sudo apt update
sudo apt install -y \
    build-essential \
    curl \
    git \
    python3 \
    python3-venv \
    python3-pip

This installs:

cc / gcc (required by Rust)
Git
Python + venv support
4. Set Up SSH for GitHub (WSL)
Generate SSH Key
ssh-keygen -t ed25519 -C "your-email@example.com"

Accept defaults:

/home/<user>/.ssh/id_ed25519
Start SSH Agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
Add Key to GitHub

Copy the public key:

cat ~/.ssh/id_ed25519.pub

Then:

Go to GitHub → Settings
SSH and GPG Keys
New SSH Key
Paste key
Test Connection
ssh -T git@github.com

Expected:

Hi <username>! You've successfully authenticated...
5. Clone Repository (SSH)

⚠️ Use SSH, not HTTPS

git clone git@github.com:codesavvysoftware/baseball_telemetry_system.git
cd baseball_telemetry_system
6. Install Rust
Install via rustup
curl https://sh.rustup.rs -sSf | sh
source $HOME/.cargo/env
Persist Environment
echo 'source "$HOME/.cargo/env"' >> ~/.bashrc
source ~/.bashrc
Verify
rustc --version
cargo --version
7. Set Up Python Environment
cd python_app
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
8. Project Directory Layout

Recommended structure:

~/projects/
    baseball_telemetry_system/

Inside repo:

rust_collector/
python_app/
docs/
9. Verify Installation
Rust
cd rust_collector
cargo test

Expected:

test result: ok. 7 passed; 0 failed
Python
cd ../python_app
python src/main.py

Expected:

Python telemetry app starting...
Imports successful
Ready for telemetry input
10. Troubleshooting
SSH Authentication Failure

Error:

Permission denied (publickey)

Fix:

Ensure key added to GitHub
Run:
ssh-add ~/.ssh/id_ed25519
Wrong Clone URL

Problem:

git clone https://...

Fix:

git clone git@github.com:...
Rust Linker Error

Error:

linker `cc` not found

Fix:

sudo apt install build-essential
Python venv Issues

Error:

No module named venv

Fix:

sudo apt install python3-venv
11. Quality of Life Improvements (Optional)
Always Start in Home Directory
echo 'cd ~' >> ~/.bashrc
VSCode Integration

From WSL:

code .
Git Line Endings
git config --global core.autocrlf input
🎯 Summary

After completing this setup, you will have:

✅ WSL2 Linux environment
✅ SSH-based GitHub access
✅ Rust toolchain (cross-platform)
✅ Python virtual environment
✅ Clean project workspace
✅ Verified build and test workflow
🚀 Next Steps
Implement Rust → JSONL telemetry output
Connect Python ingestion layer
Add GitHub Actions CI/CD pipeline
Expand system architecture

This setup provides a reproducible, cross-platform development foundation for building a real telemetry pipeline system.

If you want next, we can:

👉 
add a Quick Start section for new users
👉 or 
create a CI/CD setup doc to pair with this
👉 or 
link this into your README cleanly

You’ve now got documentation that’s genuinely valuable — not just boilerplate.