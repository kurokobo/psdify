function Get-DifyApp {
    [CmdletBinding()]
    param(
        [String] $Id = "",
        [String] $Name = "",
        [String] $Search = "",
        [String] $Mode = "",
        [String[]] $Tags = @(),
        [Switch] $Detail
    )

    $ValidModes = @("chat", "workflow", "agent-chat", "channel", "all")
    if ($Mode -and $Mode -notin $ValidModes) {
        throw "Invalid value for Mode. Must be one of: $($ValidModes -join ', ')"
    }

    $Query = @{
        "page"  = 1
        "limit" = 100
    }
    if ($Search) {
        $Query.name = $Search
    }
    if ($Mode) {
        $Query.mode = $Mode
    }
    if ($Tags) {
        $QueryTags = Get-DifyAppTag -Name $Tags
        $Query.tag_ids = ($QueryTags | ForEach-Object { $_.Id }) -join ","
    }

    $Members = Get-DifyMember

    $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/apps")
    $Method = "GET"
    $Apps = @()
    $HasMore = $true
    while ($HasMore) {
        try {
            $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Query $Query -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
        }
        catch {
            throw "Failed to obtain apps: $_"
        }

        foreach ($App in $Response.data) {
            $AppTags = @()
            foreach ($Tag in $App.tags) {
                $AppTags += $Tag.name
            }
            $CreatedBy = $Members | Where-Object { $_.Id -eq $App.created_by } | Select-Object -ExpandProperty Email
            if (-not $CreatedBy) {
                $CreatedBy = $App.created_by
            }
            $UpdatedBy = $Members | Where-Object { $_.Id -eq $App.updated_by } | Select-Object -ExpandProperty Email
            if (-not $UpdatedBy) {
                $UpdatedBy = $App.updated_by
            }
            $AppObject = [PSCustomObject]@{
                Id          = $App.id
                Name        = $App.name
                Description = $App.description
                Mode        = $App.mode
                CreatedBy   = $CreatedBy
                CreatedAt   = Convert-UnixTimeToLocalDateTime($App.created_at)
                UpdatedBy   = $UpdatedBy
                UpdatedAt   = Convert-UnixTimeToLocalDateTime($App.updated_at)
                Tags        = $AppTags
            }
            if ($Detail) {
                $DetailEndpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/apps", $App.id)
                try {
                    $DetailResponse = Invoke-DifyRestMethod -Uri $DetailEndpoint -Method "GET" -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
                }
                catch {
                    throw "Failed to obtain app details: $_"
                }
                Add-Member -InputObject $AppObject -NotePropertyName "Icon" -NotePropertyValue $DetailResponse.icon
                Add-Member -InputObject $AppObject -NotePropertyName "IconType" -NotePropertyValue $DetailResponse.icon_type
                Add-Member -InputObject $AppObject -NotePropertyName "IconBackground" -NotePropertyValue $DetailResponse.icon_background
                Add-Member -InputObject $AppObject -NotePropertyName "EnableSite" -NotePropertyValue $DetailResponse.enable_site
                Add-Member -InputObject $AppObject -NotePropertyName "EnableAPI" -NotePropertyValue $DetailResponse.enable_api
                Add-Member -InputObject $AppObject -NotePropertyName "SiteToken" -NotePropertyValue $DetailResponse.site.access_token
                Add-Member -InputObject $AppObject -NotePropertyName "SiteTitle" -NotePropertyValue $DetailResponse.site.title
                Add-Member -InputObject $AppObject -NotePropertyName "SiteDescription" -NotePropertyValue $DetailResponse.site.description
                Add-Member -InputObject $AppObject -NotePropertyName "SiteIcon" -NotePropertyValue $DetailResponse.site.icon
                Add-Member -InputObject $AppObject -NotePropertyName "SiteIconType" -NotePropertyValue $DetailResponse.site.icon_type
                Add-Member -InputObject $AppObject -NotePropertyName "SiteIconBackground" -NotePropertyValue $DetailResponse.site.icon_background
                Add-Member -InputObject $AppObject -NotePropertyName "SiteLanguage" -NotePropertyValue $DetailResponse.site.default_language
                Add-Member -InputObject $AppObject -NotePropertyName "APIBaseUrl" -NotePropertyValue $DetailResponse.api_base_url
            }
            if ($Id -and $AppObject.Id -eq $Id) {
                return $AppObject
            }
            $Apps += $AppObject
        }

        $HasMore = $Response.has_more
        $Query.page++
    }

    if ($Id) {
        $Apps = $Apps | Where-Object { $_.Id -eq $Id }
    }

    if ($Name) {
        $Apps = $Apps | Where-Object { $_.Name -eq $Name }
    }

    return $Apps
}
