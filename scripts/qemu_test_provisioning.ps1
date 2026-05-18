function New-QEMU-Folders {
   param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]   # Ensure array is not null or empty
        [string]$BaseFolder,            # Explicitly declare as string array

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]   # Ensure array is not null or empty
        [string[]]$SubFolders             # Explicitly declare as string array
   )
   
   foreach ($folder in $SubFolders) {
      $folderPath = Join-Path $BaseFolder $folder
      if (-not (Test-Path $folderPath)) {  # Avoid overwriting existing folders
         New-Item -Path $folderPath -ItemType Directory -Force | Out-Null
         
         if (-not (Test-Path $folderPath)) {
            throw "Missing required folder: $folderPath"
         }
      }
   }
}

$qemu_main_folder = "qemu_test"
$BasePath = Join-Path $pwd $qemu_main_folder

$QemuTestFolders = @(
    "",
    "images",
    "firmware",
    "kernel",
    "initramfs"
)

$FsTestFolders = @(
    "bin",
    "proc",
    "sys",
    "dev"
)
New-QEMU-Folders -BaseFolder $BasePath -SubFolders $QemuTestFolders
New-QEMU-Folders -BaseFolder (Join-Path $BasePath "initramfs") -SubFolders $FsTestFolders

Copy-Item `
      -Path "/usr/share/OVMF/OVMF_VARS_4M.fd" `
      -Destination (Join-Path $BasePath "firmware") `
      -Force

Copy-Item `
      -Path "/bin/busybox" `
      -Destination (Join-Path $BasePath "initramfs/bin") `
      -Force

Copy-Item `
      -Path "scripts/init" `
      -Destination (Join-Path $BasePath "initramfs") `
      -Force

bash -c "find . | cpio -H newc -o | gzip > $BasePath/telemetry-initramfs.cpio.gz"