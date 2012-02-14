param($category, $project)

$devbase = "D:\Development"
$rubyBase = $devbase + "\ruby"
$pythonBase = $devbase + "\python"

$categories = @{"main" = $devBase
               ;"emarker" = $devBase + "\eMarker_central"
			   ;"ruby" = $rubyBase
			   ;"python" = $pythonBase
			   ;"powershell" = $devBase + "\powershell"}
               
if (($category -eq $null) -or (($categories.Contains($category) -eq $false)))
{
    Write-Host "Go where?" -ForegroundColor yellow
    $categories.Keys | ForEach-Object { Write-Host("  " + $_) -f yellow }
    return ""
}

cd ($categories.Get_Item($category) + "\" + $project)
