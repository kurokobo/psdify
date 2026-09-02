function Get-DifyCurrentWorkspace {
    [CmdletBinding()]
    param()

    if (Compare-SimpleVersion -Version $env:PSDIFY_VERSION -Ge "1.17.0") {
        # /workspaces/current/summary returns id/name/role/plan; /workspaces list provides status/created_at
        $SummaryEndpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current/summary")
        try {
            $Summary = Invoke-DifyRestMethod -Uri $SummaryEndpoint -Method "GET" -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
        }
        catch {
            throw "Failed to obtain current workspace: $_"
        }
        $ListEndpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces")
        try {
            $ListResponse = Invoke-DifyRestMethod -Uri $ListEndpoint -Method "GET" -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
        }
        catch {
            throw "Failed to obtain current workspace: $_"
        }
        $ListEntry = $ListResponse.workspaces | Where-Object { $_.id -eq $Summary.id } | Select-Object -First 1

        $CurrentWorkspace = [PSCustomObject]@{
            Id        = $Summary.id
            Name      = $Summary.name
            Plan      = $Summary.plan
            Status    = $ListEntry.status
            CreatedAt = Convert-UnixTimeToLocalDateTime($ListEntry.created_at)
            Role      = $Summary.role
        }
    }
    else {
        if (Compare-SimpleVersion -Version $env:PSDIFY_VERSION -Ge "1.10.1") {
            $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current")
            $Method = "POST"
        }
        else {
            $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current")
            $Method = "GET"
        }
        $Body = @{} | ConvertTo-Json
        try {
            $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
        }
        catch {
            throw "Failed to obtain current workspace: $_"
        }

        $CurrentWorkspace = [PSCustomObject]@{
            Id        = $Response.id
            Name      = $Response.name
            Plan      = $Response.plan
            Status    = $Response.status
            CreatedAt = Convert-UnixTimeToLocalDateTime($Response.created_at)
            Role      = $Response.role
        }
    }

    return $CurrentWorkspace
}
