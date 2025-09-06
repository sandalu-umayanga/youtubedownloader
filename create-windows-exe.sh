#!/bin/bash
# Create Windows Executable Wrapper (portable ZIP + installer .bat)
# Can be run on Linux or Windows; creates a portable ZIP and batch installer.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT_DIR"

VERSION=$(mvn -q -Dexec.executable=echo -Dexec.args='${project.version}' --non-recursive org.codehaus.mojo:exec-maven-plugin:3.1.0:exec)
APP_NAME=$(mvn -q -Dexec.executable=echo -Dexec.args='${project.name}' --non-recursive org.codehaus.mojo:exec-maven-plugin:3.1.0:exec)
APP_NAME=${APP_NAME:-YouTubeDownloader}
DIST_ROOT="dist"
mkdir -p "$DIST_ROOT"

echo "Creating Windows portable package for $APP_NAME $VERSION..."

# Build the Windows package first
echo "1. Building Windows runtime image..."
mvn -q clean compile -Pwindows
mvn -q -Pwindows,jlink clean javafx:jlink

# Verify runtime image was created
if [ ! -d "target/image" ]; then
    echo "❌ Error: Runtime image was not created!"
    exit 1
fi

# Create Windows launchers
echo "2. Creating Windows launchers..."
cat > target/image/bin/YouTubeDownloader.bat << 'EOF'
@echo off
title YouTube Downloader
cd /d "%~dp0"
start "" "java.exe" -Dprism.order=d3d -m youtubedownloader/com.snake.youtubedownloader.App %*
EOF

cat > target/image/bin/YouTubeDownloader-console.bat << 'EOF'
@echo off
title YouTube Downloader Console
cd /d "%~dp0"
"java.exe" -Dprism.order=d3d -m youtubedownloader/com.snake.youtubedownloader.App %*
pause
EOF

# Create Windows installer script (batch)
echo "3. Creating Windows installer script..."
cat > "$DIST_ROOT/${APP_NAME}-installer.bat" << 'EOF'
@echo off
setlocal enabledelayedexpansion

echo ================================
echo YouTube Downloader Installer
echo ================================
echo.

:: Check for admin rights
net session >nul 2>&1
if !errorlevel! neq 0 (
    echo This installer requires administrator privileges.
    echo Please right-click and select "Run as administrator"
    echo.
    pause
    exit /b 1
)

:: Set installation directory
set "INSTALL_DIR=%ProgramFiles%\YouTubeDownloader"
set "START_MENU=%ProgramData%\Microsoft\Windows\Start Menu\Programs"
set "DESKTOP=%PUBLIC%\Desktop"

echo Installing YouTube Downloader...
echo Installation directory: %INSTALL_DIR%
echo.

:: Create installation directory
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

:: Copy files (assuming they're in the same directory as this installer)
echo Copying application files...
xcopy /E /I /Y "image" "%INSTALL_DIR%\image"

:: Create desktop shortcut
echo Creating desktop shortcut...
powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%DESKTOP%\YouTube Downloader.lnk'); $Shortcut.TargetPath = '%INSTALL_DIR%\image\bin\YouTubeDownloader.bat'; $Shortcut.WorkingDirectory = '%INSTALL_DIR%\image\bin'; $Shortcut.Description = 'YouTube Downloader'; $Shortcut.Save()"

:: Create Start Menu shortcut
echo Creating Start Menu shortcut...
powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%START_MENU%\YouTube Downloader.lnk'); $Shortcut.TargetPath = '%INSTALL_DIR%\image\bin\YouTubeDownloader.bat'; $Shortcut.WorkingDirectory = '%INSTALL_DIR%\image\bin'; $Shortcut.Description = 'YouTube Downloader'; $Shortcut.Save()"

:: Add to PATH
echo Adding to system PATH...
for /f "tokens=2*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PATH 2^>nul') do set "CURRENT_PATH=%%B"
echo !CURRENT_PATH! | find /i "%INSTALL_DIR%\image\bin" >nul
if !errorlevel! neq 0 (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PATH /t REG_EXPAND_SZ /d "!CURRENT_PATH!;%INSTALL_DIR%\image\bin" /f >nul
)

echo.
echo Installation completed successfully!
echo.
echo You can now:
echo - Run from Desktop: Double-click "YouTube Downloader" shortcut
echo - Run from Start Menu: Search for "YouTube Downloader"
echo - Run from Command Prompt: YouTubeDownloader.bat
echo.
echo Note: Ensure yt-dlp is installed (e.g.,: pip install yt-dlp)
echo.
pause
EOF

# Create distribution package folder
echo "4. Preparing distribution folder..."
PORTABLE_DIR="$DIST_ROOT/${APP_NAME}-${VERSION}-windows-portable"
rm -rf "$PORTABLE_DIR"
mkdir -p "$PORTABLE_DIR"

# Copy runtime image
cp -r target/image "$PORTABLE_DIR/"

# Copy documentation and installer
cp README.md "$PORTABLE_DIR/README.txt" || true
cp "$DIST_ROOT/${APP_NAME}-installer.bat" "$PORTABLE_DIR/YouTubeDownloader-installer.bat"

# Create a simple launcher for portable use
cat > "$PORTABLE_DIR/Start-YouTubeDownloader.bat" << 'EOF'
@echo off
cd /d "%~dp0\image\bin"
start "" "YouTubeDownloader.bat"
EOF

# Create ZIP package
echo "5. Creating ZIP package..."
( cd "$DIST_ROOT" && zip -r "${APP_NAME}-${VERSION}-windows-portable.zip" "${APP_NAME}-${VERSION}-windows-portable" )

# Show file size
if [ -f "$DIST_ROOT/${APP_NAME}-${VERSION}-windows-portable.zip" ]; then
    echo "Package: $DIST_ROOT/${APP_NAME}-${VERSION}-windows-portable.zip"
fi

echo "Done."
