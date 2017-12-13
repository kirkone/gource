[CmdletBinding()]
Param (
    [Parameter(Mandatory = $True, Position = 1)]    
    [string]
    $Project
)

if (!(Test-Path -Path ".\Projects\$Project\Logs" )) {
    Write-Verbose "Logs Directory not found, creating..."
    New-Item -ItemType directory -Path ".\Projects\$Project\Logs" | Out-Null
    Write-Verbose "    Done.`n`n"
}

Get-ChildItem -Path .\Projects\$Project\Repositories -Directory | 
    Foreach-Object {
    $dirname = $_.Name
    Write-Verbose "Processing '$dirname'"
    & .\gource\gource.exe --output-custom-log ".\Projects\$Project\Logs\$dirname.txt" ".\Projects\$Project\Repositories\$dirname"

    (Get-Content ".\Projects\$Project\Logs\$dirname.txt") |
        ForEach-Object { $_ -replace '(?<=\|.\|/)', "$dirname/" } |
        Set-Content ".\Projects\$Project\Logs\$dirname.txt"
    Write-Verbose "    Done.`n`n"
}

Write-Verbose "Merging into one file..."
Get-Content ".\Projects\$Project\Logs\*.txt" -Exclude ("combined.txt") | Sort-Object | Set-Content ".\Projects\$Project\Logs\combined.txt"
Write-Verbose "    Done."
