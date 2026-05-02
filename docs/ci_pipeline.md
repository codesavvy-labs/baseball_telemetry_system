Runner Setup
-- GitHub self hosted runners
    -- Win 11 Home Edition Runner
        -- Resources
            8 GB RAM
            4 Cores
            110 GB Hard Disk
        -- Tools
            Git:        2.53.0.windows.3
            Python:     3.12.4
            Rustc:      1.95.0 (59807616e 2026-04-14)
            cargo:      1.95.0 (f2d3ce0bd 2026-03-21)
            cmake:      4.3.1
            clang:      21.1.6
            clang-tidy: 21.1.6
            ninja:      1.13.2
            Visual Studio 2026 
                -- Community 
                -- Desktop C++
            -- Backward compatibility with new versions is probably supported for most of the tools
        -- lables - Windows, x64, CPP
        -- workflow steps
            -- Verify tools are installed on Windows
            -- Install Python test dependencies
            -- Run Python tests
            -- Run Rust tests
            
    -- Ubuntu Desktop version 24.04 Runner
        -- Resources
            8 GB RAM
            4 Cores
            110 GB Hard Disk
        -- Tools
            Git:                    2.43.0
            Python3:                3.12.3
            Rustc:                  1.95.0 (59807616e 2026-04-14)
            cargo:                  1.95.0 (f2d3ce0bd 2026-03-21)
            cmake:                  3.28.3
            clang:                  18.1.3
            clang-tidy:             18.1.3
            ninja:                  1.11.1
            gcc:                    13.3.0
            qemu-system-x86_64:     8.2.2 (Debian 1:8.2.2+ds-0ubuntu1.16)
            qemu-system-arm:        8.2.2 (Debian 1:8.2.2+ds-0ubuntu1.16)
            qemu-system-aarch64:    8.2.2 (Debian 1:8.2.2+ds-0ubuntu1.16)
            qemu-img:               8.2.2 (Debian 1:8.2.2+ds-0ubuntu1.16)
            -- Backward compatibility with new versions is probably supported for most of the tools       
        -- lables - Linux, X64, CPP
        -- workflow steps
            -- Verify tools are installed on Linux
            -- Setup Python3 venv
            -- Run Python3 tests
            -- Run Rust tests

-- Lessons learned
    -- When running as service for GitHub self host runners use the login account, in my case tomh and use your Microsoft account password.
    -- Follow instructions in GitHub precisely
    -- Take the time to document. I found a couple of issues by just doing that. Get the basic things down and then update accordingly.
