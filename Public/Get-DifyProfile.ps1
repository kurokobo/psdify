function Get-DifyProfile {
    [CmdletBinding()]
    param()

    $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/account/profile")
    $Method = "GET"
    
    try {
        $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
    }
    catch {
        throw "Failed to obtain profile: $_"
    }

    return [PSCustomObject]@{
        Id                = $Response.id
        Name              = $Response.name
        Email             = $Response.email
        InterfaceLanguage = $Response.interface_language
        TimeZone          = $Response.timezone
        LastLoginAt       = Convert-UnixTimeToLocalDateTime($Response.last_login_at)
        LastLoginIp       = $Response.last_login_ip
        CreatedAt         = Convert-UnixTimeToLocalDateTime($Response.created_at)
    }
}
