function New-DifyMember {
    [CmdletBinding()]
    param(
        [String] $Email,
        [String] $Role = "normal",
        [String] $Language = "en-US"
    )

    $ValidRoles = @("admin", "editor", "normal")
    if ($Role -notin $ValidRoles) {
        throw "Invalid value for Role. Must be one of: $($ValidRoles -join ', ')"
    }

    $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current/members/invite-email")
    $Method = "POST"
    $Body = @{
        "emails"   = @($Email)
        "role"     = $Role
        "language" = $Language
    } | ConvertTo-Json
    try {
        $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
    }
    catch {
        throw "Failed to invite member: $_"
    }

    if (-not $Response.result -or $Response.result -ne "success") {
        throw "Failed to invite member"
    }

    $Member = Get-DifyMember -Email $Email
    if ($null -eq $Member) {
        # If the member is not found after the invitation, return a partial object with
        # the invitation link so the caller can complete the process if needed.
        return [PSCustomObject]@{
            Id             = $null
            Name           = ($Email -split "@")[0]
            Email          = $Email
            LastLoginAt    = $null
            LastActiveAt   = $null
            CreatedAt      = $null
            Role           = $Role
            Status         = $null
            InvitationLink = $Response.invitation_results[0].url
        }
    }
    Add-Member -InputObject $Member -NotePropertyName "InvitationLink" -NotePropertyValue $Response.invitation_results.url

    return $Member
}
