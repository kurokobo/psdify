function Get-DifyVersion {
    [CmdletBinding()]
    param(
        [String] $Server
    )

    # Validate parameter: Server
    if ($env:PSDIFY_URL) {
        $Server = $env:PSDIFY_URL
    }
    if (-not $Server) {
        throw "Server URL is required"
    }

    $Endpoint = Join-Url -Segments @($Server, "/console/api/version")
    $Method = "GET"
    $Query = @{
        "current_version" = ""
    }
    try {
        $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Query $Query
    }
    catch {
        throw "Failed to obtain version: $_"
    }

    $Version = $Response.version
    return [PSCustomObject]@{
        "Server"  = $Server
        "Version" = $Version
    }
}
