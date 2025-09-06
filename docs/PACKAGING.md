# Packaging and Distribution

This project ships platform-specific packages created from a jlink app image.

Linux
- Build runtime image:
```
mvn -Pjlink clean javafx:jlink
```
- Create package with helper script:
```
./build-package.sh
```
Outputs
- dist/YouTubeDownloader-<version>-linux/ (folder)
- dist/YouTubeDownloader-<version>-linux.tar.gz (archive)
- Optional: jpackage-based .deb if you use build-multi-platform.sh and have jpackage.

Install
```
cd dist/YouTubeDownloader-<version>-linux
sudo ./install.sh
```
Uninstall
```
sudo ./uninstall.sh
```

Windows
Prereqs (on Windows)
- JDK 21 with jpackage available in PATH
- Git Bash for running .sh scripts (or adapt commands)

Build runtime image
```
mvn -Pwindows -DskipTests clean compile
mvn -Pwindows,jlink clean javafx:jlink
```
Portable ZIP and installer options
- Portable ZIP + installer batch:
```
./create-windows-exe.sh
```
- Native .exe installer (jpackage):
```
./build-exe.sh
```
Outputs
- <AppName>-<version>-windows-portable.zip (portable)
- YouTubeDownloader-<version>.exe (native installer)

Notes
- For .exe creation you must run on Windows; cross-compiling installers from Linux is not supported by jpackage.
- The app depends on yt-dlp being installed on the user system.

