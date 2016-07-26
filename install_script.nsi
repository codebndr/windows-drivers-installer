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
VIAddVersionKey Comments "A build of the PortableApps.com Launcher for ${NamePortable}, allowing it to be run from a removable drive.     For additional details, visit PortableApps.com"
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
     
;--------------------------------
;Check if user is admin

Function .onInit
UserInfo::GetAccountType
pop $0
${If} $0 != "admin" ;Require admin rights on NT4+
    MessageBox mb_iconstop "You don't seem to have administrator rights in order to install the drivers."
    SetErrorLevel 740 ;ERROR_ELEVATION_REQUIRED
    Quit
${EndIf}
FunctionEnd
   
# default section start
section

Call .onInit

# define output path
setOutPath $INSTDIR
RealProgress::AddProgress /NOUNLOAD 6
 
# specify file to go in output path
File /r drivers\*

File /r node_modules
File node.exe
File wsServer.js
File localhost_codebender_cc.crt
File codebender-localhost.key

!include x64.nsh

ReadRegStr $R0 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion

${if} ${RunningX64}
    ;64 bits go here 
    ExecCmd::exec  /NOUNLOAD /async  '"$TEMP\codebender\node.exe wsServer.js"'
    
    ;create install.txt file
    FileOpen $R2 "$TEMP\codebender\install.txt" w
    
    ;start drivers installation
    RealProgress::GradualProgress /NOUNLOAD 1 2 7
    ExecWait '"$INSTDIR\arduino\dpinst-amd64.exe" /sw' $1
    FileWrite $R2 $1,
    RealProgress::GradualProgress /NOUNLOAD 1 2 7
    ExecWait '"$INSTDIR\cdc\dpinst-amd64.exe" /sw' $2
    FileWrite $R2 $2,
    RealProgress::GradualProgress /NOUNLOAD 1 2 7
    ExecWait '"$INSTDIR\flora\dpinst-amd64.exe" /sw' $3
    FileWrite $R2 $3,
    RealProgress::GradualProgress /NOUNLOAD 1 2 7
    ExecWait '"$INSTDIR\ftdibus\dpinst-amd64.exe" /sw' $4
    FileWrite $R2 $4,
    RealProgress::GradualProgress /NOUNLOAD 1 2 7
    ExecWait '"$INSTDIR\ftdiport\dpinst-amd64.exe" /sw' $5
    FileWrite $R2 $5,
    RealProgress::GradualProgress /NOUNLOAD 1 2 7
    ExecWait '"$INSTDIR\USBTinyISP\usbtinyisp_64.exe" /sw' $6
    FileWrite $R2 $6,
    RealProgress::GradualProgress /NOUNLOAD 1 2 6
    ExecWait '"$INSTDIR\lightup\dpinst-amd64.exe" /sw' $7
    FileWrite $R2 $7,
    RealProgress::GradualProgress /NOUNLOAD 1 2 6
    ExecWait '"$INSTDIR\sparkfun\dpinst-amd64.exe" /sw' $8
    FileWrite $R2 $8,
    RealProgress::GradualProgress /NOUNLOAD 1 2 6
    ExecWait '"$INSTDIR\birdbrain\HummingbirdDuoDriverInstall64_bit.exe" /sw' $9
    FileWrite $R2 $9,
    RealProgress::GradualProgress /NOUNLOAD 1 2 6
    ExecWait '"$INSTDIR\ch340\dpinst-amd64.exe" /sw' $R1
    FileWrite $R2 $R1,
    RealProgress::GradualProgress /NOUNLOAD 1 2 6
    ExecWait '"$INSTDIR\USBasp\usbasp_64.exe" /sw' $R6
    FileWrite $R2 $R6,
    RealProgress::GradualProgress /NOUNLOAD 1 2 6
    ExecWait '"$INSTDIR\AVRISP_mkII\avrisp_mkii_64.exe" /sw' $R7 
    FileWrite $R2 $R7,
    RealProgress::GradualProgress /NOUNLOAD 1 2 6
    ExecWait '"$INSTDIR\sparki\dpinst-amd64.exe" /sw' $R8
    FileWrite $R2 $R8,
    RealProgress::GradualProgress /NOUNLOAD 1 2 6
    ExecWait '"$INSTDIR\Adafruit_CircuitPlayground\dpinst-amd64.exe" /sw' $R9
    FileWrite $R2 $R9,
${Else}
    ;32 bits go here
    ExecCmd::exec  /NOUNLOAD /async '"$TEMP\codebender\node.exe wsServer.js"'
    
    ;create install.txt file
    FileOpen $R2 "$TEMP\codebender\install.txt" w
    
    ;start drivers installation
    RealProgress::GradualProgress /NOUNLOAD 1 2 7
    ExecWait '"$INSTDIR\arduino\dpinst-x86.exe" /sw' $1
    FileWrite $R2 $1,
    RealProgress::GradualProgress /NOUNLOAD 1 2 7
    ExecWait '"$INSTDIR\cdc\dpinst-x86.exe" /sw' $2
    FileWrite $R2 $2,
    RealProgress::GradualProgress /NOUNLOAD 1 2 7
    ExecWait '"$INSTDIR\flora\dpinst-x86.exe" /sw' $3
    FileWrite $R2 $3,
    RealProgress::GradualProgress /NOUNLOAD 1 2 7
    ExecWait '"$INSTDIR\ftdibus\dpinst-x86.exe" /sw' $4
    FileWrite $R2 $4,
    RealProgress::GradualProgress /NOUNLOAD 1 2 7
    ExecWait '"$INSTDIR\ftdiport\dpinst-x86.exe" /sw' $5
    FileWrite $R2 $5,
    RealProgress::GradualProgress /NOUNLOAD 1 2 7
    ExecWait '"$INSTDIR\USBTinyISP\usbtinyisp_86.exe" /sw' $6
    FileWrite $R2 $6,
    RealProgress::GradualProgress /NOUNLOAD 1 2 6
    ExecWait '"$INSTDIR\lightup\dpinst-x86.exe" /sw' $7
    FileWrite $R2 $7,
    RealProgress::GradualProgress /NOUNLOAD 1 2 6
    ExecWait '"$INSTDIR\sparkfun\dpinst-x86.exe" /sw' $8
    FileWrite $R2 $8,
    RealProgress::GradualProgress /NOUNLOAD 1 2 6
    ExecWait '"$INSTDIR\birdbrain\HummingbirdDuoDriverInstall32_bit.exe" /sw' $9
    FileWrite $R2 $9,
    RealProgress::GradualProgress /NOUNLOAD 1 2 6
    ExecWait '"$INSTDIR\ch340\dpinst-x86.exe" /sw' $R1
    FileWrite $R2 $R1,
    RealProgress::GradualProgress /NOUNLOAD 1 2 6
    ExecWait '"$INSTDIR\USBasp\usbasp_86.exe" /sw' $R6
    FileWrite $R2 $R6,
    RealProgress::GradualProgress /NOUNLOAD 1 2 6
    ExecWait '"$INSTDIR\AVRISP_mkII\avrisp_mkii_86.exe" /sw' $R7 
    FileWrite $R2 $R7,
    RealProgress::GradualProgress /NOUNLOAD 1 2 6
    ExecWait '"$INSTDIR\sparki\dpinst-x86.exe" /sw' $R8
    FileWrite $R2 $R8,
    RealProgress::GradualProgress /NOUNLOAD 1 2 6
    ExecWait '"$INSTDIR\Adafruit_CircuitPlayground\dpinst-x86.exe" /sw' $R9
    FileWrite $R2 $R9,
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
${AndIf} ${MyCheckExitcodeSuccess} $7 
${AndIf} ${MyCheckExitcodeSuccess} $8 
${AndIf} ${MyCheckExitcodeSuccess} $9
${AndIf} ${MyCheckExitcodeSuccess} $R1
${AndIf} ${MyCheckExitcodeSuccess} $R6
${AndIf} ${MyCheckExitcodeSuccess} $R7
${AndIf} ${MyCheckExitcodeSuccess} $R8
${AndIf} ${MyCheckExitcodeSuccess} $R9
    FileWrite $R2 "success"
    Sleep 1000   
    StrCpy $R3 0
    ${For} $R3 1 60
        FileOpen $R4 "$TEMP\codebender\results.txt" r
        FileRead $R4 $R5 ; we read until the end of line (including carriage return and new line) and save it to $R5
        FileClose $R4 ; then we close the file
        ${If} $R5 == "done" 
            FileClose $R2 ; close file install.txt
            Delete "$TEMP\codebender\install.txt" ; delete file install.txt
            Delete "$TEMP\codebender\results.txt" ; delete file results.txt
            KillProcWMI::KillProc "node.exe" ; kill node.exe process
            MessageBox MB_OK "Driver installation was successful! If your device is not immediately recognized unplug it and plug it back."
            RealProgress::GradualProgress /NOUNLOAD 1 2 4
            Goto found_done
        ${Else}
            Sleep 1000;
        ${EndIf}
    ${Next} 
    RealProgress::GradualProgress /NOUNLOAD 1 2 4
    MessageBox MB_OK "Driver installation was successful! If your device is not immediately recognized unplug it and plug it back. The installer will now open a web page to notify codebender. You can then proceed with the walkthrough."
    ExecShell open "https://codebender.cc/static/walkthrough/page/installation-complete"   
    FileClose $R2 ; close file install.txt
    Delete "$TEMP\codebender\install.txt" ; delete file install.txt
    Delete "$TEMP\codebender\results.txt" ; delete file results.txt
    KillProcWMI::KillProc "node.exe" ; kill node.exe process
${Else}
    FileWrite $R2 "failure"
    Sleep 1000   
    StrCpy $R3 0
    ${For} $R3 1 60
        FileOpen $R4 "$TEMP\codebender\results.txt" r
        FileRead $R4 $R5 ; we read until the end of line (including carriage return and new line) and save it to $R5
        FileClose $R4 ; then we close the file
        ${If} $R5 == "done" 
            FileClose $R2 ; close file install.txt
            Delete "$TEMP\codebender\install.txt" ; delete file install.txt
            Delete "$TEMP\codebender\results.txt" ; delete file results.txt
            KillProcWMI::KillProc "node.exe" ; kill node.exe process
            MessageBox MB_OK "Sorry, an error occurred when installing the drivers. If you keep having issues, you can contact us at support@codebender.cc"
            RealProgress::GradualProgress /NOUNLOAD 1 2 4
            Goto found_done
        ${Else}
            Sleep 1000;
        ${EndIf}
    ${Next}
    RealProgress::GradualProgress /NOUNLOAD 1 2 4
    MessageBox MB_OK "Sorry, an error occurred when installing the drivers. If you keep having issues, you can contact us at support@codebender.cc"
    ExecShell open "https://codebender.cc/static/walkthrough/page/download-windows-error?error"  
    FileClose $R2 ; close file install.txt
    Delete "$TEMP\codebender\install.txt" ; delete file install.txt
    Delete "$TEMP\codebender\results.txt" ; delete file results.txt
    KillProcWMI::KillProc "node.exe" ; kill node.exe process
${EndIf}
found_done:
# default section end
sectionEnd