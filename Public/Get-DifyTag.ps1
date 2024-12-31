function Get-DifyTag {
    [CmdletBinding()]
    param(
        [String[]] $Id = @(),
        [String[]] $Name = @(),
        [String] $Type = ""
    )

    $ValidTypes = @("knowledge", "app")
    if (-not $Type) {
        throw "Type is required. Must be one of: $($ValidTypes -join ', ')"
    }

    $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/tags")
    $Method = "GET"
    $Query = @{
        "type" = $Type
    }
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
