# Installation Guide

This guide provides step-by-step instructions for installing YouTube Downloader on your system.

## 📋 Prerequisites

- **Java 21 JDK** (for building)
- **Maven 3.8+** (for building)
- **Git** (for cloning the repository)
- **Python with pip** (for installing yt-dlp)

## 🪟 Windows Installation

### Step 1: Install Prerequisites

1. **Install Java 21 JDK**:
   - Download from [Oracle](https://www.oracle.com/java/technologies/downloads/) or [OpenJDK](https://openjdk.org/projects/jdk/21/)
   - Verify installation: `java -version` should show Java 21

2. **Install Maven**:
   - Download from [Apache Maven](https://maven.apache.org/download.cgi)
   - Add to PATH and verify: `mvn -version`

3. **Install Git**:
   - Download from [Git for Windows](https://git-scm.com/download/win)

4. **Install Python** (if not already installed):
   - Download from [Python.org](https://www.python.org/downloads/)
   - Make sure pip is included

### Step 2: Clone and Build

1. **Open PowerShell** and clone the repository:
   ```powershell
   git clone https://github.com/sandalu-umayanga/youtubedownloader.git
   cd youtubedownloader
   ```

2. **Build the application**:
   ```powershell
   mvn -Pjlink clean javafx:jlink
   ```
   This creates a self-contained runtime in `target/image/`

### Step 3: Install to System

**Option A: Using PowerShell (Recommended)**
1. **Open PowerShell as Administrator**:
   - Right-click on PowerShell icon
   - Select "Run as Administrator"

2. **Navigate to project directory and run installer**:
   ```powershell
   cd path\to\youtubedownloader
   .\install.ps1
   ```

**Option B: Using Batch File**
1. **Double-click** `YouTubeDownloader-installer.bat` in the project folder
2. **Accept** any Administrator privilege prompts

### Step 4: Install yt-dlp

Install the video downloader backend:
```powershell
pip install yt-dlp
```

### Step 5: Launch Application

You now have several ways to launch YouTube Downloader:

1. **Desktop Shortcut** (Recommended):
   - "YouTube Downloader (No CMD)" - Launches without command prompt window

2. **Start Menu**:
   - Search for "YouTube Downloader"

3. **Command Line**:
   ```powershell
   YouTubeDownloader.bat
   ```

4. **Direct Path**:
   ```powershell
   & "C:\Program Files\YouTubeDownloader\YouTubeDownloader.bat"
   ```

## 🐧 Linux Installation

### Step 1: Install Prerequisites

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install openjdk-21-jdk maven git python3-pip
```

**Fedora/RHEL:**
```bash
sudo dnf install java-21-openjdk-devel maven git python3-pip
```

**Arch Linux:**
```bash
sudo pacman -S jdk21-openjdk maven git python-pip
```

### Step 2: Clone and Build

```bash
git clone https://github.com/sandalu-umayanga/youtubedownloader.git
cd youtubedownloader
./build-package.sh
```

### Step 3: Install to System

```bash
sudo ./install.sh
```

This installs the application to `/opt/YouTubeDownloader/` and creates shortcuts.

### Step 4: Install yt-dlp

```bash
pip install yt-dlp
# OR
pip3 install yt-dlp
```

### Step 5: Launch Application

- Use your desktop environment's application menu
- Or run from terminal: `youtubedownloader`

## 🔧 Troubleshooting

### Windows Issues

**"Missing Shortcut" Error:**
- The shortcut path is incorrect. Try using the "YouTube Downloader (No CMD)" shortcut instead.

**"Cannot find bin\java.exe":**
- The installation didn't complete properly. Re-run the installer as Administrator.

**Command Prompt Window Appears:**
- Use the "YouTube Downloader (No CMD)" shortcut to avoid this.

**Permission Denied:**
- Make sure you're running the installer as Administrator.

### Linux Issues

**"Command not found" after installation:**
- Make sure `/opt/YouTubeDownloader/bin` is in your PATH, or restart your session.

**Permission errors during installation:**
- Make sure you're using `sudo ./install.sh`.

### General Issues

**yt-dlp not found:**
- Make sure yt-dlp is installed: `yt-dlp --version`
- Install with: `pip install yt-dlp`

**Java version issues:**
- Verify Java 21 is installed: `java -version`
- Make sure JAVA_HOME points to Java 21

**Maven build fails:**
- Check internet connection (Maven downloads dependencies)
- Try: `mvn clean install -U` to force update dependencies

## 🗑️ Uninstallation

### Windows
1. **Open PowerShell as Administrator**
2. **Navigate to project directory**:
   ```powershell
   cd path\to\youtubedownloader
   .\uninstall.ps1
   ```

### Linux
```bash
sudo ./uninstall.sh
```

## 📞 Support

If you encounter issues:

1. **Check the troubleshooting section above**
2. **Verify all prerequisites are installed**
3. **Check the logs** in the application for error messages
4. **Open an issue** on GitHub with:
   - Your operating system and version
   - Java version (`java -version`)
   - Maven version (`mvn -version`)
   - Error messages or screenshots
   - Steps to reproduce the problem

## 🔄 Updating

To update to a newer version:

1. **Pull the latest changes**:
   ```bash
   git pull origin main
   ```

2. **Rebuild and reinstall**:
   - **Windows**: Run steps 2-3 from the installation guide
   - **Linux**: Run `./build-package.sh` and `sudo ./install.sh`

The installer will overwrite the previous installation.
