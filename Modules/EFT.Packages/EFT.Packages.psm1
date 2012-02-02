#########################################################################
#
# Module for dealing with EFT's packages server 
#
#########################################################################


##########################################################################
#
# Gets a file from the packages server
#
##########################################################################
function Get-Package
{
    param([string]$file,[string]$path,[string]$server="packages.lab.eftdomain.net")

    if (($path -eq "") -or ($file -eq ""))
    {
@"
==========================================================================
Get-Package <file> <packagePath> <packageServer>
--------------------------------------------------------------------------
file:
  The path to the local file you want to upload. The remote file will use
  this same name.
packagePath:
  The path on the package server to the file.
packageServer:
  The name of the package server. E.g., packages.lab.eftdomain.net
  Defaults to 'packages.lab.eftdomain.net'
==========================================================================
"@ | Write-Host

        return
    }

    $targetFile = Join-Path (Get-Location) $file

    $client = (New-Object net.webclient)
    $targetUrl = "https://" + $server + "/" + $path + "/" + $file
    echo "Downloading package '$file' from '$targetUrl'"
    try
    {
        $client.DownloadFile($targetUrl, $targetFile)
        Write-Host "Complete" -f green
        return ""
    }
    catch
    {
        Write-Host "Error performing download" -f red
        $error[0].Exception.ToString() | Write-Host -f yellow
    }
}

##########################################################################
#
# Sends a file to the packages server
#
##########################################################################
function Send-Package
{
    param([string]$file,[string]$path,[string]$server="packages.lab.eftdomain.net")

    if (($path -eq "") -or ($file -eq ""))
    {
@"
==========================================================================
Send-Package <file> <packagePath> [packageServer]
--------------------------------------------------------------------------
file:
  The path to the local file you want to upload. The remote file will use
  this same name.
packagePath:
  The path on the package server to the file.  This path should start with
  'working/'.  This value will be prepended if necessary.
packageServer:
  The name of the package server. E.g., packages.lab.eftdomain.net
  Defaults to 'packages.lab.eftdomain.net'
==========================================================================
"@ | Write-Host

        return
    }

    if (-not ($path.StartsWith("working/")))
    {
        $path = "working/" + $path
    }

    if (-not (Test-Path $file))
    {
        Write-Host("Could not find local file '$file'") -f yellow
        return
    }

    $fileObject = (Get-Item $file)

    $client = (New-Object net.webclient)
    $targetUrl = "https://" + $server + "/" + $path + "/" + $fileObject.Name
    echo "Sending to $targetUrl"
    try
    {
        $result = $client.UploadFile($targetUrl, "PUT", $fileObject)
        Write-Host "Complete" -f green
        return ""
    }
    catch
    {
        Write-Host "Error performing upload" -f red
        $error[0].Exception.ToString() | Write-Host -f yellow
    }
}


###########################################################
#
# Signs a script with the EFTSource Development certificate
#
###########################################################
function Sign-Script
{
    param([string]$scriptName)

    if ($scriptName -eq "")
    {
@"
==========================================================================
Sign-Script <scriptFile>
--------------------------------------------------------------------------
scriptFile: 
  Path to the script you want to sign.  NOTE: PowerShell ISE saves in the
  wrong format unless you've installed the EFT default PSISE profile 
  script!

NOTE: You must have the EFT Code Signing Key installed in your CurrentUser
certificate store for this script to function.
==========================================================================
"@ | Write-Host
        
        return
    }

    $certOU = "CN=EFTSource Development, OU=Development"

    function IsCertValid($cert)
    {
        return (($cert.NotBefore -le (Get-Date)) -and ($cert.NotAfter -ge (Get-Date)))
    }

    function FindSigningCert
    {
        foreach($cert in (Get-ChildItem cert:\CurrentUser\My -codesign))
        {
            $certNameValid = ($cert.Subject).Contains($certOU)
            if ($certNameValid)
            {
                if ((IsCertValid($cert)))
                {
                    return $cert
                }
            }
        }
    }

    if (-not (Test-Path($scriptName)))
    {
        Write-Host("Could not find script $scriptName") -foregroundcolor yellow
        return
    }

    $signingCert = FindSigningCert
    if ($signingCert -eq $null)
    {
        Write-Host("Failed to locate a valid code signing certificate for '$certOU'") -foregroundcolor yellow
        return;
    }

    Set-AuthenticodeSignature $scriptName $signingCert -IncludeChain All
}

##########################################################################
#
# Downloads a zipped module from the packages server and extracts it 
# into the user's module directory.
#
##########################################################################
function Install-PackageModule($moduleName)
{
    $scriptPath = Join-Path $home "PowerShellScripts"
    $modulesPath = (Join-Path $scriptPath "Modules")
    
    if (-not (Test-Path($modulesPath + "\ZipHelpers")))
    {
        "This command requires the ZipHelpers module to be pre-installed." | Write-Host -f red
        return ""
    }
    
    # Create a temp directory
    $tmpPath = Join-Path $home "temp"
    if (-not (Test-Path($tmpPath)))
    {
        mkdir $tmpPath
    }
    
    try
    {
        "Downloading " + $moduleName + " module..." | Write-Host -f green
        
        Get-Package ($moduleName + ".zip") "working/eftpowershell/modules"
        
        $oldLoc = Get-Location
        Set-Location $zipModuleDest
        
        if (-not (Extract-Zip($moduleName + ".zip")))
        {
            "Failed to extract module" | Write-Host -f red
        }
        else
        {
            "Successfully installed " + $moduleName + " module" | Write-Host -f green
            "To use this module, type 'Import-Module " + $moduleName + " -DisableNameChecking'" | Write-Host -f white
            del $zipModuleFile
        }
        Set-Location $oldLoc
    }
    catch
    {
        "Failed to download/import module" | Write-Host -f red
        $error[0].Exception.ToString() | Write-Host -f yellow
    }
}

Export-ModuleMember Sign-Script,Send-Package,Get-Package,Install-PackageModule

