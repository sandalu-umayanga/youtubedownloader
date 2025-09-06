@echo off
cd /d "C:\Program Files\YouTubeDownloader"
start /min "" "bin\javaw.exe" -Dprism.order=d3d -m youtubedownloader/com.snake.youtubedownloader.App
