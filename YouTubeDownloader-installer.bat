@echo off
setlocal enabledelayedexpansion

echo ================================
echo YouTube Downloader Installer
echo ================================
echo.

:: Check for admin rights
net session >nul 2>&1
if !errorlevel! neq 0 (
    echo This installer requires administrator privileges.
    echo Please right-click and select "Run as administrator"
    echo.
    pause
    exit /b 1
)

:: Set installation directory
set "INSTALL_DIR=%ProgramFiles%\YouTubeDownloader"
set "START_MENU=%ProgramData%\Microsoft\Windows\Start Menu\Programs"
set "DESKTOP=%PUBLIC%\Desktop"

echo Installing YouTube Downloader...
echo Installation directory: %INSTALL_DIR%
echo.

:: Create installation directory
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

:: Copy files (assuming they're in the same directory as this installer)
echo Copying application files...
xcopy /E /I /Y "image" "%INSTALL_DIR%\image"

:: Create desktop shortcut
echo Creating desktop shortcut...
powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%DESKTOP%\YouTube Downloader.lnk'); $Shortcut.TargetPath = '%INSTALL_DIR%\image\bin\YouTubeDownloader.bat'; $Shortcut.WorkingDirectory = '%INSTALL_DIR%\image\bin'; $Shortcut.Description = 'YouTube Downloader'; $Shortcut.Save()"

:: Create Start Menu shortcut
echo Creating Start Menu shortcut...
powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%START_MENU%\YouTube Downloader.lnk'); $Shortcut.TargetPath = '%INSTALL_DIR%\image\bin\YouTubeDownloader.bat'; $Shortcut.WorkingDirectory = '%INSTALL_DIR%\image\bin'; $Shortcut.Description = 'YouTube Downloader'; $Shortcut.Save()"

:: Add to PATH
echo Adding to system PATH...
for /f "tokens=2*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PATH 2^>nul') do set "CURRENT_PATH=%%B"
echo !CURRENT_PATH! | find /i "%INSTALL_DIR%\image\bin" >nul
if !errorlevel! neq 0 (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PATH /t REG_EXPAND_SZ /d "!CURRENT_PATH!;%INSTALL_DIR%\image\bin" /f >nul
)

echo.
echo ✅ Installation completed successfully!
echo.
echo You can now:
echo - Run from Desktop: Double-click "YouTube Downloader" shortcut
echo - Run from Start Menu: Search for "YouTube Downloader"
echo - Run from Command Prompt: YouTubeDownloader.bat
echo.
echo Note: Make sure yt-dlp is installed for downloading functionality:
echo   pip install yt-dlp
echo.
pause
