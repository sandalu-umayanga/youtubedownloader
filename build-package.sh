#!/bin/bash
# Build and Package Distribution Script (Linux)

set -euo pipefail

# Resolve project root
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT_DIR"

# Derive metadata from Maven POM
VERSION=$(mvn -q -Dexec.executable=echo -Dexec.args='${project.version}' --non-recursive org.codehaus.mojo:exec-maven-plugin:3.1.0:exec)
APP_NAME=$(mvn -q -Dexec.executable=echo -Dexec.args='${project.name}' --non-recursive org.codehaus.mojo:exec-maven-plugin:3.1.0:exec)
ARTIFACT_ID=$(mvn -q -Dexec.executable=echo -Dexec.args='${project.artifactId}' --non-recursive org.codehaus.mojo:exec-maven-plugin:3.1.0:exec)
APP_NAME=${APP_NAME:-YouTubeDownloader}

DIST_ROOT="dist"
DIST_DIR="$DIST_ROOT/${APP_NAME}-${VERSION}-linux"

mkdir -p "$DIST_ROOT"

echo "Building $APP_NAME $VERSION Linux Distribution Package..."

# Clean and build the project
echo "1. Building the application..."
mvn -q clean compile

# Create runtime image with JavaFX bundled
echo "2. Creating runtime image..."
mvn -q -Pjlink clean javafx:jlink

# Verify the runtime image was created
if [ ! -d "target/image" ]; then
    echo "Error: Runtime image was not created successfully"
    exit 1
fi

# Ensure launcher script exists and is executable
if [ ! -f "target/image/bin/YouTubeDownloader" ]; then
    echo "3. Creating launcher script..."
    cat > target/image/bin/YouTubeDownloader << 'EOF'
#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$DIR/java" -Dprism.order=es2 -m youtubedownloader/com.snake.youtubedownloader.App "$@"
EOF
    chmod +x target/image/bin/YouTubeDownloader
fi

# Create distribution directory
echo "4. Creating distribution package directory..."
rm -rf "$DIST_DIR"
mkdir -p "$DIST_DIR"

# Copy all necessary files
cp -r target/image "$DIST_DIR/"
cp install.sh "$DIST_DIR/"
cp uninstall.sh "$DIST_DIR/"
cp README.md "$DIST_DIR/"

# Create archive
echo "5. Creating distribution archive..."
( cd "$DIST_ROOT" && tar -czf "${APP_NAME}-${VERSION}-linux.tar.gz" "${APP_NAME}-${VERSION}-linux" )

echo ""
echo "✅ Distribution package created successfully!"
echo ""
echo "Output artifacts:"
echo "- $DIST_ROOT/${APP_NAME}-${VERSION}-linux.tar.gz"
echo "- $DIST_DIR/ (extracted package directory)"
echo ""
echo "To install:"
echo "1. Extract: tar -xzf $DIST_ROOT/${APP_NAME}-${VERSION}-linux.tar.gz"
echo "2. Install: cd ${APP_NAME}-${VERSION}-linux && sudo ./install.sh"
echo ""
echo "To test without installing:"
echo "cd ${APP_NAME}-${VERSION}-linux && ./image/bin/YouTubeDownloader"
