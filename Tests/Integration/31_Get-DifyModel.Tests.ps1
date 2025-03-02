#Requires -Modules @{ ModuleName="Pester"; ModuleVersion="5.6" }

BeforeDiscovery {
    $PesterPhase = "BeforeDiscovery"
    . (Join-Path -Path (Split-Path -Path $PSScriptRoot) -ChildPath "Initialize-PSDifyPester.ps1")
}

BeforeAll {
    . (Join-Path -Path (Split-Path -Path $PSScriptRoot) -ChildPath "Initialize-PSDifyPester.ps1")

    Start-DifyInstance -Path $env:PSDIFY_TEST_ROOT_DIFY -Version $env:PSDIFY_TEST_VERSION
    Show-DifyConnectionStatus (Connect-Dify -Server $DefaultServer -Email $DefaultEmail -Password $DefaultPassword -AuthMethod $DefaultAuthMethod)
}

Describe "Connection" -Tag "model" {
    It "should connect correct server" {
        $env:PSDIFY_URL | Should -Be $DefaultServer
    }
}

Describe "Get-DifyModel" -Tag "model" { 
    BeforeAll {
        Get-DifyModel | Remove-DifyModel -Confirm:$false
        if ($env:PSDIFY_PLUGIN_SUPPORT) {
            if (-not (Get-DifyPlugin -Id "langgenius/openai")) {
                Write-Host "  Cooling down for 10 seconds before installing the plugin" -ForegroundColor Cyan
                Start-Sleep -Seconds 10
                Find-DifyPlugin -Id "langgenius/openai" | Install-DifyPlugin -Wait
            }
        }
    }
    Context "Manage models" {
        It "should get empty models" -Skip:($env:PSDIFY_TEST_MODE -ne "community") {
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
            $Models.Provider | Should -Match "openai|langgenius/openai/openai"
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
            $Models.Provider | Should -Match "openai|langgenius/openai/openai"
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

        It "should remove all models" -Skip:($env:PSDIFY_TEST_MODE -ne "community") {
            Get-DifyModel | Remove-DifyModel -Confirm:$false

            $Models = Get-DifyModel
            @($Models).Count | Should -Be 0
        }
    }
}
