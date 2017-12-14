[CmdletBinding()]
Param (
    [Parameter(Mandatory = $True, Position = 1)]    
    [string]
    $Project
)

if (Test-Path -Path ".\Projects\$Project" ) {
    Write-Error "Project with the name '$Project allready exists!'"
    return
}

New-Item -ItemType directory -Path ".\Projects\$Project" | Out-Null
New-Item -ItemType File -Path ".\Projects\$Project\repositories.txt" | Out-Null

"[display]
frameless=false
multi-sampling=true
no-vsync=true
viewport=1280x720

[gource]
auto-skip-seconds=1
colour-images=true
date-format=%d %B %Y
file-idle-time=0
filename-time=2
font-size=36
hide=mouse
key=true
max-file-lag=3
max-files=0
max-user-speed=100
seconds-per-day=10
title=$Project" | Out-File -FilePath ".\Projects\$Project\config.txt" -NoNewline -Encoding ascii