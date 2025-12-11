@{
    RootModule           = 'PSDify.psm1'
    ModuleVersion        = '0.9.0'
    CompatiblePSEditions = @('Core', 'Desktop')
    GUID                 = 'b791c4c0-ed46-4561-8713-5d4242e6bac7'
    Author               = 'kurokobo'
    CompanyName          = ''
    Copyright            = '(c) 2025 kurokobo.'

    Description          = 'PowerShell module for Dify.'
    PowerShellVersion    = '5.1'

    FunctionsToExport    = @(  
        'Wait-Dify',
        'Initialize-Dify',

        'Connect-Dify',
        'Disconnect-Dify',

        'Get-DifyMember',
        'New-DifyMember',
        'Set-DifyMemberRole',
        'Remove-DifyMember',

        'Get-DifyWorkspace',
        'Get-DifyCurrentWorkspace',
        'Set-DifyCurrentWorkspace',

        'Find-DifyPlugin',
        'Get-DifyPlugin',
        'Install-DifyPlugin',
        'Uninstall-DifyPlugin',
        'Get-DifyPluginInstallationStatus',

        'Get-DifyModelProviderCredential',

        'Get-DifyModel',
        'New-DifyModel',
        'Remove-DifyModel',

        'Get-DifySystemModel',
        'Set-DifySystemModel',

        'Get-DifyKnowledge',
        'New-DifyKnowledge',
        'Remove-DifyKnowledge',

        'Get-DifyDocument',
        'Add-DifyDocument',
        'Remove-DifyDocument',
        'Get-DifyDocumentIndexingStatus',

        'Get-DifyApp',
        'Remove-DifyApp',
        'Import-DifyApp',
        'Export-DifyApp',
        'Get-DifyDSLContent',
        'Set-DifyDSLContent',
        'Get-DifyAppAPIKey',
        'New-DifyAppAPIKey',
        'Remove-DifyAppAPIKey',

        'Get-DifyAppTrace',
        'Get-DifyAppTraceConfig',
        'Set-DifyAppTrace',
        'New-DifyAppTraceConfig',
        'Set-DifyAppTraceConfig',
        'Remove-DifyAppTraceConfig',

        'Send-DifyChatMessage',

        'Get-DifyTag',
        'Get-DifyAppTag',
        'Get-DifyKnowledgeTag',

        'Get-DifyVersion',
        'Get-DifyProfile',

        'New-TemporaryFileForBinaryUpload',
        'Join-Url',
        'Add-DifyFile',
        'Invoke-DifyRestMethod',

        'Get-PSDifyConsoleAuth',
        'Set-PSDifyConfiguration'
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
