# YouTube Downloader Windows Uninstallation Script
# Run this script as Administrator

param(
    [switch]$Silent
)

$AppName = "YouTubeDownloader"
$InstallDir = "$env:ProgramFiles\YouTubeDownloader"
$StartMenuDir = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs"
$DesktopPath = "$env:PUBLIC\Desktop"

Write-Host "Uninstalling YouTube Downloader..." -ForegroundColor Red

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as Administrator!" -ForegroundColor Red
    Write-Host "Right-click on PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    if (-not $Silent) {
        Read-Host "Press Enter to exit"
    }
    exit 1
}

# Remove desktop shortcut
Write-Host "Removing desktop shortcut..."
Remove-Item -Path "$DesktopPath\YouTube Downloader.lnk" -Force -ErrorAction SilentlyContinue

# Remove Start Menu shortcut
Write-Host "Removing Start Menu shortcut..."
Remove-Item -Path "$StartMenuDir\YouTube Downloader.lnk" -Force -ErrorAction SilentlyContinue

# Remove from PATH
Write-Host "Removing from system PATH..."
$CurrentPath = [Environment]::GetEnvironmentVariable("PATH", "Machine")
if ($CurrentPath -like "*$InstallDir*") {
    $NewPath = $CurrentPath -replace ";?$([regex]::Escape($InstallDir));?", ""
    $NewPath = $NewPath -replace ";;", ";"
    $NewPath = $NewPath.Trim(";")
    [Environment]::SetEnvironmentVariable("PATH", $NewPath, "Machine")
}

# Remove installation directory
Write-Host "Removing application files..."
if (Test-Path $InstallDir) {
    Remove-Item -Path $InstallDir -Recurse -Force
}

Write-Host ""
Write-Host "YouTube Downloader has been completely uninstalled." -ForegroundColor Green
Write-Host ""

if (-not $Silent) {
    Read-Host "Press Enter to continue"
}
