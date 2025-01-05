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

    $Endpoint = Join-Url -Segments @($Server, "/console/api/system-features")
    $Method = "GET"
    try {
        $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method
    }
    catch {
        throw "Failed to obtain system features: $_"
    }
    $PluginSupport = $Response.enable_marketplace -ne $null

    return [PSCustomObject]@{
        "Server"  = $Server
        "Version" = $Version
        "PluginSupport" = $PluginSupport
    }
}
