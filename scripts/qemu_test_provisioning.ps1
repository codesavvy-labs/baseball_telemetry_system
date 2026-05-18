$basePath = "qemu-test"

if (-not (Test-Path $basePath)) {  # Avoid overwriting existing folders
   New-Item -Path $basePath -ItemType Directory | Out-Null
      
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
      New-Item -Path $folderPath -ItemType Directory | Out-Null
      
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
$fsBasePath = "qemu-test/initramfsinitramfs"
foreach ($folder in $FsTestFolders) {
    $folderPath = Join-Path $fsBasePath $folder
    if (-not (Test-Path $folderPath)) {  # Avoid overwriting existing folders
        New-Item -Path $folderPath -ItemType Directory | Out-Null
      
      if (-not (Test-Path $folderPath)) {
         throw "Missing required file: $folderPath"
      }
   }
}

