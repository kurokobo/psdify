function Get-DifyAppTrace {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject] $App = $null
    )

    end {
        if (-not $App) {
            throw "App is required"
        }

        $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/apps", $App.Id, "/trace")
        $Method = "GET"
        try {
            $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
        }
        catch {
            throw "Failed to obtain app trace: $_"
        }

        return [PSCustomObject]@{
            AppId           = $App.Id
            Enabled         = $Response.enabled
            Provider = $Response.tracing_provider
        }
    }
}
