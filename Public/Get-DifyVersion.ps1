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

    $Endpoint = Join-Url -Segments @($Server, "/console/api/system-features")
    try {
        $Response = Invoke-WebRequest -Uri $Endpoint -Method GET
    }
    catch {
        throw "Failed to obtain system features: $_"
    }

    $Version = $Response.Headers["x-version"]
    $Body = $Response.Content | ConvertFrom-Json
    $PluginSupport = $null -ne $Body.enable_marketplace
    return [PSCustomObject]@{
        "Server"        = $Server
        "Version"       = [string]($Version)
        "PluginSupport" = $PluginSupport
    }
}
