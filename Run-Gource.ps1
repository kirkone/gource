[CmdletBinding()]
Param (
    [Parameter(Mandatory = $True, Position = 1)]    
    [string]
    $Project
)

if (-not (Test-Path -Path ".\Projects\$Project") ) {
    Write-Error "Project with the name '$Project does not exist!'"
    return
}

& .\gource\gource.exe `
    --load-config ".\Projects\$Project\config.txt" `
    --path ".\Projects\$Project\Logs\combined.txt" `
    --user-image-dir ".\Projects\$Project\Avatars"