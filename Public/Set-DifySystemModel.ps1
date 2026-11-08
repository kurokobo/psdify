function Set-DifySystemModel {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject[]] $Model = @(),
        [String] $Type = "",
        [String] $Provider = "",
        [String] $Name = "",
        [Switch] $Remove
    )

    begin {
        $ValidTypes = @("llm", "text-embedding", "rerank", "speech2text", "tts")
        $Models = @()
    }

    process {
        foreach ($ModelObject in $Model) {
            if ($ModelObject.Type -notin $ValidTypes) {
                throw "Invalid value for Type. Must be one of: $($ValidTypes -join ', ')"
            }
            if ($Remove) {
                $Models += @{
                    "model_type" = $ModelObject.Type
                    "provider"   = $null
                    "model"      = $null
                }
            }
            else {
                $Models += @{
                    "model_type" = $ModelObject.Type
                    "provider"   = $ModelObject.Provider
                    "model"      = $ModelObject.Model
                }
            }
        }
    }

    end {
        # Dify 1.18.0+ replaces all system models at once, which is the only way to remove them
        $SupportsReplace = Compare-SimpleVersion -Version $env:PSDIFY_VERSION -Ge "1.18.0"
        if ($Remove -and -not $SupportsReplace) {
            throw "Removing system models requires Dify 1.18.0 or later"
        }

        if (-not $Models -and $Type -notin $ValidTypes) {
            throw "Invalid value for Type. Must be one of: $($ValidTypes -join ', ')"
        }
        if (-not $Models -and $Remove) {
            if ($Provider -or $Name) {
                throw "Provider and Name cannot be specified with Remove"
            }
            $Models = @(
                @{
                    "model_type" = $Type
                    "provider"   = $null
                    "model"      = $null
                }
            )
        }
        if (-not $Models -and -not $Provider) {
            throw "Provider is required"
        }
        if (-not $Models -and -not $Name) {
            throw "Name is required"
        }
        if (-not $Models) {
            if ($env:PSDIFY_PLUGIN_SUPPORT -and $Provider -notmatch "/") {
                $Provider = "langgenius/$($Provider)/$($Provider)"
            }
            $Models = @(
                @{
                    "model_type" = $Type
                    "provider"   = $Provider
                    "model"      = $Name
                }
            )
        }

        $RequestedTypes = @($Models | ForEach-Object { $_["model_type"] } | Sort-Object -Unique)
        if ($SupportsReplace) {
            # Types omitted from the request are removed, so explicitly include the current settings for the other types.
            # The server rejects the whole request if any setting refers to an unavailable provider or model,
            # so such stale settings are removed instead of being kept.
            $CurrentModels = @(Get-DifySystemModel | Where-Object { $_.Type -notin $RequestedTypes })
            $ConfiguredModels = @($CurrentModels | Where-Object { $_.Provider -and $_.Model })
            $ActiveModels = @()
            if ($ConfiguredModels) {
                $ActiveModels = @(Get-DifyModel -Type @($ConfiguredModels.Type | Sort-Object -Unique) -Active)
            }
            foreach ($CurrentModel in $CurrentModels) {
                $KeptProvider = $null
                $KeptModel = $null
                if ($CurrentModel.Provider -and $CurrentModel.Model) {
                    $IsActive = $ActiveModels | Where-Object {
                        $_.Type -eq $CurrentModel.Type -and $_.Provider -eq $CurrentModel.Provider -and $_.Model -eq $CurrentModel.Model
                    }
                    if ($IsActive) {
                        $KeptProvider = $CurrentModel.Provider
                        $KeptModel = $CurrentModel.Model
                    }
                    else {
                        Write-Warning "Current system model for type $($CurrentModel.Type) ($($CurrentModel.Provider) / $($CurrentModel.Model)) is no longer available and will be removed"
                    }
                }
                $Models += @{
                    "model_type" = $CurrentModel.Type
                    "provider"   = $KeptProvider
                    "model"      = $KeptModel
                }
            }
        }

        $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current/default-model")
        $Method = "POST"
        $Body = @{
            "model_settings" = @($Models)
        } | ConvertTo-Json -Depth 10
        Write-Verbose $Body
        try {
            $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
        }
        catch {
            throw "Failed to set system model: $_"
        }
        if (-not $Response.result -or $Response.result -ne "success") {
            throw "Failed to set system model"
        }

        return Get-DifySystemModel -Type $RequestedTypes
    }
}
