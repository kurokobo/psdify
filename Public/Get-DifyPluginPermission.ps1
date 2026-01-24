function Get-DifyPluginPermission {
    [CmdletBinding()]
    param()

    if (-not $env:PSDIFY_PLUGIN_SUPPORT) {
        throw "You are not logged in to a Dify server yet, or the Dify server currently logged in does not support plugins."
    }

    $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current/plugin/preferences/fetch")
    $Method = "GET"
    try {
        $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
    }
    catch {
        throw "Failed to get plugin permission: $_"
    }

    if (-not $Response.permission) {
        throw "Failed to get plugin permission: Unexpected response"
    }

    $Permission = [PSCustomObject]@{
        InstallPermission = $Response.permission.install_permission
        DebugPermission   = $Response.permission.debug_permission
    }

    return $Permission
}
