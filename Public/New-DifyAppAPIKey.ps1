function New-DifyAppAPIKey {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject] $App = $null
    )

    end {
        if (-not $App) {
            throw "App is required"
        }

        $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/apps", $App.Id, "/api-keys")
        $Method = "POST"
        try {
            $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
        }
        catch {
            throw "Failed to create new api key: $_"
        }

        $APIKey = [PSCustomObject]@{
            AppId      = $App.Id
            Id         = $Response.id
            Type       = $Response.type
            Token      = $Response.token
            LastUsedAt = Convert-UnixTimeToLocalDateTime($Response.last_used_at)
            CreatedAt  = Convert-UnixTimeToLocalDateTime($Response.created_at)
        }
        return $APIKey
    }
}
