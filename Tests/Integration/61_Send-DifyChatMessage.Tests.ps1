#Requires -Modules @{ ModuleName="Pester"; ModuleVersion="5.6" }

BeforeDiscovery {
    $PesterPhase = "BeforeDiscovery"
    . (Join-Path -Path (Split-Path -Path $PSScriptRoot) -ChildPath "Initialize-PSDifyPester.ps1")
}

BeforeAll {
    . (Join-Path -Path (Split-Path -Path $PSScriptRoot) -ChildPath "Initialize-PSDifyPester.ps1")

    Start-DifyInstance -Path $env:PSDIFY_TEST_ROOT_DIFY -Version $env:PSDIFY_TEST_VERSION
    Show-DifyConnectionStatus (Connect-Dify -Server $DefaultServer -Email $DefaultEmail -Password $DefaultPassword -AuthMethod $DefaultAuthMethod)

    $env:PSDIFY_APP_URL = $DefaultAPIServer
}

Describe "Connection" -Tag "chat" {
    It "should connect correct server" {
        $env:PSDIFY_URL | Should -Be $DefaultServer
    }
}

Describe "Send-DifyChatMessage" -Tag "chat" { 
    BeforeAll {
        Get-DifyKnowledge | Remove-DifyKnowledge -Confirm:$false
        Get-DifyApp | Remove-DifyApp -Confirm:$false

        if ($env:PSDIFY_PLUGIN_SUPPORT) {
            if (-not (Get-DifyPlugin -Id "langgenius/openai")) {
                Find-DifyPlugin -Id "langgenius/openai" | Install-DifyPlugin -Wait
            }
        }

        $null = New-DifyModel -Provider "openai" -From "predefined" -Credential @{
            "openai_api_key" = $env:PSDIFY_TEST_OPENAI_KEY
        }
        $null = Set-DifySystemModel -Type "llm" -Provider "openai" -Name "gpt-4o-mini"
        $null = Set-DifySystemModel -Type "text-embedding" -Provider "openai" -Name "text-embedding-3-small"

        $TestKnowledge = New-DifyKnowledge -Name "Test Knowledge"
        $null = Add-DifyDocument -Knowledge $TestKnowledge -Path (Join-Path -Path $env:PSDIFY_TEST_ROOT_ASSETS -ChildPath "document_test*.md") -Wait

        $OldKnowledgeId = "c1410caa-1a19-4a86-b9c8-a4c252d6e930"
        $TestAppWithoutKnowledge = Import-DifyApp -Path (Join-Path -Path $env:PSDIFY_TEST_ROOT_ASSETS -ChildPath "app_chat.yml")
        $TestAppWithKnowledge = (Get-DifyDSLContent -Path (Join-Path -Path $env:PSDIFY_TEST_ROOT_ASSETS -ChildPath "app_knowledge.yml")) -replace $OldKnowledgeId, $TestKnowledge.Id | Import-DifyApp -Content
        $TestAppWithoutKnowledgeAPIKey = $TestAppWithoutKnowledge | New-DifyAppAPIKey
        $TestAppWithKnowledgeAPIKey = $TestAppWithKnowledge | New-DifyAppAPIKey

        Mock -ModuleName PSDify -CommandName Write-Host { }
    }
    AfterAll {
        Get-DifyKnowledge | Remove-DifyKnowledge -Confirm:$false
        Get-DifyApp | Remove-DifyApp -Confirm:$false
    }

    Context "Send messages" {
        It "should send messages without knowledge" {
            $env:PSDIFY_APP_TOKEN = $TestAppWithoutKnowledgeAPIKey.Token
            Send-DifyChatMessage -NewSession -Message "If I say ping, please respond with pong."
            Send-DifyChatMessage -Message "Ping"

            Assert-MockCalled -ModuleName PSDify -CommandName Write-Host -ParameterFilter { $Object -like "*Pong*" }
        }
        It "should send messages without knowledge with multibyte characters" {
            $env:PSDIFY_APP_TOKEN = $TestAppWithoutKnowledgeAPIKey.Token
            Send-DifyChatMessage -NewSession -Message "日本語で朝の挨拶は？ ひらがなで。"

            Assert-MockCalled -ModuleName PSDify -CommandName Write-Host -ParameterFilter { $Object -like "*おはよ*" }
        }
        It "should send messages with knowledge" {
            $env:PSDIFY_APP_TOKEN = $TestAppWithKnowledgeAPIKey.Token
            Send-DifyChatMessage -NewSession -Message "What is the vegetable that is deep ruby red in color ?"

            Assert-MockCalled -ModuleName PSDify -CommandName Write-Host -ParameterFilter { $Object -like "*Rubyroot*" }
        }
    }
}
