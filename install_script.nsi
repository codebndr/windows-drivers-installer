RequestExecutionLevel admin

;NSIS Modern User Interface

;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"

;--------------------------------
;General

  ;Name and file
  Name "codebender driver installer"
 
  # define installer name
  OutFile "windows-driver-installer.exe"
 
  # set install directory
  InstallDir "$TEMP\codebender"

  Caption "codebender drivers installer"
  VIProductVersion "1.0.0.0"
  VIAddVersionKey ProductName "codebender drivers installer"
  VIAddVersionKey Comments "A build of the PortableApps.com Launcher for ${NamePortable}, allowing it to be run from a removable drive.  For additional details, visit PortableApps.com"
  VIAddVersionKey CompanyName codebender.cc
  VIAddVersionKey LegalCopyright codebender.cc
  VIAddVersionKey FileDescription "codebender.cc (codebender.cc Arduino Driver Installer)"
  VIAddVersionKey FileVersion "1.0"
  VIAddVersionKey ProductVersion "1.0.0.0"
  VIAddVersionKey InternalName "codebender.cc driver installer"
  VIAddVersionKey LegalTrademarks "codebender.cc is a Trademark of CODEBENDER OOD."
  VIAddVersionKey OriginalFilename "windows-driver-installer.exe"

;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING
  !define MUI_ICON "codebender.ico"

;--------------------------------
;Pages

  ;!insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_INSTFILES

;--------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "English"
  
# default section start
section
 
# define output path
setOutPath $INSTDIR
 
# specify file to go in output path
File /r drivers\*

!include x64.nsh

ReadRegStr $R0 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion

${if} ${RunningX64}
; 64 bits go here
	ExecWait '"$INSTDIR\dpinst-amd64.exe" /sw' $1
${Else}
	; 32 bits go here
	ExecWait '"$INSTDIR\dpinst-x86.exe" /sw' $1
${EndIf}

;	MessageBox MB_OK "'$1'"

${If} "$1" == "768"
	MessageBox MB_OK "Driver installation was successful! The installer will now open a web page to notify codebender. You can then proceed with the walkthrough."
	ExecShell open "https://codebender.cc/static/walkthrough/page/download-complete"
${Else}
	MessageBox MB_OK "Sorry, an error occurred when installing the drivers. If you keep having issues, you can contact us at girder@codebender.cc"
${EndIf}


# default section end
sectionEnd
