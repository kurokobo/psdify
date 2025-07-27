function Get-DifyAppTraceConfig {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject] $App = $null,
        [String[]] $Provider = @()
    )

    end {
        if (-not $App) {
            throw "App is required"
        }
        if (-not $Provider) {
            $Providers = @("langfuse", "langsmith", "opik", "weave", "arize", "phoenix")
        }
        else {
            $Providers = $Provider
        }

        $AppTrace = Get-DifyAppTrace -App $App

        $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/apps", $App.Id, "/trace-config")
        $Method = "GET"
        $TraceConfig = @()
        foreach ($ProviderName in $Providers) {
            $Query = @{
                "tracing_provider" = $ProviderName
            }
            try {
                $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Token $env:PSDIFY_CONSOLE_TOKEN -Query $Query
            }
            catch {
                throw "Failed to obtain app trace config for $($ProviderName): $_"
            }

            if ($Response.has_not_configured) {
                $TraceConfig += [PSCustomObject]@{
                    AppId     = $App.Id
                    Id        = $null
                    Provider  = $ProviderName
                    IsEnabled = $false
                    IsActive  = $false
                    Config    = $null
                    CreatedAt = $null
                    UpdatedAt = $null
                }
            }
            else {
                $IsEnabled = $AppTrace.Enabled -and ($ProviderName.ToLower() -eq $AppTrace.Provider.ToLower())
                $TraceConfig += [PSCustomObject]@{
                    AppId     = $App.Id
                    Id        = $Response.id
                    Provider  = $Response.tracing_provider
                    IsEnabled = $IsEnabled
                    IsActive  = $Response.is_active
                    Config    = $Response.tracing_config
                    CreatedAt = $Response.created_at
                    UpdatedAt = $Response.updated_at
                }
            }
        }
        return $TraceConfig
    }
}
