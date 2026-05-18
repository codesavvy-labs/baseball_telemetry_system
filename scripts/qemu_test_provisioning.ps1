$basePath = Join-Path $pwd "qemu-test"
Write-Host $basePath

if (-not (Test-Path $basePath)) {  # Avoid overwriting existing folders
   New-Item -Path $basePath -ItemType Directory -Force | Out-Null
      
   if (-not (Test-Path $basePath)) {
      throw "Missing required file: $basePath"
   }
}

$QemuTestFolders = @(
    "images",
    "firmware"
    "kernel"
    "initramfsinitramfs"
)

foreach ($folder in $QemuTestFolders) {
   $folderPath = Join-Path $basePath $folder
   if (-not (Test-Path $folderPath)) {  # Avoid overwriting existing folders
      New-Item -Path $folderPath -ItemType Directory -Force | Out-Null
      
      if (-not (Test-Path $folderPath)) {
         throw "Missing required file: $folderPath"
      }
   }
}


$FsTestFolders = @(
    "bin",
    "proc"
    "sys"
    "dev"
)
$fsBasePath = Join-Path $basePath "initramfs"
foreach ($folder in $FsTestFolders) {
    $folderPath = Join-Path $fsBasePath $folder
    if (-not (Test-Path $folderPath)) {  # Avoid overwriting existing folders
        New-Item -Path $folderPath -ItemType Directory -Force | Out-Null
      
      if (-not (Test-Path $folderPath)) {
         throw "Missing required file: $folderPath"
      }
   }
}

Copy-Item `
      -Path "/usr/share/OVMF/OVMF_VARS_4M.fd" `
      -Destination "$basePath/firmware/OVMF_VARS_4M.fd" `
      -Force

Copy-Item `
      -Path "/bin/busybox" `
      -Destination "$basePath/initramfs/bin" `
      -Force

Copy-Item `
      -Path "scripts/init" `
      -Destination "$basePath/initramfs" `
      -Force

find . | cpio -H newc -o | gzip > $basePath/telemetry-initramfs.cpio.gz