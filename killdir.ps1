param([string]$path)
if ($path -eq "")
{
    Write-Host("No path specified. Not killing the world. :P") -foregroundcolor red
    return
}

Write-Host("Nuking " + $path + "...") -foregroundcolor yellow
rmdir -fo -r $path
