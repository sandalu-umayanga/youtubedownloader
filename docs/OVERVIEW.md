# YouTube Downloader — Overview

A modern JavaFX desktop app for downloading videos using yt-dlp. It ships as a self-contained runtime image (via jlink) and supports Linux and Windows packaging.

Highlights:
- Java 21, JavaFX 21.0.2 (controls, fxml)
- GUI for URL input, format listing, and download control (pause/resume/cancel)
- Uses yt-dlp on the host system
- Packaged via JavaFX Maven Plugin (jlink) and shell/PowerShell helpers

Repository layout:
- src/main/java … Java sources (module: youtubedownloader)
- src/main/resources … resources (currently empty)
- scripts (root) … helper build/package scripts
- target/image … jlink runtime image output (temporary)
- docs … project documentation


