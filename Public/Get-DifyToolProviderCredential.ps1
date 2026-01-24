function Get-DifyToolProviderCredential {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [String] $Provider,
        [String] $Name = $null
    )

    $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current/tool-provider/builtin", $Provider, "credential/info")
    $Method = "GET"
    try {
        $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
    }
    catch {
        throw "Failed to get tool credentials: $_"
    }

    $Credentials = @()
    foreach ($Credential in $Response.credentials) {
        $Credentials += [PSCustomObject]@{
            "Id"             = $Credential.id
            "Name"           = $Credential.name
            "Provider"       = $Credential.provider
            "CredentialType" = $Credential.credential_type
            "IsDefault"      = $Credential.is_default
        }
    }

    if ($Name) {
        $Credentials = $Credentials | Where-Object { $_.Name -eq $Name }
    }

    return $Credentials
}
