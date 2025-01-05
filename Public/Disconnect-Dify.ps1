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

    Remove-Item Env:\PSDIFY_URL -ErrorAction SilentlyContinue
    Remove-Item Env:\PSDIFY_AUTH_METHOD -ErrorAction SilentlyContinue
    Remove-Item Env:\PSDIFY_EMAIL -ErrorAction SilentlyContinue
    Remove-Item Env:\PSDIFY_PASSWORD -ErrorAction SilentlyContinue
    Remove-Item Env:\PSDIFY_CONSOLE_TOKEN -ErrorAction SilentlyContinue
    Remove-Item Env:\PSDIFY_CONSOLE_REFRESH_TOKEN -ErrorAction SilentlyContinue
    Remove-Item Env:\PSDIFY_VERSION -ErrorAction SilentlyContinue
    Remove-Item Env:\PSDIFY_DISABLE_SSL_VERIFICATION -ErrorAction SilentlyContinue

    Remove-Item Env:\PSDIFY_PLUGIN_SUPPORT -ErrorAction SilentlyContinue
    Remove-Item Env:\PSDIFY_MARKETPLACE_API_PREFIX -ErrorAction SilentlyContinue
}
