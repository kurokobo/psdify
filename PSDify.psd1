@{
    RootModule           = 'PSDify.psm1'
    ModuleVersion        = '0.0.1'
    CompatiblePSEditions = @('Core', 'Desktop')
    GUID                 = 'b791c4c0-ed46-4561-8713-5d4242e6bac7'
    Author               = 'kurokobo'
    CompanyName          = ''
    Copyright            = '(c) 2024 kurokobo.'

    Description          = 'PowerShell module for Dify.'
    PowerShellVersion    = '5.1'

    FunctionsToExport    = @(        
        'Connect-Dify',
        'Export-DifyApp',
        'Get-DifyApp',
        'Get-DifyAppTag',
        'Get-DifyMember',
        'Get-DifyModel',
        'Get-DifyProfile',
        'Get-DifySystemModel',
        'Get-DifyTag',
        'Get-DifyVersion',
        'Import-DifyApp',
        'Initialize-Dify',
        'Invoke-DifyRestMethod',
        'New-DifyMember',
        'New-DifyModel',
        'Remove-DifyApp',
        'Remove-DifyMember',
        'Set-DifyMemberRole',
        'Set-DifySystemModel'
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
