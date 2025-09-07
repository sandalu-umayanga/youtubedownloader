# YouTube Downloader

A modern JavaFX-based YouTube downloader with MP3 audio extraction capabilities and a simple GUI that delegates downloading to yt-dlp.

- Cross-platform: Linux and Windows (macOS profile available)
- Self-contained runtime image via jlink (no separate JRE needed)
- **Video downloads** in multiple formats and qualities
- **MP3 Audio downloads** with quality selection and format options
- **FFmpeg integration** for high-quality audio conversion
- Format listing, progress logs, and basic controls
- Automatic metadata and thumbnail embedding for audio files

## ✨ Features

### Video Downloads
- Download YouTube videos in various formats and qualities
- Browse available formats before downloading
- Choose specific video quality (720p, 1080p, etc.)
- Progress tracking and download controls (pause/resume/cancel)

### Audio Downloads 🎵
- **Extract audio** from YouTube videos in high quality
- **Multiple formats**: MP3, M4A, WAV, FLAC, AAC, OGG, OPUS
- **Quality options**: Best, 320k, 256k, 192k, 128k, 96k, 64k bitrates
- **Automatic metadata**: Embeds video title, artist, and other metadata
- **Thumbnail embedding**: Includes video thumbnail as album art
- **One-click download**: Separate audio download section with format and quality dropdowns
- **FFmpeg powered**: Uses FFmpeg for professional audio conversion

### General Features
- Cross-platform support (Windows, Linux, macOS)
- Modern JavaFX interface
- Real-time download progress logs
- Folder selection for downloads
- Self-contained application (includes Java runtime)
- Silent launcher (no command prompt windows)
- Real-time download progress logs
- Folder selection for downloads
- Self-contained application (includes Java runtime)

## 🚀 Quick Installation for Users

### Windows Installation

1. **Download or Clone** this repository:
   ```powershell
   git clone https://github.com/sandalu-umayanga/youtubedownloader.git
   cd youtubedownloader
   ```

2. **Build the application** (requires Java 21 and Maven):
   ```powershell
   mvn package javafx:jlink
   ```

3. **Install dependencies**:
   - **yt-dlp**: 
     ```powershell
     pip install yt-dlp
     ```
     Or download from: https://github.com/yt-dlp/yt-dlp/releases
   
   - **FFmpeg** (for audio conversion):
     ```powershell
     winget install Gyan.FFmpeg
     ```
     Or download from: https://ffmpeg.org/download.html

4. **Install to your system**:
   - Right-click PowerShell and "Run as Administrator", then:
     ```powershell
     .\install.ps1
     ```

5. **Launch the application**:
   - Use the Desktop shortcut "YouTube Downloader (Working)" (recommended)
   - Or run `YouTubeDownloader-Working.bat` from the project folder

### Linux Installation

1. **Download or Clone** this repository:
   ```bash
   git clone https://github.com/sandalu-umayanga/youtubedownloader.git
   cd youtubedownloader
   ```

2. **Build and Install**:
   ```bash
   ./build-package.sh
   sudo ./install.sh
   ```

3. **Install dependencies**:
   ```bash
   # Install yt-dlp
   pip install yt-dlp
   
   # Install FFmpeg (Ubuntu/Debian)
   sudo apt update && sudo apt install ffmpeg
   
   # Install FFmpeg (Fedora/RHEL)
   sudo dnf install ffmpeg
   
   # Install FFmpeg (Arch Linux)
   sudo pacman -S ffmpeg
   ```

### Uninstallation

- **Windows**: Run `uninstall.ps1` as Administrator
- **Linux**: Run `sudo ./uninstall.sh`

### Windows Notes

The application includes a special "Working" launcher (`YouTubeDownloader-Working.bat`) that:
- Launches silently without command prompt windows
- Uses the installed application in `C:\Program Files\YouTubeDownloader`
- Includes all MP3 audio download functionality
- Provides user-friendly error messages and guidance

### Using the Application

1. **Launch** using the desktop shortcut "YouTube Downloader (Working)"
2. **Paste a YouTube URL** in the URL field
3. **For Video Downloads**:
   - Click "Load formats" to see available video qualities
   - Select your preferred format and quality
   - Click "Download" to start
4. **For Audio Downloads**:
   - Select audio format (MP3, M4A, WAV, etc.) from the dropdown
   - Choose quality (Best, 320k, 256k, etc.)
   - Click "Download Audio" to extract audio only
5. **Choose download location** using the "Browse..." button
6. **Monitor progress** in the log area

### Requirements

- **yt-dlp**: For downloading videos and extracting audio
- **FFmpeg**: For high-quality audio conversion and format support
- **Java 21**: Included in the self-contained application

## 🛠️ Developer Instructions

### Requirements

- Java 21 (JDK)
- Maven 3.8+
- yt-dlp installed on the machine for actual downloads
- FFmpeg for audio conversion functionality

### Quick start

```bash
mvn clean compile
mvn javafx:run
```

### Build a self-contained image

```bash
mvn package javafx:jlink
./target/image/bin/java -m youtubedownloader/com.snake.youtubedownloader.App
```

### Testing MP3 functionality

To test the audio download features:
1. Ensure FFmpeg is installed and accessible in PATH
2. Build and run the application
3. Paste a YouTube URL and test both video and audio download modes

### Project Structure

- `src/main/java/com/snake/youtubedownloader/App.java` - Main JavaFX application with MP3 functionality
- `YouTubeDownloader-Working.bat` - Windows launcher script
- `install.ps1` / `install.sh` - Installation scripts
- `target/image/` - Generated self-contained application

### Package for Linux

- One-shot helper:

```bash
./build-package.sh
```

Artifacts will be placed under `dist/`, e.g. `dist/YouTubeDownloader-<version>-linux.tar.gz`.

### Windows packaging

- To produce a Windows installation:

```powershell
# Build the application
mvn package javafx:jlink

# Install to system (run as Administrator)
.\install.ps1
```

The application will be installed to `C:\Program Files\YouTubeDownloader` with a desktop shortcut.

## Where are my builds?

- Development image: `target/image/`
- Installed application (Windows): `C:\Program Files\YouTubeDownloader/`
- Linux package(s): `dist/YouTubeDownloader-<version>-linux/` and `.tar.gz`
- Desktop shortcut: `YouTube Downloader (Working).lnk`

## Docs

- `docs/OVERVIEW.md` – architecture and layout
- `docs/BUILDING.md` – full build instructions
- `docs/PACKAGING.md` – Linux/Windows packaging, installers

## License

MIT. See LICENSE for details.

## Contributing

See CONTRIBUTING.md. Bug reports and PRs welcome.
