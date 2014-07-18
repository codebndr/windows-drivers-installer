RequestExecutionLevel admin

;NSIS Modern User Interface

;--------------------------------
;Include Modern UI

!include "MUI2.nsh"
!include WinMessages.nsh
!include LogicLib.nsh

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

  !insertmacro MUI_PAGE_INSTFILES

;--------------------------------
;Languages
!insertmacro MUI_LANGUAGE "English"
  
# default section start
section

# define output path
setOutPath $INSTDIR
RealProgress::AddProgress /NOUNLOAD 10
 
# specify file to go in output path
File /r drivers\*

!include x64.nsh

ReadRegStr $R0 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion

${if} ${RunningX64}
	; 64 bits go here
	RealProgress::GradualProgress /NOUNLOAD 1 3 14
	ExecWait '"$INSTDIR\arduino\dpinst-amd64.exe" /sw' $1
	RealProgress::GradualProgress /NOUNLOAD 1 3 14
	ExecWait '"$INSTDIR\cdc\dpinst-amd64.exe" /sw' $2
	RealProgress::GradualProgress /NOUNLOAD 1 3 14
	ExecWait '"$INSTDIR\flora\dpinst-amd64.exe" /sw' $3
	RealProgress::GradualProgress /NOUNLOAD 1 3 14
	ExecWait '"$INSTDIR\ftdibus\dpinst-amd64.exe" /sw' $4
	RealProgress::GradualProgress /NOUNLOAD 1 3 14
	ExecWait '"$INSTDIR\ftdiport\dpinst-amd64.exe" /sw' $5
	RealProgress::GradualProgress /NOUNLOAD 1 3 14
	ExecWait '"$INSTDIR\usbtiny\dpinst-amd64.exe" /sw' $6
	RealProgress::GradualProgress /NOUNLOAD 1 3 6
${Else}
	; 32 bits go here
	RealProgress::GradualProgress /NOUNLOAD 1 3 14
	ExecWait '"$INSTDIR\arduino\dpinst-x86.exe" /sw' $1
	RealProgress::GradualProgress /NOUNLOAD 1 3 14
	ExecWait '"$INSTDIR\cdc\dpinst-x86.exe" /sw' $2
	RealProgress::GradualProgress /NOUNLOAD 1 3 14
	ExecWait '"$INSTDIR\flora\dpinst-x86.exe" /sw' $3
	RealProgress::GradualProgress /NOUNLOAD 1 3 14
	ExecWait '"$INSTDIR\ftdibus\dpinst-x86.exe" /sw' $4
	RealProgress::GradualProgress /NOUNLOAD 1 3 14
	ExecWait '"$INSTDIR\ftdiport\dpinst-x86.exe" /sw' $5
	RealProgress::GradualProgress /NOUNLOAD 1 3 14
	ExecWait '"$INSTDIR\usbtiny\dpinst-x86.exe" /sw' $6
	RealProgress::GradualProgress /NOUNLOAD 1 3 6
${EndIf}

!macro _MyCheckExitcodeSuccess _a _b _t _f
    !if `${_f}` == ``
        !undef _f
        !define _f +2 
    !endif
    IntCmp ${_b} 1 +2
    IntCmp ${_b} 256 `${_t}` `${_f}` `${_f}`
    !if `${_t}` != ``
        Goto `${_t}`
    !endif
!macroend
!define MyCheckExitcodeSuccess `"" MyCheckExitcodeSuccess`

${If} ${MyCheckExitcodeSuccess} $1
${AndIf} ${MyCheckExitcodeSuccess} $2
${AndIf} ${MyCheckExitcodeSuccess} $3
${AndIf} ${MyCheckExitcodeSuccess} $4
${AndIf} ${MyCheckExitcodeSuccess} $5
${AndIf} ${MyCheckExitcodeSuccess} $6
	Sleep 3000
	MessageBox MB_OK "Driver installation was successful! The installer will now open a web page to notify codebender. You can then proceed with the walkthrough."
	ExecShell open "https://codebender.cc/static/walkthrough/page/download-complete"
${Else}
	Sleep 3000
    MessageBox MB_OK "Sorry, an error occurred when installing the drivers. If you keep having issues, you can contact us at girder@codebender.cc"
	ExecShell open "https://codebender.cc/static/walkthrough/page/download-windows-error?error"
${EndIf}

# default section end
sectionEnd

