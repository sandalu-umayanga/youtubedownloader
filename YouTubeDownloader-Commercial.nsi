; YouTube Downloader Pro - Commercial Installer
; NSIS Script for creating professional Windows installer

!define PRODUCT_NAME "YouTube Downloader Pro"
!define PRODUCT_VERSION "1.1.0"
!define PRODUCT_PUBLISHER "Your Company Name"
!define PRODUCT_WEB_SITE "https://your-website.com"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\YoutubeDownloaderPro.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

; MUI Settings
!include "MUI2.nsh"
!include "FileFunc.nsh"

; Installer Settings
Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "YouTubeDownloader-Pro-Setup.exe"
InstallDir "$PROGRAMFILES\YouTube Downloader Pro"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show
RequestExecutionLevel admin

; Interface Settings
!define MUI_ABORTWARNING
; !define MUI_ICON "icon.ico"
; !define MUI_UNICON "icon.ico"
; !define MUI_HEADERIMAGE
; !define MUI_HEADERIMAGE_BITMAP "header.bmp"
; !define MUI_WELCOMEFINISHPAGE_BITMAP "welcome.bmp"

; Language Selection Dialog Settings
!define MUI_LANGDLL_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_LANGDLL_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "NSIS:Language"

; Pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "LICENSE.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

; Reserve files
!insertmacro MUI_RESERVEFILE_LANGDLL

; Version Information
VIProductVersion "1.1.0.0"
VIAddVersionKey "ProductName" "${PRODUCT_NAME}"
VIAddVersionKey "Comments" "Professional YouTube video and audio downloader"
VIAddVersionKey "CompanyName" "${PRODUCT_PUBLISHER}"
VIAddVersionKey "LegalTrademarks" "${PRODUCT_NAME} is a trademark of ${PRODUCT_PUBLISHER}"
VIAddVersionKey "LegalCopyright" "© ${PRODUCT_PUBLISHER}"
VIAddVersionKey "FileDescription" "${PRODUCT_NAME} Installer"
VIAddVersionKey "FileVersion" "${PRODUCT_VERSION}"
VIAddVersionKey "ProductVersion" "${PRODUCT_VERSION}"

; Sections
Section "Core Application" SecCore
  SectionIn RO
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  
  ; Copy application files
  File /r "target\image\*"
  
  ; Copy launcher script
  File "YouTubeDownloader-Working.bat"
  
  ; Copy documentation
  File "README.md"
  File "LICENSE"
  File "FEATURES.md"
  File "CHANGELOG.md"
  
  ; Create application data directory
  CreateDirectory "$APPDATA\YouTube Downloader Pro"
  
  ; Create downloads directory
  CreateDirectory "$DOCUMENTS\YouTube Downloads"
SectionEnd

Section "Desktop Shortcut" SecDesktop
  CreateShortCut "$DESKTOP\YouTube Downloader Pro.lnk" "$INSTDIR\bin\javaw.exe" "-m youtubedownloader/com.snake.youtubedownloader.App" "$INSTDIR\bin\javaw.exe" 0
SectionEnd

Section "Start Menu Shortcuts" SecStartMenu
  CreateDirectory "$SMPROGRAMS\YouTube Downloader Pro"
  CreateShortCut "$SMPROGRAMS\YouTube Downloader Pro\YouTube Downloader Pro.lnk" "$INSTDIR\bin\javaw.exe" "-m youtubedownloader/com.snake.youtubedownloader.App" "$INSTDIR\bin\javaw.exe" 0
  CreateShortCut "$SMPROGRAMS\YouTube Downloader Pro\Uninstall.lnk" "$INSTDIR\uninst.exe"
  CreateShortCut "$SMPROGRAMS\YouTube Downloader Pro\User Guide.lnk" "$INSTDIR\README.md"
  CreateShortCut "$SMPROGRAMS\YouTube Downloader Pro\Features.lnk" "$INSTDIR\FEATURES.md"
SectionEnd

Section "File Associations" SecAssoc
  ; Register URL protocol handler (optional)
  WriteRegStr HKLM "SOFTWARE\Classes\youtube-dl" "" "URL:YouTube Download Protocol"
  WriteRegStr HKLM "SOFTWARE\Classes\youtube-dl" "URL Protocol" ""
  WriteRegStr HKLM "SOFTWARE\Classes\youtube-dl\shell\open\command" "" '"$INSTDIR\bin\javaw.exe" -m youtubedownloader/com.snake.youtubedownloader.App "%1"'
SectionEnd

Section -AdditionalIcons
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\YouTube Downloader Pro\Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
  CreateShortCut "$SMPROGRAMS\YouTube Downloader Pro\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\bin\javaw.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\bin\javaw.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  
  ; Calculate and write installation size
  ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
  IntFmt $0 "0x%08X" $0
  WriteRegDWORD ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "EstimatedSize" "$0"
SectionEnd

; Section descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecCore} "Core application files and runtime (required)"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecDesktop} "Create a desktop shortcut for easy access"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecStartMenu} "Add shortcuts to the Start Menu"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecAssoc} "Associate YouTube URLs with the application"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

; Installer Functions
Function .onInit
  !insertmacro MUI_LANGDLL_DISPLAY
  
  ; Check if already installed
  ReadRegStr $R0 ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString"
  StrCmp $R0 "" done
  
  MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION \
  "${PRODUCT_NAME} is already installed. $\n$\nClick 'OK' to remove the previous version or 'Cancel' to cancel this upgrade." \
  IDOK uninst
  Abort
  
  uninst:
    ClearErrors
    ExecWait '$R0 _?=$INSTDIR'
    
    IfErrors no_remove_uninstaller done
    no_remove_uninstaller:
  
  done:
FunctionEnd

; Dependency Check Function
Function CheckDependencies
  ; Check for Python and pip
  nsExec::ExecToStack 'python --version'
  Pop $0
  ${If} $0 != 0
    MessageBox MB_YESNO "Python is not installed or not in PATH. $\n$\nYouTube Downloader Pro requires Python and yt-dlp to function properly. $\n$\nWould you like to continue anyway? (You can install Python later)" IDYES continue
    Abort
  ${EndIf}
  
  continue:
  ; Check for yt-dlp
  nsExec::ExecToStack 'yt-dlp --version'
  Pop $0
  ${If} $0 != 0
    MessageBox MB_YESNO "yt-dlp is not installed. $\n$\nWould you like to install it now? (Requires internet connection)" IDNO skip_ytdlp
    nsExec::ExecToLog 'pip install yt-dlp'
    skip_ytdlp:
  ${EndIf}
  
  ; Check for FFmpeg
  nsExec::ExecToStack 'ffmpeg -version'
  Pop $0
  ${If} $0 != 0
    MessageBox MB_OK "FFmpeg is not installed. $\n$\nFor audio downloading features, please install FFmpeg from: $\nhttps://ffmpeg.org/download.html $\n$\nOr use: winget install Gyan.FFmpeg"
  ${EndIf}
FunctionEnd

Function .onInstSuccess
  Call CheckDependencies
  
  ; Show completion message with usage instructions
  MessageBox MB_OK "Installation completed successfully! $\n$\n• Use the desktop shortcut to launch the application $\n• For audio downloads, ensure FFmpeg is installed $\n• Check the User Guide for detailed instructions $\n$\nThank you for purchasing YouTube Downloader Pro!"
FunctionEnd

; Uninstaller
Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  Delete "$INSTDIR\${PRODUCT_NAME}.url"
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\YouTubeDownloader-Working.bat"
  Delete "$INSTDIR\README.md"
  Delete "$INSTDIR\LICENSE"
  Delete "$INSTDIR\FEATURES.md"
  Delete "$INSTDIR\CHANGELOG.md"
  
  ; Remove application files
  RMDir /r "$INSTDIR\bin"
  RMDir /r "$INSTDIR\lib"
  RMDir /r "$INSTDIR\conf"
  RMDir /r "$INSTDIR\include"
  RMDir /r "$INSTDIR\legal"
  
  ; Remove shortcuts
  Delete "$DESKTOP\YouTube Downloader Pro.lnk"
  Delete "$SMPROGRAMS\YouTube Downloader Pro\*"
  RMDir "$SMPROGRAMS\YouTube Downloader Pro"
  
  ; Remove registry entries
  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  DeleteRegKey HKLM "SOFTWARE\Classes\youtube-dl"
  
  ; Remove installation directory
  RMDir "$INSTDIR"
  
  SetAutoClose true
SectionEnd
