function Set-DifyAppAPI {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject[]] $App = @(),
        [Switch] $Enable,
        [Switch] $Disable
    )

    begin {
        $Apps = @()
        if ($Enable -and $Disable) {
            throw "Cannot specify both -Enable and -Disable"
        }
        if (-not $Enable -and -not $Disable) {
            throw "Either -Enable or -Disable must be specified"
        }
    }

    process {
        foreach ($AppObject in $App) {
            $Apps += $AppObject
        }
    }

    end {
        if (-not $Apps) {
            throw "App is required"
        }
        foreach ($AppObject in $Apps) {
            $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/apps", $AppObject.Id, "/api-enable")
            $Method = "POST"
            $Body = @{
                "enable_api" = [bool]$Enable
            } | ConvertTo-Json
            try {
                $null = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
            }
            catch {
                throw "Failed to set app API status: $_"
            }
        }

        $Results = @()
        foreach ($AppObject in $Apps) {
            $Results += Get-DifyApp -Id $AppObject.Id -Detail
        }
        return $Results
    }
}
