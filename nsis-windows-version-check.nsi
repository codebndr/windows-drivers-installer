RequestExecutionLevel user

# define installer name
outFile "windows-version-tester.exe"

 
# default section start
section

	ReadRegStr $R0 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion
	
    MessageBox MB_OK "$R0"

# default section end
sectionEnd
