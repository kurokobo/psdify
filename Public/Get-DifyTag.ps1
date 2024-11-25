function Get-DifyTag {
    [CmdletBinding()]
    param(
        [String[]] $Id = @(),
        [String[]] $Name = @(),
        [String] $Type = ""
    )

    $Query = @{}
    if ($Type) {
        $Query.type = $Type
    }

    $Endpoint = "$($env:PSDIFY_URL)/console/api/tags"
    $Method = "GET"
    $Tags = @()
    try {
        $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Query $Query -Token $env:PSDIFY_CONSOLE_TOKEN
    }
    catch {
        throw "Failed to obtain tags: $_"
    }

    foreach ($Tag in $Response) {
        $TagObject = [PSCustomObject]@{
            Id           = $Tag.id
            Name         = $Tag.name
            Type         = $Tag.type
            BindingCount = [int]($Tag.binding_count)
        }
        $Tags += $TagObject
    }

    if ($Id) {
        $Tags = $Tags | Where-Object { $Id -contains $_.Id }
    }
    if ($Name) {
        $Tags = $Tags | Where-Object { $Name -contains $_.Name }
    }

    return $Tags
}
