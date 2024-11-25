function Get-DifySystemModel {
    [CmdletBinding()]
    param(
        [String[]] $Type = @()
    )
    $ValidTypes = @("llm", "text-embedding", "rerank", "speech2text", "tts")
    if ($Type) {
        foreach ($TypeObj in $Type) {
            if ($TypeObj -notin $ValidTypes) {
                throw "Invalid value for Type. Must be one of: $($ValidTypes -join ', ')"
            }
        }
    }
    else {
        $Type = $ValidTypes
    }

    $Models = @()
    foreach ($TypeObj in $Type) {
        $Endpoint = "$($env:PSDIFY_URL)/console/api/workspaces/current/default-model"
        $Method = "GET"
        $Query = @{
            "model_type" = $TypeObj
        }
        try {
            $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Query $Query -Token $env:PSDIFY_CONSOLE_TOKEN
        }
        catch {
            throw "Failed to get system model for type $($TypeObj): $_"
        }

        $Models += [PSCustomObject]@{
            "Type"     = $TypeObj
            "Provider" = $Response.data.provider.provider
            "Model"    = $Response.data.model
        }
    }
    return $Models
}
