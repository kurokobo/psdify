function Install-DifyPlugin {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject[]] $Item = @(),
        [String[]] $Id = @(),
        [String[]] $UniqueIdentifier = @(),
        [Switch] $Wait = $false,
        [Int] $Interval = 5,
        [Int] $Timeout = 300
    )

    begin {
        $Plugins = @()
    }

    process {
        foreach ($ItemObject in $Item) {
            $Plugins += $ItemObject
        }
    }

    end {
        if (-not $Id -and -not $UniqueIdentifier -and -not $Plugins) {
            throw "Id or UniqueIdentifier is required"
        }

        $Identifiers = @()
        if ($Id) {
            foreach ($IdItem in $Id) {
                $Plugins += Find-DifyPlugin -Id $IdItem
            }
        }
        if ($UniqueIdentifier) {
            $Identifiers += $UniqueIdentifier
        }
        if ($Plugins) {
            $Identifiers += $Plugins | ForEach-Object { $_.LatestPackageIdentifier }
        }

        $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current/plugin/install/marketplace")
        $Method = "POST"
        $Body = @{
            "plugin_unique_identifiers" = @($Identifiers)
        } | ConvertTo-Json
        try {
            $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body -Token $env:PSDIFY_CONSOLE_TOKEN
        }
        catch {
            throw "Failed to install plugins: $_"
        }
        $TaskInfo = [PSCustomObject]@{
            AllInstalled = $Response.all_installed
            TaskId       = $Response.task_id
        }

        if ($Wait) {
            $Status = $TaskInfo | Get-DifyPluginInstallationStatus -Wait -Interval $Interval -Timeout $Timeout

            if ($Status.Status -eq "failed") {
                throw "Failed to install plugins: $($Status.Plugins | Where-Object { $_.Status -eq "failed" } | ForEach-Object { $_.DisplayName })"
            }
            $InstalledPlugins = Get-DifyPlugin -UniqueIdentifier $Identifiers
            return $InstalledPlugins
        }
        else {
            return $TaskInfo
        }
    }
}