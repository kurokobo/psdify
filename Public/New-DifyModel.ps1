function New-DifyModel {
    [CmdletBinding()]
    param(
        [String] $Provider,
        [String] $From = "predefined",
        [String] $Name,
        [String] $Type,
        [Hashtable] $Credential,
        [String] $AuthorizationName
    )

    $ValidFroms = @("predefined", "customizable")
    if ($From -notin $ValidFroms) {
        throw "Invalid value for Type. Must be one of: $($ValidFroms -join ', ')"
    }
    if (-not $Provider) {
        throw "Provider is required"
    }

    if ($env:PSDIFY_PLUGIN_SUPPORT -and $Provider -notmatch "/") {
        $Provider = "langgenius/$($Provider)/$($Provider)"
    }

    switch ($From) {
        "predefined" {
            if (-not $Credential) {
                throw "Credential is required when From is 'predefined'"
            }
            if (Compare-SimpleVersion -Version $env:PSDIFY_VERSION -Ge "1.8.0") {
                if (-not $AuthorizationName) {
                    $AvailableCredentials = Get-DifyModelProviderCredential -Provider $Provider
                    $AuthorizationName = "API KEY $($($AvailableCredentials | Measure-Object).Count + 1)"
                }
                $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current/model-providers", $Provider, "/credentials")
                $Method = "POST"
                $Body = @{
                    "name"        = $AuthorizationName
                    "credentials" = $Credential
                } | ConvertTo-Json -Depth 10
            }
            else {
                $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current/model-providers", $Provider)
                $Method = "POST"
                $Body = @{
                    "config_from"    = "predefined-model"
                    "credentials"    = $Credential
                    "load_balancing" = @{
                        "enabled" = $false
                        "configs" = @()
                    }
                } | ConvertTo-Json -Depth 10
            }
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
            if (Compare-SimpleVersion -Version $env:PSDIFY_VERSION -Ge "1.8.0") {
                if (-not $AuthorizationName) {
                    $AvailableCredentials = Get-DifyModelProviderCredential -Provider $Provider -Name $Name -Type $Type
                    $AuthorizationName = "API KEY $($($AvailableCredentials | Measure-Object).Count + 1)"
                }
                $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current/model-providers", $Provider, "/models/credentials")
                $Method = "POST"
                $Body = @{
                    "name"        = $AuthorizationName
                    "model"       = $Name
                    "model_type"  = $Type
                    "credentials" = $Credential
                } | ConvertTo-Json -Depth 10
            }
            else {
                $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current/model-providers", $Provider, "/models")
                $Method = "POST"
                $Body = @{
                    "model"          = $Name
                    "model_type"     = $Type
                    "credentials"    = $Credential
                    "load_balancing" = @{
                        "enabled" = $false
                        "configs" = @()
                    }
                } | ConvertTo-Json -Depth 10
            }
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
