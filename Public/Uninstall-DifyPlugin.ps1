function Uninstall-DifyPlugin {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject[]] $Plugin = @()
    )

    begin {
        $Plugins = @()
    }

    process {
        foreach ($PluginObject in $Plugin) {
            $Plugins += $PluginObject
        }
    }

    end {
        foreach ($Plugin in $Plugins) {
            $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current/plugin/uninstall")
            $Method = "POST"
            $Body = @{
                "plugin_installation_id" = $Plugin.InstallationId
            } | ConvertTo-Json
            if ($PSCmdlet.ShouldProcess("$($Plugin.DisplayName) ($($Plugin.Id))", "Uninstall $($Plugin.Category) plugin")) {
                try {
                    $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body -Token $env:PSDIFY_CONSOLE_TOKEN
                }
                catch {
                    throw "Failed to uninstall plugin: $_"
                }

                if (-not $Response.success) {
                    throw "Failed to uninstall plugin: $($Response)"
                }
            }
        }

        return
    }
}
