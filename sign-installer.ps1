# Code Signing Script for YouTube Downloader Pro
# This script signs the installer for commercial distribution

param(
    [Parameter(Mandatory=$true)]
    [string]$CertificatePath,
    
    [Parameter(Mandatory=$true)]
    [string]$CertificatePassword,
    
    [string]$TimestampServer = "http://timestamp.digicert.com",
    [string]$InstallerPath = "YouTubeDownloader-Pro-Setup.exe"
)

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   Code Signing for Commercial Distribution" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Check if signtool is available
if (-not (Get-Command "signtool.exe" -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: SignTool.exe not found" -ForegroundColor Red
    Write-Host "Please install Windows SDK or Visual Studio" -ForegroundColor Red
    Write-Host "SignTool is typically located in:" -ForegroundColor Yellow
    Write-Host "  C:\Program Files (x86)\Windows Kits\10\bin\x64\signtool.exe" -ForegroundColor Yellow
    exit 1
}

# Check if installer exists
if (-not (Test-Path $InstallerPath)) {
    Write-Host "ERROR: Installer not found: $InstallerPath" -ForegroundColor Red
    Write-Host "Please build the installer first using build-commercial.ps1" -ForegroundColor Red
    exit 1
}

# Check if certificate exists
if (-not (Test-Path $CertificatePath)) {
    Write-Host "ERROR: Certificate not found: $CertificatePath" -ForegroundColor Red
    exit 1
}

Write-Host "Signing installer..." -ForegroundColor Yellow
Write-Host "Certificate: $CertificatePath" -ForegroundColor Cyan
Write-Host "Installer: $InstallerPath" -ForegroundColor Cyan
Write-Host ""

# Sign the installer
$signCommand = @(
    "sign"
    "/f", $CertificatePath
    "/p", $CertificatePassword
    "/t", $TimestampServer
    "/d", "YouTube Downloader Pro"
    "/du", "https://your-website.com"
    $InstallerPath
)

try {
    & signtool.exe $signCommand
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Installer signed successfully!" -ForegroundColor Green
        
        # Verify the signature
        Write-Host "Verifying signature..." -ForegroundColor Yellow
        & signtool.exe verify /pa $InstallerPath
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ Signature verified successfully!" -ForegroundColor Green
            Write-Host ""
            Write-Host "Your installer is now ready for commercial distribution!" -ForegroundColor Green -BackgroundColor Black
        } else {
            Write-Host "WARNING: Signature verification failed" -ForegroundColor Yellow
        }
    } else {
        Write-Host "ERROR: Code signing failed" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "ERROR: Exception during code signing: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Code signing completed!" -ForegroundColor Green
