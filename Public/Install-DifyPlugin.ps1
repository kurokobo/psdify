function Install-DifyPlugin {
    [CmdletBinding(DefaultParameterSetName = "Marketplace")]
    param(
        [Parameter(ValueFromPipeline = $true, ParameterSetName = "Marketplace")]
        [PSCustomObject[]] $Item = @(),
        [Parameter(ParameterSetName = "Marketplace")]
        [String[]] $Id = @(),
        [Parameter(ParameterSetName = "Marketplace")]
        [String[]] $UniqueIdentifier = @(),
        [Parameter(Mandatory = $true, ParameterSetName = "LocalFile")]
        [Object] $LocalFile,
        [Parameter(Mandatory = $true, ParameterSetName = "RemoteFile")]
        [String] $RemoteFile,
        [Switch] $Wait = $false,
        [Int] $Interval = 5,
        [Int] $Timeout = 300
    )

    begin {
        if (-not $env:PSDIFY_PLUGIN_SUPPORT) {
            throw "You are not logged in to a Dify server yet, or the Dify server currently logged in does not support plugins."
        }
        $Plugins = @()
    }

    process {
        switch ($PSCmdlet.ParameterSetName) {
            "Marketplace" {
                foreach ($ItemObject in $Item) {
                    $Plugins += $ItemObject
                }
            }
        }
    }

    end {
        # Helper function to process and upload a plugin file
        function Send-DifyPkgFile {
            param (
                [Parameter(Mandatory = $true)]
                [System.IO.FileInfo] $FileObj
            )

            # Upload the file
            $Result = New-TemporaryFileForBinaryUpload -File $FileObj -Name "pkg"
            $TemporaryFile = $Result.TemporaryFile
            $ContentType = $Result.ContentType

            $UploadEndpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current/plugin/upload/pkg")
            $UploadMethod = "POST"

            $UploadResponse = $null
            try {
                $UploadResponse = Invoke-DifyRestMethod -Uri $UploadEndpoint -Method $UploadMethod -ContentType $ContentType -InFile $TemporaryFile -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
            }
            catch {
                throw "Failed to upload plugin package: $_"
            }
            finally {
                if (Test-Path -Path $TemporaryFile) {
                    Remove-Item -Path $TemporaryFile -Force
                }
            }

            if (-not $UploadResponse.unique_identifier) {
                throw "Failed to upload plugin package: No unique identifier returned"
            }

            return $UploadResponse.unique_identifier
        }

        $Identifiers = @()
        $InstallEndpoint = ""
        $InstallMethod = "POST"

        switch ($PSCmdlet.ParameterSetName) {

            # Install from local file
            "LocalFile" {
                # Process FileInfo object or path string
                $FileObj = $null
                if ($LocalFile -is [System.IO.FileInfo]) {
                    $FileObj = $LocalFile
                } elseif ($LocalFile -is [String]) {
                    if (Test-Path -Path $LocalFile -PathType Leaf) {
                        $FileObj = Get-Item -Path $LocalFile
                    } else {
                        throw "File not found: $LocalFile"
                    }
                } else {
                    throw "LocalFile must be a FileInfo object or a file path string"
                }

                # Process the file and get identifier
                $Identifier = Send-DifyPkgFile -FileObj $FileObj
                $Identifiers = @($Identifier)
                $InstallEndpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current/plugin/install/pkg")
            }

            # Install from remote file
            "RemoteFile" {
                # Download the file to a temporary location
                $TempFilePath = Join-Path -Path $env:TEMP -ChildPath ([System.IO.Path]::GetFileName($RemoteFile))
                
                try {
                    Invoke-WebRequest -Uri $RemoteFile -OutFile $TempFilePath
                    $FileObj = Get-Item -Path $TempFilePath
                    
                    # Process the downloaded file
                    $Identifier = Send-DifyPkgFile -FileObj $FileObj
                    $Identifiers = @($Identifier)
                    $InstallEndpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current/plugin/install/pkg")
                }
                catch {
                    throw "Failed to download or process remote plugin package: $_"
                }
                finally {
                    # Clean up the downloaded file
                    if (Test-Path -Path $TempFilePath) {
                        Remove-Item -Path $TempFilePath -Force
                    }
                }
            }

            # Install from marketplace
            "Marketplace" {
                if (-not $Id -and -not $UniqueIdentifier -and -not $Plugins) {
                    throw "Id or UniqueIdentifier is required"
                }

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

                $InstallEndpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current/plugin/install/marketplace")
            }
        }

        # Common installation process
        $InstallBody = @{
            "plugin_unique_identifiers" = @($Identifiers)
        } | ConvertTo-Json

        try {
            $Response = Invoke-DifyRestMethod -Uri $InstallEndpoint -Method $InstallMethod -Body $InstallBody -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
        }
        catch {
            throw "Failed to install plugin: $_"
        }

        $TaskInfo = [PSCustomObject]@{
            AllInstalled = $Response.all_installed
            TaskId       = $Response.task_id
        }

        If ($TaskInfo.AllInstalled) {
            $InstalledPlugins = Get-DifyPlugin -UniqueIdentifier $Identifiers
            return $InstalledPlugins
        }

        if ($Wait) {
            $Status = $TaskInfo | Get-DifyPluginInstallationStatus -Wait -Interval $Interval -Timeout $Timeout

            if ($Status.Status -eq "failed") {
                throw "Failed to install plugin: $($Status.Plugins | Where-Object { $_.Status -eq "failed" } | ForEach-Object { $_.DisplayName })"
            }
            $InstalledPlugins = Get-DifyPlugin -UniqueIdentifier $Identifiers
            return $InstalledPlugins
        }
        else {
            return $TaskInfo
        }
    }
}
