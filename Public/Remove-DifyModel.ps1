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
        if ($CustomizableModels.Count -gt 0) {
            foreach ($CustomizableModel in $CustomizableModels) {
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
        return
    }
}
