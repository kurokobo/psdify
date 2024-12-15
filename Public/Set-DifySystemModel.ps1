function Set-DifySystemModel {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject[]] $Model = @(),
        [String] $Type = "",
        [String] $Provider = "",
        [String] $Name = ""
    )

    begin {
        $ValidTypes = @("llm", "text-embedding", "rerank", "speech2text", "tts")
        $Models = @()
    }

    process {
        foreach ($ModelObject in $Model) {
            if ($ModelObjectl) {
                if ($ModelObject.Type -notin $ValidTypes) {
                    throw "Invalid value for Type. Must be one of: $($ValidTypes -join ', ')"
                }
                $Models += @{
                    "model_type" = $ModelObject.Type
                    "provider"   = $ModelObject.Provider
                    "model"      = $ModelObject.Model
                }
            }
        }
    }

    end {
        if (-not $Models -and $Type -notin $ValidTypes) {
            throw "Invalid value for Type. Must be one of: $($ValidTypes -join ', ')"
        }
        if (-not $Models -and -not $Provider) {
            throw "Provider is required"
        }
        if (-not $Models -and -not $Name) {
            throw "Name is required"
        }
        if (-not $Models) {
            $Models = @(
                @{
                    "model_type" = $Type
                    "provider"   = $Provider
                    "model"      = $Name
                }
            )
        }

        $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current/default-model")
        $Method = "POST"
        $Body = @{
            "model_settings" = @($Models)
        } | ConvertTo-Json -Depth 10
        Write-Verbose $Body
        try {
            $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body -Token $env:PSDIFY_CONSOLE_TOKEN
        }
        catch {
            throw "Failed to set system model: $_"
        }
        if (-not $Response.result -or $Response.result -ne "success") {
            throw "Failed to set system model"
        }

        return Get-DifySystemModel -Type @($Models.model_type | Sort-Object -Unique)
    }
}
