@echo off
title YouTube Downloader Launcher
echo Starting YouTube Downloader from installed location...
echo.
echo If window doesn't appear, check taskbar or try Alt+Tab
echo.
cd /d "C:\Program Files\YouTubeDownloader"
start "YouTube Downloader" "bin\javaw.exe" -m youtubedownloader/com.snake.youtubedownloader.App
timeout /t 5 /nobreak >nul
exit
