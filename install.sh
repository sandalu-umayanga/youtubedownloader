#!/bin/bash
# YouTube Downloader Installation Script

set -euo pipefail

APP_NAME="YouTubeDownloader"
INSTALL_DIR="/opt/youtubedownloader"
DESKTOP_FILE="/usr/share/applications/youtubedownloader.desktop"
ICON_DIR="/usr/share/icons/hicolor/48x48/apps"

echo "Installing $APP_NAME..."

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)"
   exit 1
fi

# Determine source app-image directory (supports dev and packaged layouts)
SRC_IMAGE=""
if [ -d "image" ]; then
  SRC_IMAGE="image"
elif [ -d "target/image" ]; then
  SRC_IMAGE="target/image"
else
  echo "Error: Could not find application image. Looked for ./image and ./target/image"
  exit 1
fi

# Create installation directory
echo "Creating installation directory: $INSTALL_DIR"
mkdir -p "$INSTALL_DIR"

# Copy runtime image
echo "Copying application files from $SRC_IMAGE..."
cp -r "$SRC_IMAGE"/* "$INSTALL_DIR/"

# Create symlink in /usr/local/bin for easy access
echo "Creating system-wide launcher..."
ln -sf "$INSTALL_DIR/bin/YouTubeDownloader" "/usr/local/bin/youtubedownloader"

# Create desktop entry
echo "Creating desktop entry..."
mkdir -p "/usr/share/applications"
cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=YouTube Downloader
Comment=Download videos from YouTube using yt-dlp
Exec=$INSTALL_DIR/bin/YouTubeDownloader
Icon=youtubedownloader
Terminal=false
Categories=AudioVideo;Video;Network;
StartupWMClass=YouTubeDownloader
EOF

# Create a simple placeholder icon if none exists
echo "Creating application icon placeholder..."
mkdir -p "$ICON_DIR"
if [ ! -f "$ICON_DIR/youtubedownloader.png" ]; then
  printf '\x89PNG\r\n\x1a\n' > "$ICON_DIR/youtubedownloader.png" || true
fi

# Set permissions
echo "Setting permissions..."
chmod +x "$INSTALL_DIR/bin/YouTubeDownloader" || true
chmod 644 "$DESKTOP_FILE"

# Update desktop database
if command -v update-desktop-database &> /dev/null; then
    echo "Updating desktop database..."
    update-desktop-database /usr/share/applications || true
fi

echo ""
echo "Installation completed successfully!"
echo ""
echo "You can now:"
echo "1. Run from terminal: youtubedownloader"
echo "2. Run from desktop: Search for 'YouTube Downloader' in your applications"
echo "3. Run directly: $INSTALL_DIR/bin/YouTubeDownloader"
echo ""
echo "Note: Make sure yt-dlp is installed for downloading functionality:"
echo "  sudo apt install yt-dlp  # or: python3 -m pip install --user yt-dlp"
