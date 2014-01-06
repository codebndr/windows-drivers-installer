RequestExecutionLevel user

caption "codebender drivers installer"

# define installer name
outFile "windows-driver-installer.exe"
 
# set install directory
InstallDir "$TEMP\codebender"
 
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
	ExecWait '"$INSTDIR\Arduino\dpinst-amd64.exe" /sw' $1
	${if} "$R0" == "6.3"
		; Windows 8.1
		ExecWait '"$INSTDIR\CDM020830_Win81\dpinst-amd64.exe" /sw' $2
	${Else}
		; All other
		ExecWait '"$INSTDIR\CDM20830_WinAll\dpinst-amd64.exe" /sw' $2
	${EndIf}
${Else}
	; 32 bits go here
	ExecWait '"$INSTDIR\Arduino\dpinst-x86.exe" /sw' $1
	${if} "$R0" == "6.3"
		; Windows 8.1
		ExecWait '"$INSTDIR\CDM020830_Win81\dpinst-x86.exe" /sw' $2
	${Else}
		; All other
		ExecWait '"$INSTDIR\CDM20830_WinAll\dpinst-x86.exe" /sw' $2
	${EndIf}
${EndIf}

${If} "$1 $2" == "256 512"
	MessageBox MB_OK "Driver installation was successful! The installer will now open a web page to notify codebender. You can then proceed with the walkthrough."
	ExecShell open "https://codebender.cc/static/walkthrough/page/download-complete"
${Else}
	MessageBox MB_OK "Sorry, an error occurred when installing the drivers. If you keep having issues, you can contact us at girder@codebender.cc"
${EndIf}



# default section end
sectionEnd
