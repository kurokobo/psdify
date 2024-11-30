function Get-DifyKnowledgeTag {
    [CmdletBinding()]
    param(
        [String[]] $Id = @(),
        [String[]] $Name = @()
    )

    return Get-DifyTag -Id $Id -Name $Name -Type "knowledge"
}
