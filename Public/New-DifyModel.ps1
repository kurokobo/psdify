function New-DifyModel {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUsePSCredentialType')]
    [CmdletBinding()]
    param(
        [String] $Provider,
        [String] $From = "predefined",
        [String] $Name,
        [String] $Type,
        [Hashtable] $Credential
    )

    $ValidFroms = @("predefined", "customizable")
    if ($From -notin $ValidFroms) {
        throw "Invalid value for Type. Must be one of: $($ValidFroms -join ', ')"
    }
    if (-not $Provider) {
        throw "Provider is required"
    }

    switch ($From) {
        "predefined" {
            if (-not $Credential) {
                throw "Credential is required when From is 'predefined'"
            }
            $Endpoint = "$($env:PSDIFY_URL)/console/api/workspaces/current/model-providers/$($Provider)"
            $Method = "POST"
            $Body = @{
                "config_from"    = "predefined-model"
                "credentials"    = $Credential
                "load_balancing" = @{
                    "enabled" = $false
                    "configs" = @()
                }
            } | ConvertTo-Json
            try {
                $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body -Token $env:PSDIFY_CONSOLE_TOKEN
            }
            catch {
                throw "Failed to create model provider: $_"
            }
            if (-not $Response.result -or $Response.result -ne "success") {
                throw "Failed to create model provider"
            }

            return Get-DifyModel -Provider $Provider -From $From
        }
        "customizable" {
            $ValidTypes = @("llm", "text-embedding", "speech2text", "moderation", "tts")
            if ($Type -notin $ValidTypes) {
                throw "Invalid value for Type. Must be one of: $($ValidTypes -join ', ')"
            }
            if (-not $Name) {
                throw "Name is required when Type is 'Model'"
            }
            if (-not $Type) {
                throw "Type is required when Type is 'Model'"
            }
            if (-not $Credential) {
                throw "Credential is required when Type is 'Model'"
            }
            $Endpoint = "$($env:PSDIFY_URL)/console/api/workspaces/current/model-providers/$($Provider)/models"
            $Method = "POST"
            $Body = @{
                "model"          = $Name
                "model_type"     = $Type
                "credentials"    = $Credential
                "load_balancing" = @{
                    "enabled" = $false
                    "configs" = @()
                }
            } | ConvertTo-Json
            try {
                $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body -Token $env:PSDIFY_CONSOLE_TOKEN
            }
            catch {
                throw "Failed to create model: $_"
            }
            if (-not $Response.result -or $Response.result -ne "success") {
                throw "Failed to create model"
            }

            return Get-DifyModel -Provider $Provider -From $From -Name $Name -Type $Type
        }
    }
}
