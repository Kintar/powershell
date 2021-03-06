# Clones a git repository into a local directory
param([string]$repo, [string]$target)

if ($repo -eq "")
{
    Write-Host("Please specify a git repository name") -foregroundcolor red
    return
}

if ($target -eq "") 
{
    $target = $repo
}

git clone git@git.eftdomain.net:$repo.git $target
