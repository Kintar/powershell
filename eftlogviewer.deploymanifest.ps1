Add-Module eft.installer

AppName "EFT Log Viewer"
AppVersion "2.8.3.0"
Executable "eftlogviewer.exe"

UseDefaultInstallLocation

# For applications
CreateDesktopShortcut
CreateStartMenuShortcut

# For services
InstallService "EFTAwesomeService"