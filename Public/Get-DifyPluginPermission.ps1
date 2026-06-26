function Get-DifyPluginPermission {
    [CmdletBinding()]
    param()

    if (-not $env:PSDIFY_PLUGIN_SUPPORT) {
        throw "You are not logged in to a Dify server yet, or the Dify server currently logged in does not support plugins."
    }

    if (Compare-SimpleVersion -Version $env:PSDIFY_VERSION -Ge "1.15.0") {
        $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current/plugin/permission/fetch")
    }
    else {
        $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current/plugin/preferences/fetch")
    }
    $Method = "GET"
    try {
        $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
    }
    catch {
        throw "Failed to get plugin permission: $_"
    }

    if (Compare-SimpleVersion -Version $env:PSDIFY_VERSION -Ge "1.15.0") {
        if (-not $Response.install_permission -or -not $Response.debug_permission) {
            throw "Failed to get plugin permission: Unexpected response"
        }
        $Permission = [PSCustomObject]@{
            InstallPermission = $Response.install_permission
            DebugPermission   = $Response.debug_permission
        }
    }
    else {
        if (-not $Response.permission) {
            throw "Failed to get plugin permission: Unexpected response"
        }
        $Permission = [PSCustomObject]@{
            InstallPermission = $Response.permission.install_permission
            DebugPermission   = $Response.permission.debug_permission
        }
    }

    return $Permission
}
