# Expected Python version (change as needed)
$lowestVersion = "3.12.0"
$toorecentVersion = "3.13.0"
try {
    # Try to get Python version
    $pythonVersionOutput = & python --version 2>&1
    Write-Host $pythonVersionOutput

    if (-not $pythonVersionOutput) {
        Write-Host "Python not installed"
        exit 1
    }
    # Extract version number (e.g., "Python 3.11.5" → "3.11.5")
    if ($pythonVersionOutput -match "Python\s+([\d\.]+)") {
        $installedVersion = $matches[1]
        Write-Host "Installed Python version: $installedVersion"
    } else {
        Write-Host "Could not parse Python version output: $pythonVersionOutput"
        exit 1
    }
    if ([version]$installedVersion -lt [version]$lowestVersion) {
        Write-Host "Python version is too lo."
        exit 1
    }
    if ([version]$installedVersion -ge [version]$toorecentVersion) {
        Write-Host "Python version is too hi."
        exit 1
    }
    Write-Host "Python version is within the acceptable range."
    exit 0

} catch {
    Write-Host "Error checking Python version:"
    exit 1
}