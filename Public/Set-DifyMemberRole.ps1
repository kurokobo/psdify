function Set-DifyMemberRole {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject[]] $Member = @(),
        [String] $Role = "normal"
    )

    begin {
        $ValidRoles = @("normal", "editor", "admin")
        if ($Role -notin $ValidRoles) {
            throw "Invalid value for Role. Must be one of: $($ValidRoles -join ', ')"
        }
    }

    process {
        foreach ($MemberObject in $Member) {
            $Members += $MemberObject
        }
    }

    end {
        if (-not $Members) {
            throw "Member is required"
        }
        foreach ($Member in $Members) {
            $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current/members", $Member.Id, "/update-role")
            $Method = "PUT"
            $Body = @{
                "role" = $Role
            } | ConvertTo-Json
            try {
                $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body -Token $env:PSDIFY_CONSOLE_TOKEN
            }
            catch {
                throw "Failed to set member role: $_"
            }

            if (-not $Response.result -or $Response.result -ne "success") {
                throw "Failed to set member role"
            }
        }

        $Members = Get-DifyMember -Id ($Members.Id)

        return $Members
    }
}
