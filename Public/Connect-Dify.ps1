function Connect-Dify {
    [CmdletBinding()]
    param (
        [String] $Server = "",
        [String] $AuthMethod = "",
        [String] $Email = "",
        [String] $Token = "",
        [String] $Code = "",
        [SecureString] $Password = $null,
        [SecureString] $AccessToken = $null,
        [SecureString] $CSRFToken = $null,
        [Switch] $Force
    )

    # Validate existing tokens
    if (-not $Force -and $env:PSDIFY_URL -and $script:PSDIFY_CONSOLE_AUTH -and (-not $Server -or $Server -eq $env:PSDIFY_URL)) {
        try {
            $DifyProfile = Get-DifyProfile
            return [PSCustomObject]@{
                "Server"  = $env:PSDIFY_URL
                "Version" = $env:PSDIFY_VERSION
                "Name"    = $DifyProfile.Name
                "Email"   = $DifyProfile.Email
            }
        }
        catch { }
    }

    # Validate parameter: Server
    if (-not $Server -and $env:PSDIFY_URL) {
        $Server = $env:PSDIFY_URL
    }
    if (-not $Server) {
        $Server = "https://cloud.dify.ai"
    }

    # Validate parameter: AuthMethod
    if (-not $AuthMethod -and $env:PSDIFY_AUTH_METHOD) {
        $AuthMethod = $env:PSDIFY_AUTH_METHOD
    }
    if (-not $AuthMethod) {
        $AuthMethod = "Password"
    }
    if ($AuthMethod -notin @("Password", "Code", "AccessToken")) {
        throw "Invalid value for AuthMethod. Must be 'Password', 'Code', or 'AccessToken'."
    }

    # Reset session
    $DifyVersion = Get-DifyVersion -Server $Server
    $UseSessionAuth = Compare-SimpleVersion -Version $DifyVersion.Version -Ge "1.9.2"
    if (-not $UseSessionAuth -and $AuthMethod -eq "AccessToken") {
        throw "AccessToken authentication requires Dify 1.9.2 or later"
    }
    if ($UseSessionAuth) {
        $script:PSDIFY_CONSOLE_AUTH = New-Object Microsoft.PowerShell.Commands.WebRequestSession
    }
    else {
        $script:PSDIFY_CONSOLE_AUTH = $null
    }

    # Switch based on AuthMethod
    switch ($AuthMethod) {
        'Password' {
            # Validate parameter: Email
            if ($env:PSDIFY_EMAIL) {
                $Email = $env:PSDIFY_EMAIL
            }
            if (-not $Email) {
                throw "Email is required for password authentication"
            }

            # Validate parameter: Password
            if ($env:PSDIFY_PASSWORD) {
                $Password = ConvertTo-SecureString -String $env:PSDIFY_PASSWORD -AsPlainText -Force
            }
            if ($AuthMethod -eq 'Password' -and -not $Password) {
                $Password = Read-Host -Prompt "Enter password for $Email" -AsSecureString
            }
            $PlainPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
            if (Compare-SimpleVersion -Version $DifyVersion.Version -Ge "1.11.2") {
                $Bytes = [System.Text.Encoding]::UTF8.GetBytes($PlainPassword)
                $PlainPassword = [System.Convert]::ToBase64String($Bytes)
            }

            # Login to Dify
            $Endpoint = Join-Url -Segments @($Server, "/console/api/login")
            $Method = "POST"
            $Body = @{
                "email"       = $Email
                "password"    = $PlainPassword
                "language"    = "en-US"
                "remember_me" = $false
            } | ConvertTo-Json
    
            try {
                if ($UseSessionAuth) {
                    $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body -Session $script:PSDIFY_CONSOLE_AUTH
                }
                else {
                    $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body
                }
            }
            catch {
                throw "Failed to login to Dify on $($Server): $_"
            }

            if (-not $Response.result -or $Response.result -ne "success" -or (-not $UseSessionAuth -and -not $Response.data)) {
                throw "Unexpected response while attempting login by email and password: $($Response | ConvertTo-Json -Depth 100 -Compress)"
            }

        }

        'Code' {
            # Validate parameter: Email
            if ($env:PSDIFY_EMAIL) {
                $Email = $env:PSDIFY_EMAIL
            }
            if (-not $Email) {
                throw "Email is required for password authentication"
            }
            
            if (-not $Token) {
                # Request the code to Dify
                $Endpoint = Join-Url -Segments @($Server, "/console/api/email-code-login")
                $Method = "POST"
                $Body = @{
                    "email"    = $Email
                    "language" = "en-US"
                } | ConvertTo-Json
                try {
                    if ($UseSessionAuth) {
                        $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body -Session $script:PSDIFY_CONSOLE_AUTH
                    }
                    else {
                        $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body
                    }
                }
                catch {
                    throw "Failed to request the code to Dify on $($Server): $_"
                }

                if (-not $Response.result -or $Response.result -ne "success") {
                    throw "Failed to create admin account"
                }

                # Ask user to enter the code
                $Token = $Response.data
            }

            if (-not $Code) {
                $Code = Read-Host "Enter the code sent to $($Email)"
            }

            # Login to Dify
            $Endpoint = Join-Url -Segments @($Server, "/console/api/email-code-login/validity")
            $Method = "POST"
            $Body = @{
                "email" = $Email
                "code"  = $Code
                "token" = $Token
            } | ConvertTo-Json
            try {
                if ($UseSessionAuth) {
                    $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body -Session $script:PSDIFY_CONSOLE_AUTH
                }
                else {
                    $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body
                }
            }
            catch {
                throw "Failed to login to Dify on $($Server): $_"
            }

            if (-not $Response.result -or $Response.result -ne "success" -or (-not $UseSessionAuth -and -not $Response.data)) {
                throw "Unexpected response while attempting login by email and code: $($Response | ConvertTo-Json -Depth 100 -Compress)"
            }
        }

        'AccessToken' {
            # Validate parameter: AccessToken
            if ($env:PSDIFY_ACCESS_TOKEN) {
                $AccessToken = ConvertTo-SecureString -String $env:PSDIFY_ACCESS_TOKEN -AsPlainText -Force
            }
            if (-not $AccessToken) {
                throw "AccessToken is required for access token authentication"
            }
            $PlainAccessToken = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($AccessToken))

            # Validate parameter: CSRFToken
            if ($env:PSDIFY_CSRF_TOKEN) {
                $CSRFToken = ConvertTo-SecureString -String $env:PSDIFY_CSRF_TOKEN -AsPlainText -Force
            }
            if (-not $CSRFToken) {
                throw "CSRFToken is required for access token authentication"
            }
            $PlainCSRFToken = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($CSRFToken))

            # Build session with access_token and csrf_token cookies
            $ServerHostname = ([System.Uri]$Server).Host
            $script:PSDIFY_CONSOLE_AUTH.Cookies.Add((New-Object System.Net.Cookie("access_token", $PlainAccessToken, "/", $ServerHostname)))
            $script:PSDIFY_CONSOLE_AUTH.Cookies.Add((New-Object System.Net.Cookie("csrf_token", $PlainCSRFToken, "/", $ServerHostname)))
        }
    }
    $env:PSDIFY_URL = $Server
    if (-not $UseSessionAuth) {
        $script:PSDIFY_CONSOLE_AUTH = $Response.data.access_token
    }
    $DifyProfile = Get-DifyProfile
    $env:PSDIFY_VERSION = $DifyVersion.Version
    if ($DifyVersion.PluginSupport) {
        $env:PSDIFY_PLUGIN_SUPPORT = "true"
    }
    else {
        $env:PSDIFY_PLUGIN_SUPPORT = $null
    }

    return [PSCustomObject]@{
        "Server"  = $env:PSDIFY_URL
        "Version" = $env:PSDIFY_VERSION
        "Name"    = $DifyProfile.Name
        "Email"   = $DifyProfile.Email
    }
}
