$HasMSVC = $null -ne (Get-Command cl -ErrorAction SilentlyContinue)
$HasClang = $null -ne (Get-Command clang -ErrorAction SilentlyContinue)

if (-not ($HasMSVC -or $HasClang)) {
    throw "No supported C/C++ compiler found"
}
python --version