# YouTube Downloader Windows Installation Script
# Run this script as Administrator

param(
    [switch]$Silent
)

$AppName = "YouTubeDownloader"
$InstallDir = "$env:ProgramFiles\YouTubeDownloader"
$StartMenuDir = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs"
$DesktopPath = "$env:PUBLIC\Desktop"

Write-Host "Installing YouTube Downloader for Windows..." -ForegroundColor Green

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as Administrator!" -ForegroundColor Red
    Write-Host "Right-click on PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    if (-not $Silent) {
        Read-Host "Press Enter to exit"
    }
    exit 1
}

# Create installation directory
Write-Host "Creating installation directory: $InstallDir"
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null

# Copy runtime image
Write-Host "Copying application files..."
Copy-Item -Path "image\*" -Destination $InstallDir -Recurse -Force

# Create Windows launcher script
Write-Host "Creating Windows launcher..."
$LauncherContent = @"
@echo off
cd /d "%~dp0"
start "" "bin\java.exe" -Dprism.order=d3d -m youtubedownloader/com.snake.youtubedownloader.App %*
"@
$LauncherContent | Out-File -FilePath "$InstallDir\YouTubeDownloader.bat" -Encoding ASCII

# Create desktop shortcut
Write-Host "Creating desktop shortcut..."
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$DesktopPath\YouTube Downloader.lnk")
$Shortcut.TargetPath = "$InstallDir\YouTubeDownloader.bat"
$Shortcut.WorkingDirectory = $InstallDir
$Shortcut.Description = "YouTube Downloader - Download videos from YouTube"
$Shortcut.Save()

# Create Start Menu shortcut
Write-Host "Creating Start Menu shortcut..."
$StartMenuShortcut = $WshShell.CreateShortcut("$StartMenuDir\YouTube Downloader.lnk")
$StartMenuShortcut.TargetPath = "$InstallDir\YouTubeDownloader.bat"
$StartMenuShortcut.WorkingDirectory = $InstallDir
$StartMenuShortcut.Description = "YouTube Downloader - Download videos from YouTube"
$StartMenuShortcut.Save()

# Add to PATH (optional)
Write-Host "Adding to system PATH..."
$CurrentPath = [Environment]::GetEnvironmentVariable("PATH", "Machine")
if ($CurrentPath -notlike "*$InstallDir*") {
    [Environment]::SetEnvironmentVariable("PATH", "$CurrentPath;$InstallDir", "Machine")
}

Write-Host ""
Write-Host "Installation completed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "You can now:" -ForegroundColor Yellow
Write-Host "1. Run from Desktop: Double-click 'YouTube Downloader' shortcut"
Write-Host "2. Run from Start Menu: Search for 'YouTube Downloader'"
Write-Host "3. Run from Command Prompt: YouTubeDownloader.bat"
Write-Host "4. Run directly: $InstallDir\YouTubeDownloader.bat"
Write-Host ""
Write-Host "Note: Make sure yt-dlp is installed for downloading functionality:" -ForegroundColor Cyan
Write-Host "  pip install yt-dlp"
Write-Host "  or download from: https://github.com/yt-dlp/yt-dlp/releases"
Write-Host ""

if (-not $Silent) {
    Read-Host "Press Enter to continue"
}
