# YouTube Downloader

A modern JavaFX-based YouTube downloader with a simple GUI that delegates downloading to yt-dlp.

- Cross-platform: Linux and Windows (macOS profile available)
- Self-contained runtime image via jlink (no separate JRE needed)
- Format listing, progress logs, and basic controls

## 🚀 Quick Installation for Users

### Windows Installation

1. **Download or Clone** this repository:
   ```powershell
   git clone https://github.com/sandalu-umayanga/youtubedownloader.git
   cd youtubedownloader
   ```

2. **Build the application** (requires Java 21 and Maven):
   ```powershell
   mvn -Pjlink clean javafx:jlink
   ```

3. **Install to your system**:
   - **Option A**: Right-click PowerShell and "Run as Administrator", then:
     ```powershell
     .\install.ps1
     ```
   - **Option B**: Double-click `YouTubeDownloader-installer.bat`

4. **Install yt-dlp** for downloading functionality:
   ```powershell
   pip install yt-dlp
   ```
   Or download from: https://github.com/yt-dlp/yt-dlp/releases

5. **Launch the application**:
   - Use the Desktop shortcut "YouTube Downloader (No CMD)" (recommended - no command prompt window)
   - Or run from Start Menu
   - Or run `YouTubeDownloader.bat` from command line

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

3. **Install yt-dlp**:
   ```bash
   pip install yt-dlp
   ```

### Uninstallation

- **Windows**: Run `uninstall.ps1` as Administrator
- **Linux**: Run `sudo ./uninstall.sh`

### Windows Notes

The installer creates a special "No CMD" shortcut that launches the application using `javaw.exe` instead of `java.exe`, eliminating the background command prompt window that would otherwise appear.

## 🛠️ Developer Instructions

### Requirements

- Java 21 (JDK)
- Maven 3.8+
- yt-dlp installed on the machine for actual downloads

### Quick start

```bash
mvn clean compile
mvn javafx:run
```

### Build a self-contained image (Linux default)

```bash
mvn -Pjlink clean javafx:jlink
./target/image/bin/java -m youtubedownloader/com.snake.youtubedownloader.App
```

### Package for Linux

- One-shot helper:

```bash
./build-package.sh
```

Artifacts will be placed under `dist/`, e.g. `dist/YouTubeDownloader-<version>-linux.tar.gz`.

### Windows packaging

- To produce a Windows .exe, run on Windows with JDK 21 that includes jpackage:

```powershell
# On Windows PowerShell (Developer Command Prompt also works)
mvn -Pwindows -DskipTests clean compile
mvn -Pwindows,jlink clean javafx:jlink
# Option A: Create portable ZIP
./create-windows-exe.sh
# Option B: Create native .exe installer (requires jpackage on Windows)
./build-exe.sh
```

Outputs will be created in the project root or `dist/` depending on the script; see `docs/PACKAGING.md` for details.

## Where are my builds?

- Development image: `target/image`
- Linux package(s): `dist/YouTubeDownloader-<version>-linux/` and `.tar.gz`
- Windows portable: `<name>-windows-portable.zip`
- Windows installer (.exe): `YouTubeDownloader-<version>.exe` (when built on Windows)

## Docs

- `docs/OVERVIEW.md` – architecture and layout
- `docs/BUILDING.md` – full build instructions
- `docs/PACKAGING.md` – Linux/Windows packaging, installers

## License

MIT. See LICENSE for details.

## Contributing

See CONTRIBUTING.md. Bug reports and PRs welcome.
