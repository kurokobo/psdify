function Remove-DifyAppAPIKey {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject[]] $APIKey = @()
    )

    begin {
        $APIKeys = @()
    }

    process {
        foreach ($APIKeyObject in $APIKey) {
            $APIKeys += $APIKeyObject
        }
    }

    end {
        foreach ($APIKey in $APIKeys) {
            $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/apps", $APIKey.AppId, "/api-keys", $APIKey.Id)
            $Method = "DELETE"
            if ($PSCmdlet.ShouldProcess("$($APIKey.Name) ($($APIKey.Id))", "Remove APIKey")) {
                try {
                    $null = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Token $env:PSDIFY_CONSOLE_TOKEN
                }
                catch {
                    throw "Failed to remove api key: $_"
                }
            }
        }

        return
    }
}
