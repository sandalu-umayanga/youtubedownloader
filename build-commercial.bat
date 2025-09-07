@echo off
title YouTube Downloader Pro - Commercial Build Script
echo ============================================
echo    YouTube Downloader Pro - Build Script
echo ============================================
echo.

REM Check if NSIS is installed
where makensis >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: NSIS is not installed or not in PATH
    echo Please install NSIS from: https://nsis.sourceforge.io/
    echo Or use: winget install NSIS.NSIS
    echo.
    pause
    exit /b 1
)

echo [1/4] Building Java application...
call mvn clean package javafx:jlink
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Maven build failed
    pause
    exit /b 1
)

echo.
echo [2/4] Checking required files...
if not exist "target\image\bin\javaw.exe" (
    echo ERROR: JavaFX application not built properly
    pause
    exit /b 1
)

if not exist "YouTubeDownloader-Working.bat" (
    echo ERROR: Launcher script not found
    pause
    exit /b 1
)

echo.
echo [3/4] Creating installer...
echo Building with NSIS...
makensis YouTubeDownloader-Commercial.nsi
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: NSIS build failed
    pause
    exit /b 1
)

echo.
echo [4/4] Build completed successfully!
echo.
echo OUTPUT: YouTubeDownloader-Pro-Setup.exe
echo.

REM Show file size and info
if exist "YouTubeDownloader-Pro-Setup.exe" (
    for %%A in ("YouTubeDownloader-Pro-Setup.exe") do (
        echo File size: %%~zA bytes
        echo Created: %%~tA
    )
    echo.
    echo The installer is ready for distribution!
    echo.
    echo To test the installer:
    echo 1. Right-click the .exe file
    echo 2. Select "Run as administrator"
    echo 3. Follow the installation wizard
    echo.
    choice /c YN /m "Would you like to test the installer now"
    if !ERRORLEVEL! EQU 1 (
        echo Starting installer...
        start "" "YouTubeDownloader-Pro-Setup.exe"
    )
) else (
    echo ERROR: Installer was not created successfully
    pause
    exit /b 1
)

echo.
echo Build process completed!
pause
