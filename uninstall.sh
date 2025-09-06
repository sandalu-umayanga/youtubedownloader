#!/bin/bash
# YouTube Downloader Uninstallation Script

set -e

APP_NAME="YouTubeDownloader"
INSTALL_DIR="/opt/youtubedownloader"
DESKTOP_FILE="/usr/share/applications/youtubedownloader.desktop"
ICON_DIR="/usr/share/icons/hicolor/48x48/apps"

echo "Uninstalling YouTube Downloader..."

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)"
   exit 1
fi

# Remove symlink
echo "Removing system launcher..."
rm -f "/usr/local/bin/youtubedownloader"

# Remove desktop entry
echo "Removing desktop entry..."
rm -f "$DESKTOP_FILE"

# Remove icon
echo "Removing application icon..."
rm -f "$ICON_DIR/youtubedownloader.png"

# Remove installation directory
echo "Removing application files..."
rm -rf "$INSTALL_DIR"

# Update desktop database
if command -v update-desktop-database &> /dev/null; then
    echo "Updating desktop database..."
    update-desktop-database /usr/share/applications
fi

echo ""
echo "YouTube Downloader has been completely uninstalled."
echo ""
