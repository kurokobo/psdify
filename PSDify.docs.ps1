Import-Module -Name .\PSDify.psd1 -Force

# Create new markdown help files
# $parameters = @{
#     Module                = "PSDify"
#     OutputFolder          = "Docs/docs/cmdlets"
#     AlphabeticParamsOrder = $true
#     ExcludeDontShow       = $true
#     Encoding              = [System.Text.Encoding]::UTF8
# }
# New-MarkdownHelp @parameters

# Update markdown help files
$Parameters = @{
    Path                  = "Docs/docs/cmdlets"
    AlphabeticParamsOrder = $true
    UpdateInputOutput     = $true
    ExcludeDontShow       = $true
    Encoding              = [System.Text.Encoding]::UTF8
    Force                 = $true
}
Update-MarkdownHelpModule @Parameters

# Create new external help file
New-ExternalHelp -Path "Docs/docs/cmdlets" -OutputPath . -Force
