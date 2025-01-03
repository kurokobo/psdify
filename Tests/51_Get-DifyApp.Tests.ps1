#Requires -Modules @{ ModuleName="Pester"; ModuleVersion="5.6" }

BeforeDiscovery {
    . (Join-Path -Path (Split-Path -Path $PSScriptRoot) -ChildPath "Tests/Set-PSDifyTestMode.ps1")
}

BeforeAll {
    . (Join-Path -Path (Split-Path -Path $PSScriptRoot) -ChildPath "Tests/Initialize-PSDifyPester.ps1")

    $env:PSDIFY_URL = $DefaultServer
    $env:PSDIFY_EMAIL = $DefaultEmail
    $env:PSDIFY_PASSWORD = $DefaultPlainPassword
    $env:PSDIFY_AUTH_METHOD = $DefaultAuthMethod
    Start-DifyInstance -Path $DifyRoot -Version $env:PSDIFY_TEST_VERSION
    Connect-Dify
}

Describe "Get-DifyApp" { 
    BeforeAll {
        Get-DifyKnowledge | Remove-DifyKnowledge -Confirm:$false
        Get-DifyApp | Remove-DifyApp -Confirm:$false

        $null = New-DifyModel -Provider "openai" -From "predefined" -Credential @{
            "openai_api_key" = $env:PSDIFY_TEST_OPENAI_KEY
        }
        $null = Set-DifySystemModel -Type "llm" -Provider "openai" -Name "gpt-4o-mini"
        $null = Set-DifySystemModel -Type "text-embedding" -Provider "openai" -Name "text-embedding-3-small"

        $TestKnowledge = New-DifyKnowledge -Name "Test Knowledge"
        $null = Add-DifyDocument -Knowledge $TestKnowledge -Path (Join-Path -Path $AssetsRoot -ChildPath "document_test*.md") -Wait
        $TestFiles = @(
            @{
                Path = (Join-Path -Path $AssetsRoot -ChildPath "app_chat.yml")
                Name = "Simple Chatbot"
            },
            @{
                Path = (Join-Path -Path $AssetsRoot -ChildPath "app_knowledge.yml")
                Name = "Simple Chatbot with Knowledge"
            }
        )
        $OldKnowledgeId = "c1410caa-1a19-4a86-b9c8-a4c252d6e930"
    }
    AfterAll {
        Get-DifyKnowledge | Remove-DifyKnowledge -Confirm:$false
        Get-DifyApp | Remove-DifyApp -Confirm:$false
    }
    Context "Manage apps" {
        It "should get no apps" {
            $Apps = Get-DifyApp

            @($Apps).Count | Should -Be 0
        }

        It "should add new apps" {
            $Apps = Import-DifyApp -Path $TestFiles.Path

            @($Apps).Count | Should -Be 2
            foreach ($App in $Apps) {
                $App.Id | Should -Not -BeNullOrEmpty
                $App.Name | Should -BeIn $TestFiles.Name
                $App.Description | Should -BeLike "*シンプル*"
            }
        }

        It "should get all apps" {
            $Apps = Get-DifyApp

            @($Apps).Count | Should -Be 2
        }

        It "should get apps by name" {
            $App = Get-DifyApp -Name $TestFiles[0].Name

            @($App).Count | Should -Be 1
            $App.Name | Should -Be $TestFiles[0].Name
        }

        It "should get apps by search" {
            $Apps = Get-DifyApp -Search "Knowledge"

            @($Apps).Count | Should -Be 1
            $Apps.Name | Should -Be $TestFiles[1].Name
        }

        It "should get apps by mode" {
            $Apps = Get-DifyApp -Mode "chat"

            @($Apps).Count | Should -Be 2
        }

        It "should remove app" {
            Get-DifyApp -Name $TestFiles[0].Name | Remove-DifyApp -Confirm:$false
            $Apps = Get-DifyApp

            @($Apps).Count | Should -Be 1
        }

        It "should remove all apps" {
            Get-DifyApp | Remove-DifyApp -Confirm:$false
            $Apps = Get-DifyApp

            @($Apps).Count | Should -Be 0
        }
    }

    Context "Import apps" {
        AfterAll {
            Get-DifyApp | Remove-DifyApp -Confirm:$false
        }
        It "should import apps by specifying file path" {
            $Apps = Import-DifyApp -Path $TestFiles.Path

            @($Apps).Count | Should -Be 2
            foreach ($App in $Apps) {
                $App.Id | Should -Not -BeNullOrEmpty
                $App.Name | Should -BeIn $TestFiles.Name
            }
        }

        It "should import apps by specifying file object" {
            $Apps = Import-DifyApp -Item (Get-Item -Path $TestFiles.Path)

            @($Apps).Count | Should -Be 2
            foreach ($App in $Apps) {
                $App.Id | Should -Not -BeNullOrEmpty
                $App.Name | Should -BeIn $TestFiles.Name
            }
        }

        It "should import apps by passing file object by pipeline" {
            $Apps = Get-Item -Path $TestFiles.Path | Import-DifyApp

            @($Apps).Count | Should -Be 2
            foreach ($App in $Apps) {
                $App.Id | Should -Not -BeNullOrEmpty
                $App.Name | Should -BeIn $TestFiles.Name
            }
        }

        It "should import apps by specifying inline content" {
            $App = Get-DifyDSLContent -Path $TestFiles[0].Path | Import-DifyApp -Content

            @($App).Count | Should -Be 1
            $App.Id | Should -Not -BeNullOrEmpty
            $App.Name | Should -Be $TestFiles[0].Name
        }
    }

    Context "Export apps" {
        BeforeAll {
            $null = Import-DifyApp -Path $TestFiles.Path
        }
        AfterAll {
            Get-DifyApp | Remove-DifyApp -Confirm:$false
        }
        It "should export app" {
            $ExportedApp = Get-DifyApp -Name $TestFiles[0].Name | Export-DifyApp

            @($ExportedApp).Count | Should -Be 1
            $ExportedApp.Name | Should -Be $TestFiles[0].Name
            $ExportedApp.FileName | Should -BeLike "*$($ExportedApp.Name)*.yml"
        }

        It "should export all apps" {
            $ExportedApps = Export-DifyApp

            @($ExportedApps).Count | Should -Be 2
            foreach ($ExportedApp in $ExportedApps) {
                $ExportedApp.FileName | Should -BeLike "*$($ExportedApp.Name)*.yml"
            }
        }
    }

    Context "Manage DSL files" {
        It "should get raw DSL content" {
            $DSLContent = Get-DifyDSLContent -Path $TestFiles[0].Path

            $DSLContent | Should -Not -BeNullOrEmpty
            $DSLContent | Should -BeLike "*シンプル*"
        }

        It "should save DSL content" {
            $DSLContent = Get-DifyDSLContent -Path $TestFiles[1].Path
            $DSLFile = $DSLContent -replace $OldKnowledgeId, $TestKnowledge.Id | Set-DifyDSLContent -Path (Join-Path -Path $TempRoot -ChildPath "app_knowledge_modified.yml")
            $ModifiedDSLContent = Get-DifyDSLContent -Path $DSLFile.FullName

            $DSLFile.FullName | Should -BeLike "*app_knowledge_modified.yml"
            $ModifiedDSLContent | Should -BeLike "*シンプル*"
            $ModifiedDSLContent | Should -Not -BeLike "*$OldKnowledgeId*"
            $ModifiedDSLContent | Should -BeLike "*$($TestKnowledge.Id)*"
        }
    }
    Context "Manage API keys" {
        BeforeAll {
            $TestAppWithoutKnowledge = Import-DifyApp -Path $TestFiles[0].Path
            $TestAppWithKnowledge = (Get-DifyDSLContent -Path $TestFiles[1].Path) -replace $OldKnowledgeId, $TestKnowledge.Id | Import-DifyApp -Content
        }
        It "should get no API keys" {
            $APIKeys = $TestAppWithoutKnowledge | Get-DifyAppAPIKey

            @($APIKeys).Count | Should -Be 0
        }

        It "should add new API keys" {
            $APIKeys = (1..10) | ForEach-Object {
                $TestAppWithoutKnowledge | New-DifyAppAPIKey
            }

            @($APIKeys).Count | Should -Be 10
        }

        It "should get all API keys" {
            $APIKeys = $TestAppWithoutKnowledge | Get-DifyAppAPIKey

            @($APIKeys).Count | Should -Be 10
        }

        It "should remove API keys" {
            $TestAppWithoutKnowledge | Get-DifyAppAPIKey | Remove-DifyAppAPIKey -Confirm:$false

            $APIKeys = $TestAppWithoutKnowledge | Get-DifyAppAPIKey
            @($APIKeys).Count | Should -Be 0
        }
    }
}
