function Get-DifyModel {
    [CmdletBinding()]
    param(
        [String[]] $Provider = @(),
        [String[]] $From = @(),
        [String[]] $Name = @(),
        [String[]] $Type = @()
    )

    $ValidFroms = @("predefined", "customizable")
    if ($From) {
        foreach ($FromObj in $From) {
            if ($FromObj -notin $ValidFroms) {
                throw "Invalid value for From. Must be one of: $($ValidFroms -join ', ')"
            }
        }
    }
    $ValidTypes = @("llm", "text-embedding", "speech2text", "moderation", "tts")
    if ($Type) {
        foreach ($TypeObj in $Type) {
            if ($TypeObj -notin $ValidTypes) {
                throw "Invalid value for Type. Must be one of: $($ValidTypes -join ', ')"
            }
        }
    }

    $Models = @()
    if ($Provider) {
        $Endpoint = "$($env:PSDIFY_URL)/console/api/workspaces/current/model-providers/$($Provider)/models"
        $Method = "GET"
        try {
            $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Token $env:PSDIFY_CONSOLE_TOKEN
        }
        catch {
            throw "Failed to get models from provider: $_"
        }

        foreach ($Model in $Response.data) {
            $Models += [PSCustomObject]@{
                "Provider"   = $Model.provider.provider
                "Model"      = $Model.model
                "Type"       = $Model.model_type
                "FetchFrom"  = $Model.fetch_from
                "Deprecated" = $Model.deprecated
                "Status"     = $Model.status
            }
        }
    }
    else {
        if (-not $Type) {
            $Type = $ValidTypes
        }
        foreach ($TypeObj in $Type) {
            $Endpoint = "$($env:PSDIFY_URL)/console/api/workspaces/current/models/model-types/$TypeObj"
            $Method = "GET"
            try {
                $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Token $env:PSDIFY_CONSOLE_TOKEN
            }
            catch {
                throw "Failed to get models for type $($TypeObj): $_"
            }

            foreach ($ProviderObj in $Response.data) {
                foreach ($Model in $ProviderObj.models) {
                    $Models += [PSCustomObject]@{
                        "Provider"   = $ProviderObj.provider
                        "Model"      = $Model.model
                        "Type"       = $Model.model_type
                        "FetchFrom"  = $Model.fetch_from
                        "Deprecated" = $Model.deprecated
                        "Status"     = $Model.status
                    }
                }
            }
        }
    }

    if ($Provider) {
        $Models = $Models | Where-Object { $_.Provider -in $Provider }
    }
    if ($From) {
        $From = $From | ForEach-Object { "$($_)-model" }
        $Models = $Models | Where-Object { $_.FetchFrom -in $From }
    }
    if ($Name) {
        $Models = $Models | Where-Object { $_.Model -in $Name }
    }
    if ($Type) {
        $Models = $Models | Where-Object { $_.Type -in $Type }
    }

    return $Models
}
