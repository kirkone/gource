[CmdletBinding()]
Param (
    [Parameter(Mandatory = $True, Position = 1)]    
    [string]
    $Project
)

& .\gource\gource.exe `
    --load-config ".\Projects\$Project\config.txt" `
    --path ".\Projects\$Project\Logs\combined.txt" `
    --user-image-dir ".\Projects\$Project\Avatars"