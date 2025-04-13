function Find-DifyPlugin {
    [CmdletBinding()]
    param(
        [String] $Category = "",
        [String] $Id = "",
        [String] $Name = "",
        [String] $Search = "",
        [Switch] $Download
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
            $DownloadUrl = Join-Url -Segments @($MarketPlaceApiPrefix, "/plugins/$($Plugin.plugin_id)/$($Plugin.latest_version)/download")
            $PluginObj = [PSCustomObject]@{
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
                DownloadUrl             = $DownloadUrl
            }
            $Plugins += $PluginObj
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
                $DownloadUrl = Join-Url -Segments @($MarketPlaceApiPrefix, "plugins", $Plugin.plugin_id, $Plugin.latest_version, "download")
                $PluginObj = [PSCustomObject]@{
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
                    DownloadUrl             = $DownloadUrl
                }
                $Plugins += $PluginObj
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

    if ($Download) {
        if (@($Plugins).Count -eq 0) {
            throw "No plugins found to download"
        }

        $DownloadedFiles = @()
        foreach ($Plugin in $Plugins) {
            $PluginId = $Plugin.Id
            $PluginVersion = $Plugin.LatestVersion
            $DownloadUrl = $Plugin.DownloadUrl

            $FileName = "$($PluginId.Replace('/', '-'))_$($PluginVersion).difypkg"
            $OutputPath = Join-Path -Path (Get-Location) -ChildPath $FileName

            try {
                Invoke-WebRequest -Uri $DownloadUrl -OutFile $OutputPath
                $DownloadedFiles += Get-Item -Path $OutputPath
            }
            catch {
                Write-Warning "Failed to download plugin $($PluginId): $_"
            }
        }

        if (@($DownloadedFiles).Count -eq 0) {
            throw "Failed to download any plugins"
        }
        return $DownloadedFiles
    }
    else {
        return $Plugins
    }
}
