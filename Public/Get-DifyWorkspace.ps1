function Get-DifyWorkspace {
    [CmdletBinding()]
    param(
        [String[]] $Id = @(),
        [String[]] $Name = @(),
        [String[]] $Search = @()
    )

    $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces")
    $Method = "GET"
    try {
        $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
    }
    catch {
        throw "Failed to obtain workspaces: $_"
    }

    if (-not $Response.workspaces) {
        return @()
    }

    $Workspaces = @()
    foreach ($Workspace in $Response.workspaces) {
        $WorkspaceObject = [PSCustomObject]@{
            Id        = $Workspace.id
            Name      = $Workspace.name
            Plan      = $Workspace.plan
            Status    = $Workspace.status
            CreatedAt = Convert-UnixTimeToLocalDateTime($Workspace.created_at)
            Current   = $Workspace.current
        }
        $Workspaces += $WorkspaceObject
    }

    if ($Id) {
        $Workspaces = $Workspaces | Where-Object { $Id -eq $_.Id }
    }
    if ($Name) {
        $Workspaces = $Workspaces | Where-Object { $Name -eq $_.Name }
    }
    if ($Search) {
        $Workspaces = $Workspaces | Where-Object { $_.Id -like "*$($Search)*" -or $_.Name -like "*$($Search)*" }
    }

    return $Workspaces
}
