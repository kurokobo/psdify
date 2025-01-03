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

Describe "Get-DifyModel" { 
    BeforeAll {
        Get-DifyModel | Remove-DifyModel -Confirm:$false
    }
    Context "Manage models" {
        It "should get empty models" -Skip:$IsCloud {
            $Models = Get-DifyModel

            @($Models).Count | Should -Be 0
        }

        It "should add new predefined models" {
            $Models = New-DifyModel -Provider "openai" -From "predefined" -Credential @{
                "openai_api_key" = $env:PSDIFY_TEST_OPENAI_KEY
            }

            @($Models).Count | Should -BeGreaterThan 0
        }

        It "should add new customizable models" {
            $Models = New-DifyModel -Provider "openai" -From "customizable" -Type "llm" -Name "gpt-4o-mini" -Credential @{
                "openai_api_key" = $env:PSDIFY_TEST_OPENAI_KEY
            }

            @($Models).Count | Should -Be 1
            $Models.Provider | Should -Be "openai"
            $Models.Model | Should -Be "gpt-4o-mini"
            $Models.Type | Should -Be  "llm"
            $Models.FetchFrom | Should -Be "customizable-model"
        }

        It "should get all models" {
            $Models = Get-DifyModel

            @($Models).Count | Should -BeGreaterThan 0
        }

        It "should get models by from" {
            $Froms = @("predefined", "customizable")
            foreach ($From in $Froms) {
                $Models = Get-DifyModel -From $From

                @($Models).Count | Should -BeGreaterThan 0
                foreach ($Model in $Models) {
                    $Model.FetchFrom | Should -Be "$($From)-model"
                }
            }
        }

        It "should get models by name" {
            $Models = Get-DifyModel -Provider "openai" -Name "o1-preview"

            @($Models).Count | Should -Be 1
            $Models.Provider | Should -Be "openai"
            $Models.Model | Should -Be "o1-preview"
            $Models.Type | Should -Be  "llm"
            $Models.FetchFrom | Should -Be "predefined-model"
        }

        It "should get models by type" {
            $Types = @("llm", "text-embedding", "speech2text", "moderation", "tts")
            foreach ($Type in $Types) {
                $Models = Get-DifyModel -Type $Type

                @($Models).Count | Should -BeGreaterThan 0
                foreach ($Model in $Models) {
                    $Model.Type | Should -Be $Type
                }
            }
        }

        It "should remove all models" -Skip:$IsCloud {
            Get-DifyModel | Remove-DifyModel -Confirm:$false

            $Models = Get-DifyModel
            @($Models).Count | Should -Be 0
        }
    }
}
