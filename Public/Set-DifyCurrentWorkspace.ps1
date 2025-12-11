function Set-DifyCurrentWorkspace {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject[]] $Workspace = @(),
        [String[]] $Id = @(),
        [String[]] $Name = @()
    )

    begin {
        $Workspaces = @()
    }

    process {
        foreach ($WorkspaceObject in $Workspace) {
            $Workspaces += $WorkspaceObject
        }
    }

    end {

        if ($Workspaces.Count -gt 0) {
            if ($Workspaces.Count -gt 1) {
                throw "Multiple workspaces provided. Please provide only one workspace to switch to."
            }
            $TargetWorkspace = $Workspaces
        }
        else {
            if (-not $Id -and -not $Name) {
                throw "Please specify either -Workspace, -Id, or -Name to set the current workspace."
            }
            $TargetWorkspace = Get-DifyWorkspace -Id $Id -Name $Name
            if ($TargetWorkspace.Count -eq 0) {
                throw "No workspace found matching the specified criteria."
            }
            if ($TargetWorkspace.Count -gt 1) {
                throw "Multiple workspaces found matching the specified criteria. Please narrow down your search."
            }
        }

        $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/switch")
        $Method = "POST"
        $Body = @{
            "tenant_id" = $TargetWorkspace[0].Id
        } | ConvertTo-Json
        try {
            $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
        }
        catch {
            throw "Failed to switch workspace: $_"
        }

        if ($Response.result -ne "success" -or -not $Response.new_tenant) {
            throw "Failed to switch workspace: $($Response.msg)"
        }

        $CurrentWorkspace = [PSCustomObject]@{
            Id        = $Response.new_tenant.id
            Name      = $Response.new_tenant.name
            Plan      = $Response.new_tenant.plan
            Status    = $Response.new_tenant.status
            CreatedAt = Convert-UnixTimeToLocalDateTime($Response.new_tenant.created_at)
            Role      = $Response.new_tenant.role
        }

        return $CurrentWorkspace
    }
}
