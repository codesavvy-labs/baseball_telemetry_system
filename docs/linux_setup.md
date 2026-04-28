Linux VM for Software Development

OS: Ubuntu Ubuntu 24.04 LTS (desktop)
    Reason:
        stable
        broad package support
        good Rust/Python/QEMU docs
        long support window
        easy SSH

    Give it:
        4 CPUs
        8 GB RAM minimum
        80–120 GB disk

        8 CPUs & 16 GB preferable.  I opted for 4 and 8.
Install for devopment:
    Immediately:
        sudo apt update
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
            jq \
            qemu-system-arm

        For Rust:
            curl https://sh.rustup.rs -sSf | sh
            source ~/.cargo/env

    Verification:
        git --version
        python3 --version
        cargo --version
        clang --version
        cmake --version
        qemu-system-arm --version

    Install Virtual Box Guest Additions:
        Update Packages:
            sudo apt update
            sudo apt upgrade -y

        Install build prerequisites:
            sudo apt install -y build-essential dkms linux-headers-$(uname -r)

        Insert Guest Additions ISO:
                Devices→ Insert Guest Additions CD Image...
        
        Usually appears under:
           /media/<username>/VBox_GAs_*

        Check if it is there:
             ls /media/$USER

        Run installer:
            cd /media/$USER/VBox_GAs_*
            sudo ./VBoxLinuxAdditions.run

    clone repo:
        install SSH Key:
            ssh-keygen -t ed25519 -C "codesavvy-linux-dev"

            use defaults I didn't use a password.

            display ssh key on terminal:
                cat ~/.ssh/id_ed25519.pub

            Add to GitHub:
                Profile picture → Settings → SSH and GPG keys → New SSH key
                Title:
                    codesavvy-linux-dev
                paste the key
        mkdir ~/dev
        cd ~/dev
        git clone git@github.com:codesavvy-labs/baseball_telemetry_system.git
    
    Rust tests
        cd ~/dev/baseball_telemetry_system/rust_collector
        cargo test
        
        expected that all the tests pass. 

        run collection
            cargo run

            expected to see something similar to the below
                starting rust collector
                collector listening 

        python consumer
            cd ~/dev/baseball_telemetry_system/python_app
            python3 src/main.py  

            expect to see a stream of messages coming from the compiled version
            
