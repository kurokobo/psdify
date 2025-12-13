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

    $VersionHistories  = @()
    $Endpoint = Join-Url -Segments @("https://marketplace.dify.ai/plugins", $Id)
    $Method = "GET"
    try {
        $Response = Invoke-WebRequest -Uri $Endpoint -Method $Method -UseBasicParsing
        $ScriptContents = [regex]::Matches(
            $Response.Content,
            '<script[^>]*>(.*?)</script>',
            'Singleline'
        ) | ForEach-Object {
            $_.Groups[1].Value
        }
        $PluginDetailRaw = ($ScriptContents | Where-Object { $_ -like "*unique_identifier*" })
        $PluginDetailObject = ($PluginDetailRaw -replace "self\.__next_f\.push\((.*)\)$", '$1' | ConvertFrom-Json)[1] -replace "[^{]*({.*})[^}]*$", '$1' | ConvertFrom-Json
        foreach ($History in $PluginDetailObject.versionHistory) {
            $VersionObj = [PSCustomObject]@{
                Id                 = $Id
                Version            = $History.version
                Tuple              = $History.plugin_tuple
                UniqueIdentifier   = $History.unique_identifier
                Checksum           = $History.checksum
                CreatedAt          = [datetime]::Parse($History.created_at)
                DownloadUrl        = Join-Url -Segments @("https://marketplace.dify.ai/api/v1", "plugins", $Id, $History.version, "download")
                MinimumDifyVersion = [string]($History.minimum_dify_version_major) + "." + [string]($History.minimum_dify_version_minor) + "." + [string]($History.minimum_dify_version_patch)
                Status             = $History.status
            }
            $VersionHistories += $VersionObj
        }
    }
    catch {
        throw "Failed to obtain plugin details: $_"
    }
    if ($Version) {
        $VersionHistories = $VersionHistories | Where-Object { $_.Version -eq $Version }
    }

    if ($Version -and $Download) {
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
