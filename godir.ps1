param([string]$name)

$myPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$scriptPath = $myPath + "\go_targets"


if (($name -eq $NULL) -or ($name -eq ""))
{
    Write-Host("Please specify a destination: ") -foregroundcolor yellow
    foreach ($target in (Get-ChildItem $scriptPath))
    {
        $targetName = $target.Name.substring(0, $target.Name.LastIndexOf("."))
        Write-Host("  " + $targetName) -foregroundcolor blue
    }
    return
}

$lnkTarget = $scriptPath + "\" + $name + ".lnk"
$lnkExists = Test-Path $lnkTarget

if ($lnkExists)
{
    $shell = New-Object -com wscript.shell
    $lnk = $shell.CreateShortcut($lnkTarget)
    Write-Host("Changing directory to " + $lnk.TargetPath) -foregroundcolor green
    Set-Location $lnk.TargetPath
}

