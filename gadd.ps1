$gitstat = git status --porcelain
$untracked_count = [regex]::matches($gitstat, [regex]::escape("??")).count
if ($untracked_count -eq 0)
{
    Write-Host("No untracked files to add.") -foregroundcolor green
    return
}

foreach ($item in $gitstat) {
    $match = [regex]::match($item, [regex]::escape("??") + " (.+)")
    if ($match.Groups.count -gt 1)
    {
        $file = $match.Groups[1].Value
        Write-Host("Adding " + $file) -foregroundcolor yellow
        git add $file
    }
}

Write-Host("Added " + $untracked_count + " files to git.") -foregroundcolor green
