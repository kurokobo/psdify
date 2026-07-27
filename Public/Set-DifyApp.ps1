function Set-DifyApp {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject[]] $App = @(),
        [Switch] $SyncFromSite,
        [String] $Name = "",
        [String] $Description = "",
        [String] $Icon = "",
        [String] $IconType = "",
        [String] $IconBackground = ""
    )

    begin {
        $Apps = @()
        if ($SyncFromSite -and ($Name -or $Description -or $Icon -or $IconType -or $IconBackground)) {
            throw "Cannot combine -SyncFromSite with other parameters"
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
            $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/apps", $AppObject.Id)

            if ($SyncFromSite) {
                $AppDetail = Get-DifyApp -Id $AppObject.Id -Detail
                $Body = @{
                    "name"             = if ($AppDetail.SiteTitle) { $AppDetail.SiteTitle } else { $AppObject.Name }
                    "description"      = $AppDetail.SiteDescription
                    "icon"             = if ($AppDetail.SiteIcon) { $AppDetail.SiteIcon } else { $AppDetail.Icon }
                    "icon_type"        = if ($AppDetail.SiteIconType) { $AppDetail.SiteIconType } else { $AppDetail.IconType }
                    "icon_background"  = if ($AppDetail.SiteIconBackground) { $AppDetail.SiteIconBackground } else { $AppDetail.IconBackground }
                } | ConvertTo-Json
                try {
                    $null = Invoke-DifyRestMethod -Uri $Endpoint -Method "PUT" -Body $Body -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
                }
                catch {
                    throw "Failed to sync site to app: $_"
                }
            }
            else {
                try {
                    $CurrentDetails = Invoke-DifyRestMethod -Uri $Endpoint -Method "GET" -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
                }
                catch {
                    throw "Failed to obtain app details: $_"
                }

                $CurrentIcon = if ($CurrentDetails.icon) { $CurrentDetails.icon } else { "" }
                $CurrentIconType = if ($CurrentDetails.icon_type) { $CurrentDetails.icon_type } else { "emoji" }
                $CurrentIconBackground = if ($CurrentDetails.icon_background) { $CurrentDetails.icon_background } else { "" }

                $Body = @{
                    "name"             = if ($Name) { $Name } else { $AppObject.Name }
                    "description"      = if ($Description) { $Description } else { $AppObject.Description }
                    "icon"             = if ($Icon) { $Icon } else { $CurrentIcon }
                    "icon_type"        = if ($IconType) { $IconType } else { $CurrentIconType }
                    "icon_background"  = if ($IconBackground) { $IconBackground } else { $CurrentIconBackground }
                } | ConvertTo-Json
                try {
                    $null = Invoke-DifyRestMethod -Uri $Endpoint -Method "PUT" -Body $Body -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
                }
                catch {
                    throw "Failed to update app: $_"
                }
            }
        }

        $UpdatedApps = @()
        foreach ($AppObject in $Apps) {
            $UpdatedApps += Get-DifyApp -Id $AppObject.Id
        }
        return $UpdatedApps
    }
}
