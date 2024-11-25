function Get-DifyVersion {
    [CmdletBinding()]
    param()

    $Endpoint = "$($env:PSDIFY_URL)/console/api/version"
    $Method = "GET"
    $Query = @{
        "current_version" = ""
    }
    try {
        $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Query $Query -Token $env:PSDIFY_CONSOLE_TOKEN
    }
    catch {
        throw "Failed to obtain version: $_"
    }

    $Version = $Response.version
    return [PSCustomObject]@{
        "Version" = $Version
    }
}
