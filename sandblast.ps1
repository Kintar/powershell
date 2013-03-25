write-host -ForegroundColor yellow  "Sandblasting will remove ALL 'bin' directories!  Are you SURE?"
write-host -nonewline "[y/n]"
$result = [Console]::ReadKey()
$char = $result.KeyChar

if  (($char -eq 'y') -or ($char -eq 'Y'))
{
	write-host -ForegroundColor green "`n*click* *whirrrrrrr*  *FWOOOSH!*"
	gci -Recurse | Where-Object { $_.FullName -match ".*\\bin\\.*" } | ForEach-Object { rm -r $_.fullname }
	write-host -ForegroundColor green "Aaaaah, that felt good."
}
else
{
	write-host -foregroundcolor green "`nAwwww.  You never let me have any fun."
}