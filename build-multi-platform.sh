#!/bin/bash
# Multi-Platform Build and Package Distribution Script

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT_DIR"

PLATFORMS=("linux" "windows")
VERSION=$(mvn -q -Dexec.executable=echo -Dexec.args='${project.version}' --non-recursive org.codehaus.mojo:exec-maven-plugin:3.1.0:exec)
APP_NAME=$(mvn -q -Dexec.executable=echo -Dexec.args='${project.name}' --non-recursive org.codehaus.mojo:exec-maven-plugin:3.1.0:exec)
APP_NAME=${APP_NAME:-YouTubeDownloader}
DIST_ROOT="dist"
mkdir -p "$DIST_ROOT"

# Function to build for a specific platform
build_platform() {
    local platform=$1
    echo "========================================="
    echo "Building for $platform..."
    echo "App: $APP_NAME  Version: $VERSION"
    echo "========================================="

    # Clean and build the project with platform-specific profile
    echo "1. Building the application for $platform..."
    mvn -q clean compile -P"$platform"

    # Create runtime image with JavaFX bundled
    echo "2. Creating runtime image for $platform..."
    mvn -q -P"$platform",jlink clean javafx:jlink

    # Verify the runtime image was created
    if [ ! -d "target/image" ]; then
        echo "Error: Runtime image was not created successfully for $platform"
        return 1
    fi

    # Create platform-specific launcher
    echo "3. Creating $platform launcher..."
    if [ "$platform" = "windows" ]; then
        # Create Windows batch launchers
        cat > target/image/bin/YouTubeDownloader.bat << 'EOF'
@echo off
cd /d "%~dp0"
start "" "java.exe" -Dprism.order=d3d -m youtubedownloader/com.snake.youtubedownloader.App %*
EOF
        cat > target/image/bin/YouTubeDownloader-console.bat << 'EOF'
@echo off
cd /d "%~dp0"
"java.exe" -Dprism.order=d3d -m youtubedownloader/com.snake.youtubedownloader.App %*
EOF
    else
        # Create Linux bash launcher
        cat > target/image/bin/YouTubeDownloader << 'EOF'
#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$DIR/java" -Dprism.order=es2 -m youtubedownloader/com.snake.youtubedownloader.App "$@"
EOF
        chmod +x target/image/bin/YouTubeDownloader
    fi

    # Create distribution directory
    echo "4. Creating distribution package for $platform..."
    local DIST_DIR="$DIST_ROOT/${APP_NAME}-${VERSION}-${platform}"
    rm -rf "$DIST_DIR"
    mkdir -p "$DIST_DIR"

    # Copy runtime image and platform-specific files
    cp -r target/image "$DIST_DIR/"
    if [ "$platform" = "windows" ]; then
        cp install.ps1 "$DIST_DIR/" || true
        cp uninstall.ps1 "$DIST_DIR/" || true
        cp README.md "$DIST_DIR/README.txt" || true
    else
        cp install.sh "$DIST_DIR/"
        cp uninstall.sh "$DIST_DIR/"
        cp README.md "$DIST_DIR/"
    fi

    # Create archive
    echo "5. Creating distribution archive for $platform..."
    if [ "$platform" = "windows" ]; then
        ( cd "$DIST_ROOT" && zip -r "${APP_NAME}-${VERSION}-windows.zip" "${APP_NAME}-${VERSION}-windows" )
        echo "Created: $DIST_ROOT/${APP_NAME}-${VERSION}-windows.zip"
        # Skip jpackage .exe creation on non-Windows hosts to avoid failures
        case "$(uname -s | tr '[:upper:]' '[:lower:]')" in
            msys*|cygwin*|mingw*|windows*)
                if command -v jpackage >/dev/null 2>&1; then
                    jpackage \
                        --name "$APP_NAME" \
                        --app-image "target/image" \
                        --type exe \
                        --app-version "$VERSION" \
                        --vendor "Snake Software" \
                        --description "YouTube Downloader - Download videos from YouTube using yt-dlp" \
                        --win-shortcut \
                        --win-menu \
                        --win-menu-group "Multimedia" \
                        --win-dir-chooser \
                        --install-dir "$APP_NAME" \
                        --java-options "-Dprism.order=d3d" \
                        --dest "$DIST_ROOT" \
                        --verbose || true
                fi
                ;;
            *)
                echo "Skipping jpackage .exe on non-Windows host."
                ;;
        esac
    else
        ( cd "$DIST_ROOT" && tar -czf "${APP_NAME}-${VERSION}-linux.tar.gz" "${APP_NAME}-${VERSION}-linux" )
        echo "Created: $DIST_ROOT/${APP_NAME}-${VERSION}-linux.tar.gz"
        # Optional: create .deb if available
        if command -v jpackage >/dev/null 2>&1; then
            jpackage \
                --name "youtubedownloader" \
                --app-image "target/image" \
                --type deb \
                --app-version "$VERSION" \
                --vendor "Snake Software" \
                --description "YouTube Downloader - Download videos from YouTube using yt-dlp" \
                --linux-shortcut \
                --linux-menu-group "AudioVideo" \
                --install-dir "/opt/youtubedownloader" \
                --java-options "-Dprism.order=es2" \
                --dest "$DIST_ROOT" \
                --verbose || true
        fi
    fi

    echo "✅ $platform build completed successfully!"
    echo ""
}

# Main build process
echo "Building $APP_NAME Distribution Packages..."

# Check if specific platform was requested
if [ $# -eq 1 ]; then
    PLATFORM=$1
    if [[ " ${PLATFORMS[@]} " =~ " ${PLATFORM} " ]]; then
        build_platform "$PLATFORM"
    else
        echo "Error: Unsupported platform '$PLATFORM'"
        echo "Supported platforms: ${PLATFORMS[*]}"
        exit 1
    fi
else
    # Build for all platforms
    for platform in "${PLATFORMS[@]}"; do
        build_platform "$platform"
    done
fi

echo "========================================="
echo "All builds completed successfully!"
echo "Artifacts under: $DIST_ROOT"
echo "========================================="
