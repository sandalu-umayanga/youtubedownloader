# Contributing

Thanks for your interest in contributing to YouTube Downloader!

## Prerequisites

- Use Java 21 and Maven 3.8+
- Have yt-dlp and FFmpeg installed for testing
- Follow the existing code style and structure
- Keep changes small and focused; include tests when practical
- Run `mvn test` before submitting a PR

## Getting Started

1. **Fork the repo** and create a branch
2. **Set up your development environment**:
   ```bash
   git clone https://github.com/yourusername/youtubedownloader.git
   cd youtubedownloader
   mvn clean compile
   ```
3. **Install dependencies**:
   - `pip install yt-dlp`
   - Install FFmpeg for your platform
4. **Test the application**: `mvn javafx:run`
5. **Make your changes** and add tests under `src/test/java` when practical
6. **Test your changes**: `mvn test`
7. **Submit a Pull Request**

## Development Setup

Quick development setup:
```bash
git clone https://github.com/yourusername/youtubedownloader.git
cd youtubedownloader
mvn clean compile
mvn javafx:run
```

## Testing Audio Features

When working on MP3/audio functionality:
1. Ensure FFmpeg is properly installed and in PATH
2. Test various audio formats (MP3, M4A, FLAC, etc.)
3. Verify quality settings work correctly
4. Test metadata and thumbnail embedding
5. Check error handling when FFmpeg is missing

## Reporting Issues

When reporting bugs or requesting features, please include:
- Steps to reproduce the issue
- Error messages or logs from the application
- Environment details (OS, Java version, yt-dlp version, FFmpeg version)
- Screenshots if applicable
- Whether the issue occurs with video downloads, audio downloads, or both

## Areas for Contribution

### High Priority
- **Cross-platform testing**: Testing on different Linux distributions and macOS
- **Audio format support**: Adding new audio formats or improving existing ones
- **UI improvements**: Better progress indicators, dark theme, etc.
- **Error handling**: More graceful handling of network issues and file errors

### Medium Priority
- **Playlist support**: Download entire YouTube playlists
- **Batch downloads**: Multiple URLs at once
- **Download resumption**: Resume interrupted downloads
- **Quality presets**: Save preferred quality settings

### Low Priority
- **Video preview**: Thumbnail preview before download
- **Download history**: Keep track of downloaded files
- **Advanced metadata**: Custom tags and organization
- **Performance optimization**: Faster downloads and better resource usage

## Code Style Guidelines

- Use meaningful variable and method names
- Add comments for complex logic, especially in audio processing
- Follow JavaFX best practices for UI components
- Use proper exception handling with user-friendly error messages
- Test both video and audio download paths for any changes

## Testing Checklist

Before submitting a PR, please verify:
- [ ] Application builds successfully: `mvn package javafx:jlink`
- [ ] Video downloads work correctly
- [ ] Audio downloads work correctly with FFmpeg
- [ ] Error handling works when FFmpeg is missing
- [ ] UI remains responsive during downloads
- [ ] No command prompt windows appear on Windows (when using proper launcher)
- [ ] Tests pass: `mvn test`

