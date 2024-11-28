function Set-DifyDSLContent {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [String] $Content = "",
        [String] $Path = ""
    )

    if (-not $Path) {
        throw "Path is required"
    }
    if (-not $Content) {
        throw "Content is required"
    }

    if (-not (Test-Path -Path $Path)) {
        $File = New-Item -Path $Path -ItemType File
    }
    else {
        $File = Get-Item -Path $Path
    }

    $UTF8NoBOM = New-Object "System.Text.UTF8Encoding" -ArgumentList @($false)
    [System.IO.File]::WriteAllText($File.FullName, $Content, $UTF8NoBOM)

    return $File
}
