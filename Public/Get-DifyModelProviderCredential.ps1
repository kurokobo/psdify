function Get-DifyModelProviderCredential {
    [CmdletBinding()]
    param(
        [String] $Provider = $null,
        [String] $From = $null,
        [String] $Name = $null,
        [String] $Type = $null
    )

    if ($From) {
        $ValidFroms = @("predefined", "customizable")
        if ($From -notin $ValidFroms) {
            throw "Invalid value for From. Must be one of: $($ValidFroms -join ', ')"
        }
    }
    if ($Type) {
        $ValidTypes = @("llm", "text-embedding", "speech2text", "moderation", "tts", "rerank")
        if ($Type -notin $ValidTypes) {
            throw "Invalid value for Type. Must be one of: $($ValidTypes -join ', ')"
        }
    }

    $Credentials = @()
    $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current/model-providers")
    $Method = "GET"
    try {
        $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
    }
    catch {
        throw "Failed to get model provider credentials: $_"
    }

    foreach ($Data in $Response.data) {
        $CurrentProvider = $Data.provider
        foreach ($AvailableCredential in $Data.custom_configuration.available_credentials) {
            $Credentials += [PSCustomObject]@{
                "Provider"       = $CurrentProvider
                "ModelType"      = $null
                "ModelName"      = $null
                "From"           = "predefined"
                "CredentialId"   = $AvailableCredential.credential_id
                "CredentialName" = $AvailableCredential.credential_name
            }
        }
        foreach ($CustomModel in $Data.custom_configuration.custom_models) {
            $CurrentModel = $CustomModel.model
            $CurrentModelType = $CustomModel.model_type
            foreach ($AvailableModelCredential in $CustomModel.available_model_credentials) {
                $Credentials += [PSCustomObject]@{
                    "Provider"       = $CurrentProvider
                    "ModelType"      = $CurrentModelType
                    "ModelName"      = $CurrentModel
                    "From"           = "customizable"
                    "CredentialId"   = $AvailableModelCredential.credential_id
                    "CredentialName" = $AvailableModelCredential.credential_name
                }
            }
        }
    }

    if ($Provider) {
        $Credentials = $Credentials | Where-Object { $_.Provider -in $Provider }
    }
    if ($From) {
        $Credentials = $Credentials | Where-Object { $_.From -eq $From }
    }
    if ($Name) {
        $Credentials = $Credentials | Where-Object { $_.ModelName -in $Name }
    }
    if ($Type) {
        $Credentials = $Credentials | Where-Object { $_.ModelType -in $Type }
    }

    return $Credentials
}
