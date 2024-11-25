function Get-DifyAppTag {
    [CmdletBinding()]
    param(
        [String[]] $Id = @(),
        [String[]] $Name = @()
    )

    return Get-DifyTag -Id $Id -Name $Name -Type "app"
}
