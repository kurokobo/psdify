@{
    RootModule           = 'PSDify.psm1'
    ModuleVersion        = '0.1.0'
    CompatiblePSEditions = @('Core', 'Desktop')
    GUID                 = 'b791c4c0-ed46-4561-8713-5d4242e6bac7'
    Author               = 'kurokobo'
    CompanyName          = ''
    Copyright            = '(c) 2024 kurokobo.'

    Description          = 'PowerShell module for Dify.'
    PowerShellVersion    = '5.1'

    FunctionsToExport    = @(  
        'Add-DifyDocument',
        'Add-DifyFile',
        'Connect-Dify',
        'Disconnect-Dify',
        'Export-DifyApp',
        'Get-DifyApp',
        'Get-DifyAppAPIKey',
        'Get-DifyAppTag',
        'Get-DifyDocument',
        'Get-DifyDocumentIndexingStatus',
        'Get-DifyDSLContent',
        'Get-DifyKnowledge',
        'Get-DifyKnowledgeTag',
        'Get-DifyMember',
        'Get-DifyModel',
        'Get-DifyProfile',
        'Get-DifySystemModel',
        'Get-DifyTag',
        'Get-DifyVersion',
        'Import-DifyApp',
        'Initialize-Dify',
        'Invoke-DifyRestMethod',
        'New-DifyAppAPIKey',
        'New-DifyKnowledge',
        'New-DifyMember',
        'New-DifyModel',
        'Remove-DifyApp',
        'Remove-DifyAppAPIKey',
        'Remove-DifyDocument',
        'Remove-DifyKnowledge',
        'Remove-DifyMember',
        'Remove-DifyModel',
        'Send-DifyChatMessage',
        'Set-DifyDSLContent',
        'Set-DifyMemberRole',
        'Set-DifySystemModel',
        'Set-PSDifyConfiguration',
        'Wait-Dify'
    )
    CmdletsToExport      = @()
    AliasesToExport      = @()

    PrivateData          = @{
        PSData = @{
            Tags         = @('Dify')
            LicenseUri   = 'https://github.com/kurokobo/psdify/blob/main/LICENSE'
            ProjectUri   = 'https://github.com/kurokobo/psdify'
            ReleaseNotes = 'https://github.com/kurokobo/psdify/releases'
        }
    }
}
