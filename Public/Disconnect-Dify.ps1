function Disconnect-Dify {
    [CmdletBinding()]
    param(
        [Switch] $Force = $false
    )

    try {
        $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/logout")
        $Method = "GET"
        $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Token $env:PSDIFY_CONSOLE_TOKEN
    }
    catch {
        if (-not $Force) {
            throw "Failed to logout: $_"
        }
    }
    if (-not $Force -and (-not $Response.result -or $Response.result -ne "success")) {
        throw "Failed to logout"
    }

    $env:PSDIFY_URL = $null
    $env:PSDIFY_AUTH_METHOD = $null
    $env:PSDIFY_EMAIL = $null
    $env:PSDIFY_PASSWORD = $null
    $env:PSDIFY_CONSOLE_TOKEN = $null
    $env:PSDIFY_CONSOLE_REFRESH_TOKEN = $null
    $env:PSDIFY_VERSION = $null
    $env:PSDIFY_DISABLE_SSL_VERIFICATION = $null

    $env:PSDIFY_PLUGIN_SUPPORT = $null
    $env:PSDIFY_MARKETPLACE_API_PREFIX = $null
}
