function Invoke-DifyAppTraceConfig {
    param(
        [PSCustomObject] $App,
        [String] $Provider,
        [Hashtable] $Config,
        [String] $Method
    )

    if (-not $App) { throw "App is required" }
    if (-not $Provider) { throw "Provider is required" }
    if (-not $Config) { throw "Config is required" }

    $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/apps", $App.Id, "/trace-config")
    $Body = @{
        "tracing_provider" = $Provider
        "tracing_config"   = $Config
    } | ConvertTo-Json
    try {
        $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body -Token $env:PSDIFY_CONSOLE_TOKEN
    }
    catch {
        if ($Method -eq "POST") {
            throw "Failed to create new app trace config: $_"
        } elseif ($Method -eq "PATCH") {
            throw "Failed to update app trace config: $_"
        }
    }

    if (-not $Response.result -or $Response.result -ne "success") {
        if ($Method -eq "POST") {
            throw "Failed to create new app trace config: $($Response | ConvertTo-Json -Depth 100 -Compress)"
        } elseif ($Method -eq "PATCH") {
            throw "Failed to update app trace config: $($Response | ConvertTo-Json -Depth 100 -Compress)"
        }
    }
}
