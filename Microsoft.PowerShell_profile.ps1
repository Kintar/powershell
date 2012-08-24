$scriptPath = Join-Path $home "PowerShellScripts"
[System.Environment]::SetEnvironmentVariable("PATH", $Env:Path + ";D:\Development\powershell", "Process")

$modulesPath = (Join-Path $scriptPath "Modules")
$Env:PSModulePath = $Env:PSModulePath + ";" + $modulesPath

find-to-set-alias "c:\Program Files (x86)\Notepad++" notepad++.exe pp
find-to-set-alias "C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\IDE" devenv.exe vs2010
find-to-set-alias "D:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\IDE" devenv.exe vs2008
find-to-set-alias "C:\Program Files (x86)\Sublime Text 2" sublime_text.exe st

function find_project([string]$solutionName)
{
    if ($solutionName -eq "")
    {
        $solutionFile = Get-ChildItem("*.sln")
        if ($solutionFile -eq $NULL)
        {
             return $NULL
        }
    }
    else
    {
        $solutionFile = $solutionName + ".sln"
    }
    
    if (Test-Path $solutionFile)
    {
        return $solutionFile
    }
    else
    {
        return $NULL
    }

}

# Aliasable function to open a solution file in visual studio.  Requires the 'vs' alias above
function open_project_2010([string]$solutionName)
{
    $solutionFile = find_project($solutionName)
    
    if (Test-Path $solutionFile)
    {
        Write-Host ("Opening solution file " + $solutionFile.Name) -foregroundcolor yellow
        vs2010 $solutionFile
    }
    else
    {
        Write-Host ("Solution file '" + $solutionName + "' not found.") -foregroundcolor red
    }
}

set-alias vs open_project_2010

function open_project_2008([string]$solutionName)
{
    $solutionFile = find_project($solutionName)
    
    if (Test-Path $solutionFile)
    {
        Write-Host ("Opening solution file " + $solutionFile.Name + " in vs2008") -ForegroundColor yellow
        vs2008 $solutionFile
    }
    else
    {
        Write-Host ("Solution file '" + $solutionName + "' not found.") -ForegroundColor red
    }
}

set-alias vs8 open_project_2008

# Configure the prompt
function prompt {

    Write-Host("")
    Write-Host("PS " + $(get-location)) -nonewline -foregroundcolor green
    
    # check to see if this is a directory containing a symbolic reference, 
    # fails (gracefully) on non-git repos.
    $symbolicRef = git symbolic-ref HEAD
    if ($symbolicRef -ne $NULL)
    {
        Write-Host(" [" + $symbolicRef.substring($symbolicRef.LastIndexOf("/") + 1) + "] ") -nonewline -foregroundcolor yellow
    }
    
    $svnurl = svn info | select-string "URL:"
    if ($svnurl -ne $null)
    {
        $svnurl = $svnurl.ToString()
        Write-Host(" [" + $svnurl.substring($svnurl.LastIndexOf("/") + 1) + "] ") -nonewline -f yellow
    }
    
    Write-Host(">") -nonewline -foregroundcolor green
    
    return " "
}