function Set-DifyPluginPermission {
    [CmdletBinding()]
    param(
        [ValidateSet("everyone", "admins", "noone")]
        [String] $InstallPermission,
        [ValidateSet("everyone", "admins", "noone")]
        [String] $DebugPermission
    )

    if (-not $env:PSDIFY_PLUGIN_SUPPORT) {
        throw "You are not logged in to a Dify server yet, or the Dify server currently logged in does not support plugins."
    }
    if (-not $InstallPermission -and -not $DebugPermission) {
        throw "InstallPermission or DebugPermission is required"
    }

    if (Compare-SimpleVersion -Version $env:PSDIFY_VERSION -Ge "1.15.0") {
        $Current = Get-DifyPluginPermission
        $TargetInstallPermission = if ($InstallPermission) { $InstallPermission } else { $Current.InstallPermission }
        $TargetDebugPermission = if ($DebugPermission) { $DebugPermission } else { $Current.DebugPermission }

        if ($TargetInstallPermission -eq $Current.InstallPermission -and $TargetDebugPermission -eq $Current.DebugPermission) {
            return [PSCustomObject]@{
                InstallPermission = $Current.InstallPermission
                DebugPermission   = $Current.DebugPermission
            }
        }

        $ChangeEndpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current/plugin/permission/change")
        $Body = @{
            install_permission = $TargetInstallPermission
            debug_permission   = $TargetDebugPermission
        } | ConvertTo-Json
    }
    else {
        $FetchEndpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current/plugin/preferences/fetch")
        try {
            $Current = Invoke-DifyRestMethod -Uri $FetchEndpoint -Method "GET" -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
        }
        catch {
            throw "Failed to fetch plugin preferences: $_"
        }

        if (-not $Current.permission) {
            throw "Failed to fetch plugin preferences: Unexpected response"
        }

        $TargetInstallPermission = if ($InstallPermission) { $InstallPermission } else { $Current.permission.install_permission }
        $TargetDebugPermission = if ($DebugPermission) { $DebugPermission } else { $Current.permission.debug_permission }

        if ($TargetInstallPermission -eq $Current.permission.install_permission -and $TargetDebugPermission -eq $Current.permission.debug_permission) {
            return [PSCustomObject]@{
                InstallPermission = $Current.permission.install_permission
                DebugPermission   = $Current.permission.debug_permission
            }
        }

        $BodyObject = $Current | ConvertTo-Json -Depth 20 | ConvertFrom-Json
        $BodyObject.permission.install_permission = $TargetInstallPermission
        $BodyObject.permission.debug_permission = $TargetDebugPermission

        $ChangeEndpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current/plugin/preferences/change")
        $Body = $BodyObject | ConvertTo-Json -Depth 10
    }

    try {
        $Response = Invoke-DifyRestMethod -Uri $ChangeEndpoint -Method "POST" -Body $Body -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
    }
    catch {
        throw "Failed to set plugin permission: $_"
    }

    if (-not $Response.success) {
        throw "Failed to set plugin permission: Unexpected response"
    }

    return Get-DifyPluginPermission
}
