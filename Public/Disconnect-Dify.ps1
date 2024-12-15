function Disconnect-Dify {
    [CmdletBinding()]
    param(
        [Switch] $Force = $false
    )

    $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/logout")
    $Method = "GET"
    try {
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
    Remove-Item Env:\PSDIFY_CONSOLE_TOKEN -ErrorAction SilentlyContinue
    Remove-Item Env:\PSDIFY_CONSOLE_REFRESH_TOKEN -ErrorAction SilentlyContinue
    Remove-Item Env:\PSDIFY_VERSION -ErrorAction SilentlyContinue
    Remove-Item Env:\PSDIFY_DISABLE_SSL_VERIFICATION -ErrorAction SilentlyContinue
}
