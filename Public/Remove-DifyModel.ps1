function Remove-DifyModel {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject[]] $Model = @()
    )

    begin {
        $Models = @()
    }

    process {
        foreach ($ModelObject in $Model) {
            $Models += $ModelObject
        }
    }

    end {
        $PredefinedModels = @()
        $CustomizableModels = @()
        foreach ($Model in $Models) {
            switch ($Model.FetchFrom) {
                "predefined-model" {
                    if ($PredefinedModels -notcontains $Model.Provider) {
                        $PredefinedModels += $Model.Provider
                    }
                }
                "customizable-model" {
                    $CustomizableModels += $Model
                }
            }
        }
        if ($PredefinedModels.Count -gt 0) {
            foreach ($PredefinedModel in $PredefinedModels) {
                if (Compare-SimpleVersion -Version $env:PSDIFY_VERSION -Ge "1.8.0") {
                    $AvailableCredentials = Get-DifyModelProviderCredential -Provider $PredefinedModel -From "predefined"
                    foreach ($Credential in $AvailableCredentials) {
                        $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current/model-providers", $PredefinedModel, "/credentials")
                        $Method = "DELETE"
                        $Body = @{
                            "credential_id" = $Credential.CredentialId
                        } | ConvertTo-Json -Depth 10
                        if ($PSCmdlet.ShouldProcess("$($Credential.CredentialName) on $($PredefinedModel)", "Remove Credential")) {
                            try {
                                $null = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body -Token $env:PSDIFY_CONSOLE_TOKEN
                            }
                            catch {
                                throw "Failed to remove predefined model credential: $_"
                            }
                        }
                    }
                }
                else {
                    $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current/model-providers", $PredefinedModel)
                    $Method = "DELETE"
                    if ($PSCmdlet.ShouldProcess("$($PredefinedModel)", "Remove All Predefined Models")) {
                        try {
                            $null = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Token $env:PSDIFY_CONSOLE_TOKEN
                        }
                        catch {
                            throw "Failed to remove predefined model: $_"
                        }
                    }
                }
            }
        }
        if ($CustomizableModels.Count -gt 0) {
            foreach ($CustomizableModel in $CustomizableModels) {
                if (Compare-SimpleVersion -Version $env:PSDIFY_VERSION -Ge "1.8.0") {
                    $AvailableCredentials = Get-DifyModelProviderCredential -Provider $CustomizableModel.Provider -Name $CustomizableModel.Model -Type $CustomizableModel.Type -From "customizable"
                    foreach ($Credential in $AvailableCredentials) {
                        $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current/model-providers", $CustomizableModel.Provider, "/models/credentials")
                        $Method = "DELETE"
                        $Body = @{
                            "credential_id" = $Credential.CredentialId
                            "model"         = $CustomizableModel.Model
                            "model_type"    = $CustomizableModel.Type
                        } | ConvertTo-Json -Depth 10
                        if ($PSCmdlet.ShouldProcess("$($Credential.CredentialName) on $($CustomizableModel.Model) of $($CustomizableModel.Provider)", "Remove Model Credential")) {
                            try {
                                $null = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body -Token $env:PSDIFY_CONSOLE_TOKEN
                            }
                            catch {
                                throw "Failed to remove customizable model credential: $_"
                            }
                        }
                    }
                }
                else {
                    $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current/model-providers", $CustomizableModel.Provider, "/models")
                    $Method = "DELETE"
                    $Body = @{
                        "model"      = $CustomizableModel.Model
                        "model_type" = $CustomizableModel.Type
                    } | ConvertTo-Json
                    if ($PSCmdlet.ShouldProcess("$($CustomizableModel.Model) on $($CustomizableModel.Provider)", "Remove Model")) {
                        try {
                            $null = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body -Token $env:PSDIFY_CONSOLE_TOKEN
                        }
                        catch {
                            throw "Failed to remove customizable model: $_"
                        }
                    }
                }
            }
        }
        return
    }
}
