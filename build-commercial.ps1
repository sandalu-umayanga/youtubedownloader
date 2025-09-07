# YouTube Downloader Pro - Commercial Build Script
# PowerShell version for better Windows integration

param(
    [switch]$SkipBuild,
    [switch]$TestInstaller,
    [string]$CompanyName = "Your Company Name",
    [string]$Website = "https://your-website.com"
)

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   YouTube Downloader Pro - Build Script" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Function to check if a command exists
function Test-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

# Check prerequisites
Write-Host "[Checking Prerequisites]" -ForegroundColor Yellow

if (-not (Test-Command "mvn")) {
    Write-Host "ERROR: Maven is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Maven and ensure it's in your PATH" -ForegroundColor Red
    exit 1
}

if (-not (Test-Command "makensis")) {
    Write-Host "ERROR: NSIS is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install NSIS from: https://nsis.sourceforge.io/" -ForegroundColor Red
    Write-Host "Or use: winget install NSIS.NSIS" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Maven found" -ForegroundColor Green
Write-Host "✓ NSIS found" -ForegroundColor Green
Write-Host ""

# Build Java application
if (-not $SkipBuild) {
    Write-Host "[1/4] Building Java application..." -ForegroundColor Yellow
    $buildResult = & mvn clean package javafx:jlink
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Maven build failed" -ForegroundColor Red
        exit 1
    }
    Write-Host "✓ Java application built successfully" -ForegroundColor Green
} else {
    Write-Host "[1/4] Skipping build (using existing build)..." -ForegroundColor Yellow
}

# Check required files
Write-Host "[2/4] Checking required files..." -ForegroundColor Yellow

$requiredFiles = @(
    "target\image\bin\javaw.exe",
    "YouTubeDownloader-Working.bat",
    "README.md",
    "LICENSE"
)

foreach ($file in $requiredFiles) {
    if (-not (Test-Path $file)) {
        Write-Host "ERROR: Required file not found: $file" -ForegroundColor Red
        exit 1
    }
    Write-Host "✓ Found: $file" -ForegroundColor Green
}

# Update NSIS script with company information
Write-Host "[3/4] Preparing installer configuration..." -ForegroundColor Yellow

if ($CompanyName -ne "Your Company Name" -or $Website -ne "https://your-website.com") {
    Write-Host "Updating company information..." -ForegroundColor Cyan
    $nsiContent = Get-Content "YouTubeDownloader-Commercial.nsi" -Raw
    $nsiContent = $nsiContent -replace "Your Company Name", $CompanyName
    $nsiContent = $nsiContent -replace "https://your-website.com", $Website
    Set-Content "YouTubeDownloader-Commercial.nsi" -Value $nsiContent -Encoding UTF8
    Write-Host "✓ Company information updated" -ForegroundColor Green
}

# Create installer
Write-Host "[4/4] Creating installer with NSIS..." -ForegroundColor Yellow
$nsisResult = & makensis YouTubeDownloader-Commercial.nsi
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: NSIS build failed" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "BUILD COMPLETED SUCCESSFULLY!" -ForegroundColor Green -BackgroundColor Black
Write-Host ""

# Show installer information
if (Test-Path "YouTubeDownloader-Pro-Setup.exe") {
    $installerInfo = Get-Item "YouTubeDownloader-Pro-Setup.exe"
    $sizeInMB = [math]::Round($installerInfo.Length / 1MB, 2)
    
    Write-Host "📦 INSTALLER DETAILS:" -ForegroundColor Cyan
    Write-Host "   File: YouTubeDownloader-Pro-Setup.exe" -ForegroundColor White
    Write-Host "   Size: $sizeInMB MB" -ForegroundColor White
    Write-Host "   Created: $($installerInfo.LastWriteTime)" -ForegroundColor White
    Write-Host ""
    
    Write-Host "🚀 DISTRIBUTION READY!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps for commercial distribution:" -ForegroundColor Yellow
    Write-Host "1. Test the installer thoroughly" -ForegroundColor White
    Write-Host "2. Code sign the executable (recommended for commercial software)" -ForegroundColor White
    Write-Host "3. Create product documentation and marketing materials" -ForegroundColor White
    Write-Host "4. Set up payment processing and licensing system" -ForegroundColor White
    Write-Host "5. Upload to your distribution platform" -ForegroundColor White
    Write-Host ""
    
    # Test installer option
    if ($TestInstaller) {
        Write-Host "Testing installer..." -ForegroundColor Cyan
        Start-Process "YouTubeDownloader-Pro-Setup.exe" -Verb RunAs
    } else {
        $response = Read-Host "Would you like to test the installer now? (y/n)"
        if ($response -eq 'y' -or $response -eq 'Y') {
            Write-Host "Starting installer (requires administrator privileges)..." -ForegroundColor Cyan
            Start-Process "YouTubeDownloader-Pro-Setup.exe" -Verb RunAs
        }
    }
} else {
    Write-Host "ERROR: Installer was not created successfully" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Build process completed!" -ForegroundColor Green
