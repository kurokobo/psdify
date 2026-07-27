function Set-DifyAppSite {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject[]] $App = @(),
        [Switch] $Enable,
        [Switch] $Disable,
        [Switch] $SyncFromApp,
        [String] $Title = "",
        [String] $Description = "",
        [String] $Icon = "",
        [String] $IconType = "",
        [String] $IconBackground = "",
        [String] $Language = ""
    )

    begin {
        $Apps = @()
        if ($Enable -and $Disable) {
            throw "Cannot specify both -Enable and -Disable"
        }
        if ($SyncFromApp -and ($Enable -or $Disable -or $Title -or $Description -or $Icon -or $IconType -or $IconBackground -or $Language)) {
            throw "Cannot combine -SyncFromApp with other parameters"
        }
        if (-not $Enable -and -not $Disable -and -not $SyncFromApp -and -not $Title -and -not $Description -and -not $Icon -and -not $IconType -and -not $IconBackground -and -not $Language) {
            throw "At least one parameter must be specified"
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
            if ($SyncFromApp) {
                $AppDetail = Get-DifyApp -Id $AppObject.Id -Detail
                $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/apps", $AppObject.Id, "/site")
                $Body = @{
                    "title"            = $AppObject.Name
                    "description"      = $AppObject.Description
                    "icon"             = $AppDetail.Icon
                    "icon_type"        = $AppDetail.IconType
                    "icon_background"  = $AppDetail.IconBackground
                } | ConvertTo-Json
                try {
                    $null = Invoke-DifyRestMethod -Uri $Endpoint -Method "POST" -Body $Body -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
                }
                catch {
                    throw "Failed to sync app to site: $_"
                }
            }
            else {
                if ($Enable -or $Disable) {
                    $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/apps", $AppObject.Id, "/site-enable")
                    $Method = "POST"
                    $Body = @{
                        "enable_site" = [bool]$Enable
                    } | ConvertTo-Json
                    try {
                        $null = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
                    }
                    catch {
                        throw "Failed to set app site status: $_"
                    }
                }

                $SiteBody = @{}
                if ($Title) { $SiteBody["title"] = $Title }
                if ($Description) { $SiteBody["description"] = $Description }
                if ($Icon) { $SiteBody["icon"] = $Icon }
                if ($IconType) { $SiteBody["icon_type"] = $IconType }
                if ($IconBackground) { $SiteBody["icon_background"] = $IconBackground }
                if ($Language) { $SiteBody["default_language"] = $Language }

                if ($SiteBody.Count -gt 0) {
                    $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/apps", $AppObject.Id, "/site")
                    $Method = "POST"
                    $Body = $SiteBody | ConvertTo-Json
                    try {
                        $null = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
                    }
                    catch {
                        throw "Failed to update app site settings: $_"
                    }
                }
            }
        }

        $Results = @()
        foreach ($AppObject in $Apps) {
            $Results += Get-DifyApp -Id $AppObject.Id -Detail
        }
        return $Results
    }
}
