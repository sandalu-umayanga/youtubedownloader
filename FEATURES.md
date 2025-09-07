# YouTube Downloader - Features

## 🎥 Video Downloads

### Supported Formats
- MP4 (various qualities: 1080p, 720p, 480p, 360p, 240p, 144p)
- WEBM (high-quality alternative format)
- AVI, MKV, and other formats supported by yt-dlp

### Video Features
- **Quality Selection**: Choose from available video qualities
- **Format Preview**: Load and preview all available formats before downloading
- **Progress Tracking**: Real-time download progress with detailed logs
- **Download Controls**: Pause, resume, and cancel downloads (Linux only)
- **Metadata Preservation**: Keeps video title, description, and other metadata

## 🎵 Audio Downloads (MP3 & More)

### Supported Audio Formats
- **MP3** - Most compatible, good compression
- **M4A** - Apple's format, excellent quality
- **WAV** - Uncompressed, highest quality
- **FLAC** - Lossless compression, audiophile choice
- **AAC** - Advanced Audio Codec, good quality
- **OGG** - Open source, good compression
- **OPUS** - Modern codec, excellent for streaming

### Audio Quality Options
- **Best** - Highest available quality from source
- **320k** - High quality (320 kbps bitrate)
- **256k** - Very good quality (256 kbps bitrate)
- **192k** - Good quality (192 kbps bitrate)
- **128k** - Standard quality (128 kbps bitrate)
- **96k** - Lower quality, smaller files
- **64k** - Minimum quality, very small files

### Audio Features
- **One-Click Download**: Separate audio download section
- **Automatic Metadata**: Embeds song title, artist, album information
- **Thumbnail as Album Art**: Video thumbnail becomes the audio file's album cover
- **FFmpeg Integration**: Professional-grade audio conversion
- **Format Validation**: Checks FFmpeg availability before audio downloads
- **Quality Assurance**: Ensures best possible audio extraction from video source

## 🛠️ General Features

### User Interface
- **Modern JavaFX Design**: Clean, intuitive interface
- **Real-time Logs**: See download progress and any issues
- **Folder Selection**: Browse and choose download destination
- **URL Validation**: Checks if URL is valid before processing
- **Format Loading**: Preview available formats before downloading

### System Integration
- **Silent Launcher**: No command prompt windows on Windows
- **Desktop Shortcut**: Easy access from desktop
- **Self-contained**: Includes Java runtime, no separate installation needed
- **Cross-platform**: Works on Windows, Linux, and macOS

### Download Management
- **Custom Directory**: Choose where files are saved
- **Progress Monitoring**: Real-time progress updates
- **Error Handling**: Clear error messages and troubleshooting guidance
- **Batch Operations**: Download multiple videos by running multiple instances

## 🔧 Technical Requirements

### Required Dependencies
- **yt-dlp**: Core downloading engine
- **FFmpeg**: Audio conversion and processing
- **Java 21**: Runtime environment (included in self-contained builds)

### Supported Platforms
- **Windows 10/11**: Full support with silent launcher
- **Linux**: Ubuntu, Fedora, Arch, and other distributions
- **macOS**: Basic support (build profile available)

### Performance
- **Efficient Memory Usage**: Optimized for long downloads
- **Multi-threading**: Non-blocking UI during downloads
- **Resource Management**: Proper cleanup after downloads
- **Error Recovery**: Handles network interruptions gracefully

## 🚀 Getting Started

1. **Install Dependencies**: yt-dlp and FFmpeg
2. **Build Application**: `mvn package javafx:jlink`
3. **Install**: Run `install.ps1` (Windows) or `install.sh` (Linux)
4. **Launch**: Use desktop shortcut "YouTube Downloader (Working)"
5. **Download**: Paste URL, choose format/quality, and download!

## 💡 Tips for Best Results

### For High-Quality Audio
- Use **FLAC** or **WAV** for lossless quality
- Choose **Best** quality setting for maximum bitrate
- Ensure good internet connection for large file downloads

### For Compatibility
- Use **MP3** format for maximum device compatibility
- **256k** or **320k** quality provides excellent balance of quality and file size
- **M4A** works well for Apple devices and iTunes

### For Storage Efficiency
- **AAC** or **OGG** provide good quality with smaller file sizes
- **128k** quality is sufficient for casual listening
- **OPUS** offers the best compression for streaming/sharing
