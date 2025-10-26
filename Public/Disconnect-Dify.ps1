function Disconnect-Dify {
    [CmdletBinding()]
    param(
        [Switch] $Force = $false
    )

    try {
        $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/logout")
        if (Compare-SimpleVersion -Version $env:PSDIFY_VERSION -Ge "1.9.2") {
            $Method = "POST"
        }
        else {
            $Method = "GET"
        }
        $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
    }
    catch {
        if (-not $Force) {
            throw "Failed to logout: $_"
        }
    }
    if (-not $Force -and (-not $Response.result -or $Response.result -ne "success")) {
        throw "Failed to logout"
    }

    $script:PSDIFY_CONSOLE_AUTH = $null

    $env:PSDIFY_URL = $null
    $env:PSDIFY_AUTH_METHOD = $null
    $env:PSDIFY_EMAIL = $null
    $env:PSDIFY_PASSWORD = $null
    $env:PSDIFY_VERSION = $null
    $env:PSDIFY_DISABLE_SSL_VERIFICATION = $null

    $env:PSDIFY_PLUGIN_SUPPORT = $null
}
