[CmdletBinding()]
Param (
    [Parameter(Mandatory = $True, Position = 1)]    
    [string]
    $Project,

    [Parameter(Mandatory = $false, Position = 2)]    
    [string
    $Size = "90"
)

Function Get-StringHash([String] $String, $HashName = "MD5") {
    $StringBuilder = New-Object System.Text.StringBuilder
    [System.Security.Cryptography.HashAlgorithm]::Create($HashName).ComputeHash([System.Text.Encoding]::UTF8.GetBytes($String))|ForEach-Object {
        [Void]$StringBuilder.Append($_.ToString("x2"))
    }
    $StringBuilder.ToString()
}

if (!(Test-Path -Path ".\Projects\$Project\Avatars" )) {
    Write-Verbose "Avatars Directory not found, creating..."
    New-Item -ItemType directory -Path ".\Projects\$Project\Avatars" | Out-Null
    Write-Verbose "    Done.`n`n"
}

$cwd = Get-Location
[string[]]$processedAuthors = @()

Get-ChildItem -Path .\Projects\$Project\Repositories -Directory | 
    Foreach-Object {
    $dirname = $_.Name
    Write-Output "Processing '$dirname'"
    Set-Location $_.FullName
    & git log --pretty=format:"%ae|%an" | Foreach-Object {
        $line = $_ -split '\|'
        $email = $line[0]
        $author = $line[1]

        if ($processedAuthors -contains $author ) { return }
        else {$processedAuthors += $author}

        $authorImageFile = "$cwd\Projects\$Project\Avatars\$author.png";
        if (Test-Path $authorImageFile ) { return }
        Write-Output "    Getting Image for '$author'"
        $hash = (Get-StringHash $email)

        $imageUri = "http://www.gravatar.com/avatar/" + $hash + "?d=404&size=" + $Size
        try {
            Invoke-WebRequest -Uri $imageUri -OutFile $authorImageFile | Out-Null
        }
        catch {
            if ($_.Exception.Response.StatusCode.Value__ -eq 404) {
                Write-Warning "Image for '$author' was not found"
                return
            }
            Write-Warning "Error while downloading Image for '$author': $($_.Exception.Response.StatusCode.Value__)"
        }
    }

    Write-Output "    Done.`n`n"
}

Set-Location $cwd
