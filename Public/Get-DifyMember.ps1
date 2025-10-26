function Get-DifyMember {
    [CmdletBinding()]
    param(
        [String[]] $Id = @(),
        [String[]] $Name = @(),
        [String[]] $Email = @()
    )

    $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current/members")
    $Method = "GET"
    
    try {
        $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
    }
    catch {
        throw "Failed to obtain members: $_"
    }

    $Accounts = @()
    foreach ($Member in $Response.accounts) {
        $Account = [PSCustomObject]@{
            Id           = $Member.id
            Name         = $Member.name
            Email        = $Member.email
            LastLoginAt  = Convert-UnixTimeToLocalDateTime($Member.last_login_at)
            LastActiveAt = Convert-UnixTimeToLocalDateTime($Member.last_active_at)
            CreatedAt    = Convert-UnixTimeToLocalDateTime($Member.created_at)
            Role         = $Member.role
            Status       = $Member.status
        }
        $Accounts += $Account
    }
    
    if ($Id) {
        $Accounts = $Accounts | Where-Object { $Id -contains $_.Id }
    }
    if ($Name) {
        $Accounts = $Accounts | Where-Object { $Name -contains $_.Name }
    }
    if ($Email) {
        $Accounts = $Accounts | Where-Object { $Email -contains $_.Email }
    }
    
    return $Accounts
}
