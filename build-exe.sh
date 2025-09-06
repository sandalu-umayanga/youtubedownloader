#!/bin/bash
# Windows .exe Installer Builder Script
# This script builds Windows .exe installers (run on Windows with JDK 21+jpackage)

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT_DIR"

VERSION=$(mvn -q -Dexec.executable=echo -Dexec.args='${project.version}' --non-recursive org.codehaus.mojo:exec-maven-plugin:3.1.0:exec)
APP_NAME=$(mvn -q -Dexec.executable=echo -Dexec.args='${project.name}' --non-recursive org.codehaus.mojo:exec-maven-plugin:3.1.0:exec)
APP_NAME=${APP_NAME:-YouTubeDownloader}
DIST_ROOT="dist"
mkdir -p "$DIST_ROOT"

echo "========================================="
echo "Building Windows .exe Installer..."
echo "App: $APP_NAME  Version: $VERSION"
echo "========================================="

# Check if jpackage is available
if ! command -v jpackage >/dev/null 2>&1; then
    echo "Error: jpackage not found! Run this on Windows with JDK 21 that includes jpackage."
    exit 1
fi

# Build the Windows runtime image
echo "1. Building Windows runtime image..."
mvn -q clean compile -Pwindows
mvn -q -Pwindows,jlink clean javafx:jlink

# Verify runtime image was created
if [ ! -d "target/image" ]; then
    echo "Error: Runtime image was not created!"
    exit 1
fi

# Create Windows launcher
echo "2. Creating Windows launcher (.bat)..."
cat > target/image/bin/YouTubeDownloader.bat << 'EOF'
@echo off
cd /d "%~dp0"
start "" "java.exe" -Dprism.order=d3d -m youtubedownloader/com.snake.youtubedownloader.App %*
EOF

# Create .exe installer using jpackage
echo "3. Creating .exe installer with jpackage..."
JPKG_OUT="$DIST_ROOT/${APP_NAME}-${VERSION}.exe"

jpackage \
    --name "$APP_NAME" \
    --app-image "target/image" \
    --type exe \
    --app-version "$VERSION" \
    --vendor "Snake Software" \
    --description "YouTube Downloader - Download videos from YouTube using yt-dlp" \
    --copyright "Copyright © 2025 Snake Software" \
    --win-shortcut \
    --win-menu \
    --win-menu-group "Multimedia" \
    --win-dir-chooser \
    --install-dir "$APP_NAME" \
    --java-options "-Dprism.order=d3d" \
    --dest "$DIST_ROOT" \
    --verbose

# Check if .exe was created
if [ -f "$JPKG_OUT" ]; then
    echo ""
    echo "SUCCESS! Windows .exe installer created: $JPKG_OUT"
else
    echo "Error: .exe file was not created! Check jpackage output above."
    exit 1
fi
