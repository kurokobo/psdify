function Join-Url {
    param (
        [Parameter(Mandatory = $true)]
        [string[]] $Segments
    )
    $TrimmedSegments = $Segments | ForEach-Object { $_.TrimEnd('/').TrimStart('/') }
    return ($TrimmedSegments -join '/')
}

