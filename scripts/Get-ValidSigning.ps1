function Test-BinarySignature {
    param (
        [Parameter(Mandatory = $true)]
        [string]$RepoRoot,

        [Parameter(Mandatory = $true)]
        [string]$BinaryPath,

        [Parameter(Mandatory = $true)]
        [string]$SignaturePath,

        [Parameter(Mandatory = $true)]
        [string]$CertsIssuedPath
    )

    if (-not (Test-Path $RepoRoot)) {
        throw "Missing required folder: $RepoRoot"
    }

    if (-not (Test-Path $BinaryPath)) {
        throw "Missing required binary: $BinaryPath"
    }

    if (-not (Test-Path $SignaturePath)) {
        throw "Missing required signature: $SignaturePath"
    }

    if (-not (Test-Path $CertsIssuedPath)) {
        throw "Missing required cert folder: $CertsIssuedPath"
    }

    $CertPath = Join-Path $CertsIssuedPath "code-signing.crt"
    $PublicPemPath = Join-Path $CertsIssuedPath "public.pem"

    openssl x509 `
        -in $CertPath `
        -pubkey `
        -noout `
        -out $PublicPemPath

    openssl dgst -sha256 `
        -verify $PublicPemPath `
        -signature $SignaturePath `
        $BinaryPath

    if ($LASTEXITCODE -ne 0) {
        throw "Signature verification failed for: $BinaryPath"
    }

    Write-Host "Signature verification succeeded for: $BinaryPath"
}

$RepoRoot = Split-Path $PSScriptRoot -Parent
 
$BinaryPath = Join-Path $RepoRoot "fixtures/valid/signing_probe.exe"
$SignaturePath = Join-Path $RepoRoot "fixtures/valid/signing_probe.sig"
$CertsIssuedPath = Join-Path $RepoRoot "certs/issued"

Write-Host "RepoRoot = $RepoRoot"
Write-Host "BinaryPath = $BinaryPath"
Write-Host "CertIssuedPath = $CertsIssuedPath"
Write-Host "SignautePath = $SignaturePath"

Test-BinarySignature `
    -RepoRoot $RepoRoot `
    -BinaryPath $BinaryPath `
    -SignaturePath $SignaturePath `
    -CertsIssuedPath $CertsIssuedPath