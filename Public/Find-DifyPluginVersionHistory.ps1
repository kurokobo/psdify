function Find-DifyPluginVersionHistory {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject] $Plugin = $null,
        [String] $Id = "",
        [String] $Version = "",
        [Switch] $Download
    )

    if ($Download -and -not $Version) {
        throw "When using -Download, -Version must also be specified"
    }
    if (-not $Plugin -and -not $Id) {
        throw "Either Plugin or Id is required"
    }
    if ($Plugin) {
        $Id = $Plugin.Id
    }

    # Use the public marketplace API
    $MarketPlaceApiPrefix = "https://marketplace.dify.ai/api/v1"

    $VersionHistories = @()
    $Endpoint = Join-Url -Segments @($MarketPlaceApiPrefix, "plugins", $Id, "versions")
    $Method = "GET"
    $Page = 1
    $PageSize = 100
    $HasMore = $true

    while ($HasMore) {
        $Uri = "$($Endpoint)?page=$($Page)&page_size=$($PageSize)"
        try {
            $Response = Invoke-RestMethod -Uri $Uri -Method $Method -UseBasicParsing -ErrorAction Stop
        }
        catch {
            throw "Failed to obtain plugin details: $_"
        }
        if ($Response.code -ne 0) {
            throw "Failed to obtain plugin details: $($Response.msg)"
        }

        $VersionsInPage = @($Response.data.versions)
        foreach ($History in $VersionsInPage) {
            $VersionObj = [PSCustomObject]@{
                Id                 = $Id
                Version            = $History.version
                Tuple              = $History.plugin_tuple
                UniqueIdentifier   = $History.unique_identifier
                Checksum           = $History.checksum
                CreatedAt          = [datetime]::Parse($History.created_at)
                DownloadUrl        = Join-Url -Segments @($MarketPlaceApiPrefix, "plugins", $Id, $History.version, "download")
                MinimumDifyVersion = [string]($History.minimum_dify_version_major) + "." + [string]($History.minimum_dify_version_minor) + "." + [string]($History.minimum_dify_version_patch)
                Status             = $History.status
            }
            $VersionHistories += $VersionObj
        }

        if ($VersionsInPage.Count -lt $PageSize) {
            $HasMore = $false
        }
        else {
            $Page++
        }
    }
    if ($Version) {
        $VersionHistories = $VersionHistories | Where-Object { $_.Version -eq $Version }
    }

    if ($Version -and $Download) {
        if (@($VersionHistories).Count -eq 0) {
            throw "No plugin version found to download: $($Id):$($Version)"
        }
        $VersionHistories = @($VersionHistories)
        $PluginId = $VersionHistories[0].Id
        $PluginVersion = $VersionHistories[0].Version
        $DownloadUrl = $VersionHistories[0].DownloadUrl

        $FileName = "$($PluginId.Replace('/', '-'))_$($PluginVersion).difypkg"
        $OutputPath = Join-Path -Path (Get-Location) -ChildPath $FileName

        try {
            Invoke-WebRequest -Uri $DownloadUrl -OutFile $OutputPath -UseBasicParsing
            $DownloadedFiles = Get-Item -Path $OutputPath
        }
        catch {
            Write-Warning "Failed to download plugin $($PluginId): $_"
        }
        return $DownloadedFiles
    }

    return $VersionHistories
}
