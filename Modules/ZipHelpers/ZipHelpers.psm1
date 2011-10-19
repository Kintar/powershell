##########################################################
# Zip functionality for powershell
##########################################################

#######################################################################
# Locates the 7z executable in the module directory
#######################################################################
function find7Zip
{
    $path = $myInvocation.MyCommand.Module.ModuleBase
    $zipCmd = $path + "\7z.exe"
    return $zipCmd
}

#######################################################################
# Creates a zip file from the file objects in the pipeline, and returns
# the created item
#######################################################################
function Create-Zip([string]$fileName)
{
    $zipCmd = find7Zip
    $filenameList = ""
    foreach ($file in $input)
    {
        $filenameList += ($file.FullName + " ")
    }
    
    iex "$zipCmd a $fileName $filenameList"
    return Get-Item($fileName)
}


function Extract-Zip([string]$zipFile, [string]$target = "")
{
    $outArg = ""
    if ($target -ne "")
    {
        $outArg = "-o " + $target
    }
    
    if (-not (Test-Path($zipFile)))
    {
        $zipFile = $zipFile + ".zip"
        if (-not (Test-Path($zipFile)))
        {
            Write-Host("Zip file '$zipFile' not found") -foregroundcolor red
            return $false
        }
    }
    
    $zipCmd = find7Zip
    
    $result = (iex "$zipCmd x -y $outArg $zipFile")
    foreach($line in $result)
    {
        if ($line.Contains("Everything is Ok")) 
        {
            return $true
        }
    }
    
    return $false
}

Export-ModuleMember Create-Zip, Extract-Zip