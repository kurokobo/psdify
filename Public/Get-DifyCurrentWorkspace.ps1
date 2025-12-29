function Get-DifyCurrentWorkspace {
    [CmdletBinding()]
    param()

    $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current")
    if (Compare-SimpleVersion -Version $env:PSDIFY_VERSION -Ge "1.10.1") {
        $Method = "POST"
    }
    else {
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

    return $CurrentWorkspace
}
