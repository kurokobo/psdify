function Initialize-Dify {
    [CmdletBinding()]
    param (
        [String] $Server = "https://cloud.dify.ai",
        [String] $Email = "",
        [String] $Name = "",
        [SecureString] $InitPassword = $null,
        [SecureString] $Password = $null
    )

    # Validate parameter: Server
    if ($env:PSDIFY_URL) {
        $Server = $env:PSDIFY_URL
    }
    if (-not $Server) {
        throw "Server URL is required"
    }

    # Validate parameter: Email
    if ($env:PSDIFY_EMAIL) {
        $Email = $env:PSDIFY_EMAIL
    }
    if (-not $Email) {
        throw "Email is required"
    }

    # Validate parameter: Name
    if (-not $Name) {
        $Name = ($Email -split "@")[0]
    }

    # Gather installation status
    $SetUpEndpoint = "$($Server)/console/api/setup"
    $InitEndpoint = "$($Server)/console/api/init"
    $Method = "GET"
    $Session = New-Object Microsoft.PowerShell.Commands.WebRequestSession

    # Stage 1: Validate init password
    try {
        $SetUpStatus = (Invoke-DifyRestMethod -Uri $SetUpEndpoint -Method $Method -Session $Session).step
        $InitStatus = (Invoke-DifyRestMethod -Uri $InitEndpoint -Method $Method -Session $Session).status
        Write-Verbose "setup: $SetUpStatus, init: $InitStatus"
    }
    catch {
        throw "Failed to obtain installation status: $_"
    }  
    if ($SetUpStatus -eq "not_started" -and $InitStatus -eq "not_started") {
        Write-Verbose "stage to validate init password"
        if ($env:PSDIFY_INIT_PASSWORD) {
            $InitPassword = ConvertTo-SecureString -String $env:PSDIFY_INIT_PASSWORD -AsPlainText -Force
        }
        if (-not $InitPassword) {
            $InitPassword = Read-Host -Prompt "Enter init password for $Server" -AsSecureString
        }
        $PlainInitPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($InitPassword))

        $Endpoint = "$($Server)/console/api/init"
        $Method = "POST"
        $Body = @{
            "password" = $PlainInitPassword
        } | ConvertTo-Json

        try {
            $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -ContentType "application/json" -Body $Body -Session $Session
        }
        catch {
            throw "Failed to validate init password: $_"
        }
        if (-not $Response.result -or $Response.result -ne "success") {
            throw "Failed to validate init password"
        }
    }

    # Stage 2: Create admin account
    $Method = "GET"
    try {
        $SetUpStatus = (Invoke-DifyRestMethod -Uri $SetUpEndpoint -Method $Method -Session $Session).step
        $InitStatus = (Invoke-DifyRestMethod -Uri $InitEndpoint -Method $Method -Session $Session).status
        Write-Verbose "setup: $SetUpStatus, init: $InitStatus"
    }
    catch {
        throw "Failed to obtain installation status: $_"
    }
    if ($SetUpStatus -eq "not_started" -and $InitStatus -eq "finished") {
        Write-Verbose "stage to create admin account"
        if ($env:PSDIFY_PASSWORD) {
            $Password = ConvertTo-SecureString -String $env:PSDIFY_PASSWORD -AsPlainText -Force
        }
        if (-not $Password) {
            $Password = Read-Host -Prompt "Enter password for $Email" -AsSecureString
        }
        $PlainPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))

        $Endpoint = "$($Server)/console/api/setup"
        $Method = "POST"
        $Body = @{
            "email"    = $Email
            "name"     = $Name
            "password" = $PlainPassword
        } | ConvertTo-Json

        try {
            $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -ContentType "application/json" -Body $Body -Session $Session
        }
        catch {
            throw "Failed to create admin account: $_"
        }
        if (-not $Response.result -or $Response.result -ne "success") {
            throw "Failed to create admin account"
        }
    }

    # Stage 3: Login to Dify
    Write-Verbose "stage to login to newly initialized dify"
    return Connect-Dify -Server $Server -AuthMethod "Password" -Email $Email -Password $Password
}
