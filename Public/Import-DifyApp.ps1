function Import-DifyApp {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [object] $Item,
        [String[]] $Path = @(),
        [switch] $Content
    )

    begin {
        $Files = @()
    }

    process {
        if ($Content) {
            $Files = @(
                [PSCustomObject]@{
                    FullName = "Inline Content" 
                    Content  = $Item
                }
            )
        }
        else {
            foreach ($ItemObject in $Item) {
                $Files += $ItemObject
            }
        }
    }

    end {
        if (-not $Files -and -not $Path -and -not $RawContent) {
            throw "Path or Content is required"
        }
        if ($Path) {
            $Files += Get-ChildItem -Path $Path
        }

        $Members = Get-DifyMember

        $ImportedApps = @()
        foreach ($File in $Files) {
            Write-Verbose "importing app from file: $($File.FullName)"
            $UTF8NoBOM = New-Object "System.Text.UTF8Encoding" -ArgumentList @($false)
            if ($Content) {
                $RawContent = $File.Content
            }
            else {
                $RawContent = [System.IO.File]::ReadAllText($File.FullName, $UTF8NoBOM)
            }
            $SimplifiedVersion = $env:PSDIFY_VERSION -replace "[-+].*$", ""
            if ([System.Version]$SimplifiedVersion -lt [System.Version]"0.12.0") {
                $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/apps/import")
                $Method = "POST"
                $Body = @{
                    "data" = $RawContent
                } | ConvertTo-Json
                try {
                    $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
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
                $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/apps/imports")
                $Method = "POST"
                $Body = @{
                    "mode"         = "yaml-content"
                    "yaml_content" = $RawContent
                } | ConvertTo-Json
                try {
                    $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
                }
                catch {
                    throw "Failed to import apps: $_"
                }

                if (@("completed", "completed-with-warnings") -notcontains $Response.status) {
                    throw "Failed to import apps: $($Response | ConvertTo-Json -Depth 100 -Compress)"
                }

                $ImportedApps += Get-DifyApp -Id $Response.app_id
            }

        }
        return $ImportedApps
    }
}
