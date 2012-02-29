cd ([Environment]::GetFolderPath("MyDocuments") + "\SSH")
$keys = ""
gci *.ppk | ForEach-Object { $keys += $_.FullName + " "}
start "C:\Program Files (x86)\Putty\pageant.exe" $keys
$keys = ""