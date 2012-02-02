param($category, $project)

$devbase = "D:\Development"
$dotnetBase = $devBase + "\dotnet"
$eftBase = $dotnetBase + "\eft"
$legacyBase = $dotnetBase + "\eft-legacy"
$gitBase = $devbase + "\git"
$rubyBase = $devbase + "\ruby"
$pythonBase = $devbase + "\python"

$categories = @{"dotnet" = $dotnetBase
               ;"cao" = ($dotNetBase + "\CardAtOnce")
               ;"eft" = $eftBase
               ;"eftlib" = ($eftBase + "\Libraries")
               ;"eftapp" = ($eftBase + "\Applications")
               ;"eftsvc" = ($eftBase + "\Services")
               ;"legacy" = $legacyBase
               ;"git" = $gitBase
               ;"ruby" = $rubyBase
               ;"python" = $pythonBase}
               
if (($category -eq $null) -or (($categories.Contains($category) -eq $false)))
{
    Write-Host "Go where?" -ForegroundColor yellow
    $categories.Keys | ForEach-Object { Write-Host("  " + $_) -f yellow }
    return ""
}

cd ($categories.Get_Item($category) + "\" + $project)
