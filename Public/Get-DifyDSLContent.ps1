function Get-DifyDSLContent {
    [CmdletBinding()]
    param(
        [String] $Path = ""
    )

    if (-not $Path) {
        throw "Path is required"
    }
    $File = Get-Item -Path $Path

    $UTF8NoBOM = New-Object "System.Text.UTF8Encoding" -ArgumentList @($false)
    $RawContent = [System.IO.File]::ReadAllText($File.FullName, $UTF8NoBOM)

    return $RawContent
}
