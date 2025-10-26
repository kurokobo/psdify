function Get-DifyAppAPIKey {
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
        $Method = "GET"
        try {
            $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
        }
        catch {
            throw "Failed to obtain api keys: $_"
        }

        $APIKeys = @()
        foreach ($APIKey in $Response.data) {
            $APIKeys += [PSCustomObject]@{
                AppId      = $App.Id
                Id         = $APIKey.id
                Type       = $APIKey.type
                Token      = $APIKey.token
                LastUsedAt = Convert-UnixTimeToLocalDateTime($APIKey.last_used_at)
                CreatedAt  = Convert-UnixTimeToLocalDateTime($APIKey.created_at)
            }
        }
        return $APIKeys
    }
}
