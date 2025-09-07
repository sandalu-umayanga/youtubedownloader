# Changelog

All notable changes to YouTube Downloader will be documented in this file.

## [1.1.0] - 2025-09-07

### Added
- **MP3 Audio Download Functionality** 🎵
  - Extract audio from YouTube videos in multiple formats
  - Support for MP3, M4A, WAV, FLAC, AAC, OGG, and OPUS formats
  - Quality selection: Best, 320k, 256k, 192k, 128k, 96k, 64k bitrates
  - Automatic metadata embedding (title, artist, album info)
  - Thumbnail embedding as album art
  - Dedicated audio download section in UI with format and quality dropdowns

- **FFmpeg Integration**
  - Professional-grade audio conversion
  - Format validation and error handling
  - Automatic FFmpeg availability checking
  - User-friendly error messages when FFmpeg is missing

- **Enhanced User Interface**
  - Separate audio download controls
  - Audio format dropdown (MP3, M4A, WAV, FLAC, AAC, OGG, OPUS)
  - Audio quality dropdown with bitrate options
  - "Download Audio" button for one-click audio extraction
  - Improved error handling and user feedback

- **Silent Launcher System**
  - `YouTubeDownloader-Working.bat` for Windows
  - No command prompt windows during launch
  - Desktop shortcut creation
  - Proper working directory handling

### Improved
- **Application Stability**
  - Enhanced JavaFX stage visibility fixes
  - Better error handling with try-catch blocks
  - Improved process management
  - More reliable window display

- **Installation Process**
  - Streamlined Windows installation via `install.ps1`
  - Automatic desktop shortcut creation
  - Simplified dependency management
  - Better user guidance during setup

- **Documentation**
  - Updated README.md with MP3 features
  - Added FEATURES.md with detailed capability overview
  - Enhanced CONTRIBUTING.md with testing guidelines
  - Improved installation instructions

### Fixed
- **Window Visibility Issues**
  - JavaFX application window now appears reliably
  - Added `setAlwaysOnTop()`, `toFront()`, and `requestFocus()` calls
  - Implemented `Platform.runLater()` for post-show window management
  - Resolved "QuantumRenderer: shutdown" issues

- **Command Window Problems**
  - Eliminated command prompt windows during application launch
  - Used `javaw.exe` instead of `java.exe` for silent execution
  - Created VBS and PowerShell alternatives for different launch methods

- **Build System**
  - Improved Maven jlink integration
  - Better handling of file locks during rebuilds
  - Streamlined package and install process

### Technical Changes
- **Dependencies**
  - Added FFmpeg requirement for audio processing
  - Enhanced yt-dlp integration with audio extraction flags
  - Improved error checking for missing dependencies

- **Code Structure**
  - Enhanced `App.java` with audio download methods
  - Added `startAudioDownload()` method with format and quality handling
  - Implemented `checkFfmpegAvailable()` for dependency validation
  - Added comprehensive exception handling in main method

- **Platform Support**
  - Improved Windows 10/11 compatibility
  - Better Linux distribution support
  - Enhanced cross-platform file handling

## [1.0.0] - Previous Release

### Initial Features
- JavaFX-based GUI for YouTube video downloads
- yt-dlp integration for video downloading
- Cross-platform support (Windows, Linux, macOS)
- Self-contained application with jlink
- Format selection and quality options
- Progress tracking and download controls
- Basic installation and packaging scripts

---

## Installation Notes

### For Windows Users
1. Clone the repository
2. Run `mvn package javafx:jlink`
3. Run `install.ps1` as Administrator
4. Use "YouTube Downloader (Working)" desktop shortcut

### For Linux Users
1. Clone the repository
2. Run `./build-package.sh`
3. Run `sudo ./install.sh`
4. Install yt-dlp and FFmpeg via package manager

### Dependencies Required
- **yt-dlp**: `pip install yt-dlp`
- **FFmpeg**: Platform-specific installation
  - Windows: `winget install Gyan.FFmpeg`
  - Ubuntu/Debian: `sudo apt install ffmpeg`
  - Fedora: `sudo dnf install ffmpeg`
  - Arch: `sudo pacman -S ffmpeg`
