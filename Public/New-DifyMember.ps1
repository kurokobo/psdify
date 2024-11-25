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

    $Endpoint = "$($env:PSDIFY_URL)/console/api/workspaces/current/members/invite-email"
    $Method = "POST"
    $Body = @{
        "emails"   = @($Email)
        "role"     = $Role
        "language" = $Language
    } | ConvertTo-Json
    try {
        $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body -Token $env:PSDIFY_CONSOLE_TOKEN
    }
    catch {
        throw "Failed to invite member: $_"
    }

    if (-not $Response.result -or $Response.result -ne "success") {
        throw "Failed to invite member"
    }

    $Member = Get-DifyMember -Email $Email
    Add-Member -InputObject $Member -NotePropertyName "InvitationLink" -NotePropertyValue $Response.invitation_results.url

    return $Member
}
