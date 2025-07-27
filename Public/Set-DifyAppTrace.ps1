function Set-DifyAppTrace {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject] $App = $null,
        [String] $Provider = $null,
        [Switch] $Enable = $false,
        [Switch] $Disable = $false
    )

    end {
        if (-not $App) {
            throw "App is required"
        }
        if ($Enable -and $Disable) {
            throw "Cannot specify both -Enable and -Disable"
        }
        if ($Enable -and -not $Provider) {
            throw "Provider is required when enabling trace"
        }
        if (-not $Enable -and -not $Disable) {
            throw "Either -Enable or -Disable must be specified"
        }

        $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/apps", $App.Id, "/trace")
        $Method = "POST"
        if ($Enable) {
            $Body = @{
                "enabled"          = $true
                "tracing_provider" = $Provider
            } | ConvertTo-Json
        }
        elseif ($Disable) {
            $Body = @{
                "enabled"          = $false
                "tracing_provider" = $null
            } | ConvertTo-Json
        }
        try {
            $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Token $env:PSDIFY_CONSOLE_TOKEN -Body $Body
        }
        catch {
            throw "Failed to set app trace: $_"
        }
        if (-not $Response.result -or $Response.result -ne "success") {
            throw "Failed to set app trace: $($Response | ConvertTo-Json -Depth 100 -Compress)"
        }

        return Get-DifyAppTrace -App $App
    }
}
