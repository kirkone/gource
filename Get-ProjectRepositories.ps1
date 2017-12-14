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

if (!(Test-Path -Path ".\Projects\$Project\Repositories" )) {
    Write-Verbose "Repositories Directory not found, creating..."
    New-Item -ItemType directory -Path ".\Projects\$Project\Repositories" | Out-Null
    Write-Verbose "    Done.`n`n"
}

Set-Location .\Projects\$Project\Repositories

Remove-Item .\* -Recurse -Force

Get-Content ..\repositories.txt | Where-Object {$_ -NotMatch '\s'} | ForEach-Object {
    Write-Verbose "Cloning '$_'"
    & git clone $_
}

Set-Location ..\..\..
