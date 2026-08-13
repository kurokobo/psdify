#Requires -Modules @{ ModuleName="Pester"; ModuleVersion="5.6" }

BeforeDiscovery {
    $PesterPhase = "BeforeDiscovery"
    . (Join-Path -Path (Split-Path -Path $PSScriptRoot) -ChildPath "Initialize-PSDifyPester.ps1")
}

BeforeAll {
    . (Join-Path -Path (Split-Path -Path $PSScriptRoot) -ChildPath "Initialize-PSDifyPester.ps1")

    Start-DifyInstance -Path $env:PSDIFY_TEST_ROOT_DIFY -Version $env:PSDIFY_TEST_VERSION
    Show-DifyConnectionStatus (Connect-DifyTest)
}

Describe "Connection" -Tag "appsite" {
    It "should connect correct server" {
        $env:PSDIFY_URL | Should -Be $DefaultServer
    }
}

Describe "Get-DifyApp, Set-DifyAppSite, Set-DifyAppAPI, Set-DifyApp" -Tag "appsite" {
    BeforeAll {
        Get-DifyApp | Remove-DifyApp -Confirm:$false
        $null = Import-DifyApp -Path (Join-Path -Path $env:PSDIFY_TEST_ROOT_ASSETS -ChildPath "app_chat.yml")
    }
    AfterAll {
        Get-DifyApp | Remove-DifyApp -Confirm:$false
    }

    Context "Get-DifyApp -Detail" {
        It "should get app with site details" {
            $Apps = Get-DifyApp -Detail

            @($Apps).Count | Should -Be 1
            $Apps[0].Id | Should -Not -BeNullOrEmpty
            $Apps[0].Name | Should -Be "Simple Chatbot"
            $Apps[0].EnableSite | Should -BeOfType [bool]
            $Apps[0].EnableAPI | Should -BeOfType [bool]
            $Apps[0].SiteToken | Should -Not -BeNullOrEmpty
            $Apps[0].SiteTitle | Should -Not -BeNullOrEmpty
            $Apps[0].SiteLanguage | Should -Not -BeNullOrEmpty
            $Apps[0].APIBaseUrl | Should -Not -BeNullOrEmpty
        }
    }

    Context "Set-DifyAppSite" {
        It "should enable site" {
            $App = Get-DifyApp -Name "Simple Chatbot"
            $AppSite = $App | Set-DifyAppSite -Enable

            @($AppSite).Count | Should -Be 1
            $AppSite.EnableSite | Should -Be $true
        }

        It "should disable site" {
            $App = Get-DifyApp -Name "Simple Chatbot"
            $AppSite = $App | Set-DifyAppSite -Disable

            @($AppSite).Count | Should -Be 1
            $AppSite.EnableSite | Should -Be $false
        }

        It "should update site title and language" {
            $App = Get-DifyApp -Name "Simple Chatbot"
            $AppSite = $App | Set-DifyAppSite -Title "New Title" -Language "ja-JP"

            @($AppSite).Count | Should -Be 1
            $AppSite.SiteTitle | Should -Be "New Title"
            $AppSite.SiteLanguage | Should -Be "ja-JP"
        }

        It "should update site icon" {
            $App = Get-DifyApp -Name "Simple Chatbot"
            $AppSite = $App | Set-DifyAppSite -Icon "smile" -IconType "emoji"

            @($AppSite).Count | Should -Be 1
            $AppSite.SiteIcon | Should -Be "smile"
            $AppSite.SiteIconType | Should -Be "emoji"
        }

        It "should enable site and update settings at once" {
            $App = Get-DifyApp -Name "Simple Chatbot"
            $AppSite = $App | Set-DifyAppSite -Enable -Title "Updated Title"

            @($AppSite).Count | Should -Be 1
            $AppSite.EnableSite | Should -Be $true
            $AppSite.SiteTitle | Should -Be "Updated Title"
        }

        It "should fail without any parameter" {
            $App = Get-DifyApp -Name "Simple Chatbot"
            { $App | Set-DifyAppSite } | Should -Throw
        }
    }

    Context "Set-DifyAppAPI" {
        It "should enable API" {
            $App = Get-DifyApp -Name "Simple Chatbot"
            $AppSite = $App | Set-DifyAppAPI -Enable

            @($AppSite).Count | Should -Be 1
            $AppSite.EnableAPI | Should -Be $true
        }

        It "should disable API" {
            $App = Get-DifyApp -Name "Simple Chatbot"
            $AppSite = $App | Set-DifyAppAPI -Disable

            @($AppSite).Count | Should -Be 1
            $AppSite.EnableAPI | Should -Be $false
        }
    }

    Context "Set-DifyApp" {
        It "should update app name" {
            $App = Get-DifyApp -Name "Simple Chatbot"
            $UpdatedApp = $App | Set-DifyApp -Name "Updated Chatbot"

            @($UpdatedApp).Count | Should -Be 1
            $UpdatedApp.Name | Should -Be "Updated Chatbot"
        }

        It "should update app description" {
            $App = Get-DifyApp -Name "Updated Chatbot"
            $UpdatedApp = $App | Set-DifyApp -Description "New description"

            @($UpdatedApp).Count | Should -Be 1
            $UpdatedApp.Description | Should -Be "New description"
        }

        It "should update app icon" {
            $App = Get-DifyApp -Name "Updated Chatbot"
            $null = $App | Set-DifyApp -Icon "robot" -IconType "emoji"
            $AppDetail = Get-DifyApp -Name "Updated Chatbot" -Detail

            $AppDetail.Icon | Should -Be "robot"
            $AppDetail.IconType | Should -Be "emoji"
        }

        It "should preserve existing values when parameters are omitted" {
            $App = Get-DifyApp -Name "Updated Chatbot"
            $UpdatedApp = $App | Set-DifyApp -Name "Preserved Chatbot"
            $AppDetail = Get-DifyApp -Name "Preserved Chatbot" -Detail

            $UpdatedApp.Description | Should -Be "New description"
            $AppDetail.Icon | Should -Be "robot"
            $AppDetail.IconType | Should -Be "emoji"
        }
    }

    Context "Set-DifyAppSite -SyncFromApp and Set-DifyApp -SyncFromSite" {
        BeforeAll {
            $App = Get-DifyApp -Name "Preserved Chatbot"
            $null = $App | Set-DifyApp -Name "Sync Test App" -Description "App description"
            $null = Get-DifyApp -Name "Sync Test App" | Set-DifyAppSite -Title "Old Site Title" -Description "Old site description"
            $null = Get-DifyApp -Name "Sync Test App" | Set-DifyAppSite -Enable
        }

        It "should sync app to site" {
            $App = Get-DifyApp -Name "Sync Test App"
            $AppSite = $App | Set-DifyAppSite -SyncFromApp

            @($AppSite).Count | Should -Be 1
            $AppSite.SiteTitle | Should -Be "Sync Test App"
            $AppSite.SiteDescription | Should -Be "App description"
        }

        It "should sync site to app" {
            $App = Get-DifyApp -Name "Sync Test App"
            $null = $App | Set-DifyAppSite -Title "New Site Title" -Description "New site description"
            $App = Get-DifyApp -Name "Sync Test App"
            $UpdatedApp = $App | Set-DifyApp -SyncFromSite

            @($UpdatedApp).Count | Should -Be 1
            $UpdatedApp.Name | Should -Be "New Site Title"
        }
    }
}
