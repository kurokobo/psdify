function Show-DifyConnectionStatus {
    param (
        [PSCustomObject] $Connection
    )

    Write-Host "Connected to:" -ForegroundColor Green
    Write-Host " Server     : $($Connection.Server)" -ForegroundColor Cyan
    Write-Host " Version    : $($Connection.Version)" -ForegroundColor Cyan
    if ($env:PSDIFY_PLUGIN_SUPPORT) {
        $PluginStatus = "enabled"
    }
    else {
        $PluginStatus = "disabled"
    }
    Write-Host " Plugin     : $PluginStatus" -ForegroundColor Cyan
}
