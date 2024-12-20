function Import-DifyApp {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject[]] $Item = @(),
        [String[]] $Path = @()
    )

    begin {
        $Files = @()
    }

    process {
        foreach ($ItemObject in $Item) {
            $Files += $ItemObject
        }
    }

    end {
        if (-not $Files -and -not $Path) {
            throw "Path is required"
        }
        if ($Path) {
            $Files += Get-ChildItem -Path $Path
        }

        $Members = Get-DifyMember

        $ImportedApps = @()
        foreach ($File in $Files) {
            Write-Verbose "importing app from file: $($File.FullName)"
            $UTF8NoBOM = New-Object "System.Text.UTF8Encoding" -ArgumentList @($false)
            $RawContent = [System.IO.File]::ReadAllText($File.FullName, $UTF8NoBOM)

            if ([System.Version]$env:PSDIFY_VERSION -lt [System.Version]"0.12.0") {
                $Endpoint = "$($env:PSDIFY_URL)/console/api/apps/import"
                $Method = "POST"
                $Body = $UTF8NoBOM.GetBytes((@{
                            "data" = $RawContent
                        } | ConvertTo-Json))
                try {
                    $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body -Token $env:PSDIFY_CONSOLE_TOKEN
                }
                catch {
                    throw "Failed to import apps: $_"
                }
            
                $CreatedBy = $Members | Where-Object { $_.Id -eq $Response.created_by } | Select-Object -ExpandProperty Email
                if (-not $CreatedBy) {
                    $CreatedBy = $Response.created_by
                }
                $UpdatedBy = $Members | Where-Object { $_.Id -eq $Response.updated_by } | Select-Object -ExpandProperty Email
                if (-not $UpdatedBy) {
                    $UpdatedBy = $Response.updated_by
                }
                $ImportedApp = [PSCustomObject]@{
                    Id          = $Response.id
                    Name        = $Response.name
                    Description = $Response.description
                    Mode        = $Response.mode
                    CreatedBy   = $CreatedBy
                    CreatedAt   = Convert-UnixTimeToLocalDateTime($Response.created_at)
                    UpdatedBy   = $UpdatedBy
                    UpdatedAt   = Convert-UnixTimeToLocalDateTime($Response.updated_at)
                    Tags        = @()
                }
                $ImportedApps += $ImportedApp
            }
            else {
                $Endpoint = "$($env:PSDIFY_URL)/console/api/apps/imports"
                $Method = "POST"
                $Body = $UTF8NoBOM.GetBytes((@{
                            "mode"         = "yaml-content"
                            "yaml_content" = $RawContent
                        } | ConvertTo-Json))
                try {
                    $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body -Token $env:PSDIFY_CONSOLE_TOKEN
                }
                catch {
                    throw "Failed to import apps: $_"
                }

                if ($Response.status -ne "completed") {
                    throw "Failed to import apps: $($Response | ConvertTo-Json -Depth 100 -Compress)"
                }

                $ImportedApps += Get-DifyApp -Id $Response.app_id
            }

        }
        return $ImportedApps
    }
}
