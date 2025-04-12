function Find-DifyPlugin {
    [CmdletBinding()]
    param(
        [String] $Category = "",
        [String] $Id = "",
        [String] $Name = "",
        [String] $Search = ""
    )


    $ValidCategories = @("model", "tool", "agent", "extension", "bundle")
    if ($Category -and $Category -notin $ValidCategories) {
        throw "Invalid value for Category. Must be one of: $($ValidCategories -join ', ')"
    }
    if ($Category -eq "agent") {
        $Category = "agent-strategy"
    }

    # Use the public marketplace API
    $MarketPlaceApiPrefix = "https://marketplace.dify.ai/api/v1"

    # get available plugins
    $Plugins = @()
    if ($Id) {
        $Endpoint = Join-Url -Segments @($MarketPlaceApiPrefix, "/plugins/batch")
        $Method = "POST"
        $Body = @{
            "plugin_ids" = @($Id)
        } | ConvertTo-Json
        try {
            $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body
        }
        catch {
            throw "Failed to obtain plugins: $_"
        }
        $PluginsInPage = $Response.data.plugins
        foreach ($Plugin in $PluginsInPage) {
            $Plugins += [PSCustomObject]@{
                Category                = $Plugin.category
                Name                    = $Plugin.name
                Type                    = $Plugin.type
                DisplayName             = $Plugin.label.en_US
                Id                      = $Plugin.plugin_id
                Brief                   = $Plugin.brief.en_US
                InstallCount            = $Plugin.install_count
                UpdatedAt               = $Plugin.version_updated_at
                LatestVersion           = $Plugin.latest_version
                LatestPackageIdentifier = $Plugin.latest_package_identifier
            }
        }
    }
    else {
        $Endpoint = Join-Url -Segments @($MarketPlaceApiPrefix, "/plugins/search/basic")
        $Method = "POST"
        $Page = 1
        $PageSize = 100
        $HasMore = $true
    
        while ($HasMore) {
            $Body = @{
                "page"      = $Page
                "page_size" = $PageSize
            }
            if ($Search) {
                $Body.query = $Search
            }
            if ($Category) {
                $Body.category = $Category
            }
            $Body = $Body | ConvertTo-Json

            try {
                $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body
            }
            catch {
                throw "Failed to obtain plugins: $_"
            }
            if ($Response.code -ne 0) {
                throw "Failed to obtain plugins: $($Response.msg)"
            }

            $PluginsInPage = $Response.data.plugins
            if (-not $PluginsInPage) {
                $HasMore = $false
            }
            foreach ($Plugin in $PluginsInPage) {
                $Plugins += [PSCustomObject]@{
                    Category                = $Plugin.category
                    Name                    = $Plugin.name
                    Type                    = $Plugin.type
                    DisplayName             = $Plugin.label.en_US
                    Id                      = $Plugin.plugin_id
                    Brief                   = $Plugin.brief.en_US
                    InstallCount            = $Plugin.install_count
                    UpdatedAt               = $Plugin.version_updated_at
                    LatestVersion           = $Plugin.latest_version
                    LatestPackageIdentifier = $Plugin.latest_package_identifier
                }
            }

            if ($Response.data.total -lt $PageSize) {
                $HasMore = $false
            }
            else {
                $Page++
            }
        }
        if ($Name) {
            $Plugins = $Plugins | Where-Object { $_.Name -in $Name }
        }
        if ($Search) {
            $Plugins = $Plugins | Where-Object { $_.Id -like "*$($Search)*" -or $_.Name -like "*$($Search)*" -or $_.DisplayName -like "*$($Search)*" }
        }
    }

    return $Plugins
}
