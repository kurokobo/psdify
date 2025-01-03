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

Describe "Get-DifySystemModel" { 
    BeforeAll {
        Get-DifyModel | Remove-DifyModel -Confirm:$false
        $Models = New-DifyModel -Provider "openai" -From "predefined" -Credential @{
            "openai_api_key" = $env:PSDIFY_TEST_OPENAI_KEY
        }

        $ValidTypes = @("llm", "text-embedding", "rerank", "speech2text", "tts")
        $NewSystemModels = @(
            @{
                Type     = "llm"
                Provider = "openai"
                Name     = "gpt-4o-mini"
            },
            @{
                Type     = "text-embedding"
                Provider = "openai"
                Name     = "text-embedding-3-small"
            },
            @{
                Type     = "speech2text"
                Provider = "openai"
                Name     = "whisper-1"
            },
            @{
                Type     = "tts"
                Provider = "openai"
                Name     = "tts-1-hd"
            }
        )
    }
    Context "Manage models" {
        It "should get list of system models" {
            $SystemModels = Get-DifySystemModel

            foreach ($Type in $ValidTypes) {
                $SystemModels | Where-Object { $_.Type -eq $Type } | Should -Not -BeNullOrEmpty
            }
        }

        It "should set system model" {
            foreach ($NewSystemModel in $NewSystemModels) {
                $SystemModel = Set-DifySystemModel -Type $NewSystemModel.Type -Provider $NewSystemModel.Provider -Name $NewSystemModel.Name

                $SystemModel.Type | Should -Be $NewSystemModel.Type
                $SystemModel.Provider | Should -Be $NewSystemModel.Provider
                $SystemModel.Model | Should -Be $NewSystemModel.Name
            }
        }

        It "should get system models" {
            $SystemModels = Get-DifySystemModel
            foreach ($NewSystemModel in $NewSystemModels) {
                $SystemModel = $SystemModels | Where-Object { $_.Type -eq $NewSystemModel.Type }

                $SystemModel.Type | Should -Be $NewSystemModel.Type
                $SystemModel.Provider | Should -Be $NewSystemModel.Provider
                $SystemModel.Model | Should -Be $NewSystemModel.Name
            }
        }
    }
}