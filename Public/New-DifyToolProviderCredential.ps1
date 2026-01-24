function New-DifyToolProviderCredential {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [String] $Provider,
        [Parameter(Mandatory = $true)]
        [Hashtable] $Credential,
        [String] $AuthorizationName
    )

    if (-not $AuthorizationName) {
        $AvailableCredentials = Get-DifyToolProviderCredential -Provider $Provider
        $AuthorizationName = "API KEY $($($AvailableCredentials | Measure-Object).Count + 1)"
    }

    $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current/tool-provider/builtin", $Provider, "add")
    $Method = "POST"
    $Body = @{
        "credentials" = $Credential
        "type"        = "api-key"
        "name"        = $AuthorizationName
    } | ConvertTo-Json -Depth 10

    try {
        $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
    }
    catch {
        throw "Failed to create tool credential: $_"
    }
    if (-not $Response.result -or $Response.result -ne "success") {
        throw "Failed to create tool credential"
    }

    return Get-DifyToolProviderCredential -Provider $Provider -Name $AuthorizationName
}
