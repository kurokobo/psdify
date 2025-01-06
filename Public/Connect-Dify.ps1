function Connect-Dify {
    [CmdletBinding()]
    param (
        [String] $Server = "https://cloud.dify.ai",
        [String] $AuthMethod = "Password",
        [String] $Email = "",
        [String] $Token = "",
        [String] $Code = "",
        [SecureString] $Password = $null,
        [Switch] $Force
    )

    # Validate existing tokens
    if (-not $Force -and $env:PSDIFY_URL -and $env:PSDIFY_CONSOLE_TOKEN -and (-not $Server -or $Server -eq $env:PSDIFY_URL)) {
        try {
            $DifyProfile = Get-DifyProfile
            $DifyVersion = Get-DifyVersion
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
    if ($env:PSDIFY_URL) {
        $Server = $env:PSDIFY_URL
    }
    if (-not $Server) {
        throw "Server URL is required"
    }

    # Validate parameter: Auth
    if ($env:PSDIFY_AUTH_METHOD) {
        $AuthMethod = $env:PSDIFY_AUTH_METHOD
    }
    if ($AuthMethod -notin @('Password', 'Code', 'Token')) {
        throw "Invalid value for AuthMethod. Must be 'Password', 'Code', or 'Token'."
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
                $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body

            }
            catch {
                throw "Failed to login to Dify on $($Server): $_"
            }

            if (-not $Response.result -or $Response.result -ne "success" -or -not $Response.data) {
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
                    $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body
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
                $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body
            }
            catch {
                throw "Failed to login to Dify on $($Server): $_"
            }

            if (-not $Response.result -or $Response.result -ne "success" -or -not $Response.data) {
                throw "Unexpected response while attempting login by email and code: $($Response | ConvertTo-Json -Depth 100 -Compress)"
            }
        }
    }
    $env:PSDIFY_URL = $Server
    $env:PSDIFY_CONSOLE_TOKEN = $Response.data.access_token
    $env:PSDIFY_CONSOLE_REFRESH_TOKEN = $Response.data.refresh_token

    $DifyProfile = Get-DifyProfile
    $DifyVersion = Get-DifyVersion

    $env:PSDIFY_VERSION = $DifyVersion.Version
    if ($DifyVersion.PluginSupport) {
        $env:PSDIFY_PLUGIN_SUPPORT = "true"
    }
    else {
        $env:PSDIFY_PLUGIN_SUPPORT = $null
    }
    $env:PSDIFY_MARKETPLACE_API_PREFIX = $null

    return [PSCustomObject]@{
        "Server"  = $env:PSDIFY_URL
        "Version" = $env:PSDIFY_VERSION
        "Name"    = $DifyProfile.Name
        "Email"   = $DifyProfile.Email
    }
}
