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

Describe "Connection" -Tag "systemmodel" {
    It "should connect correct server" {
        $env:PSDIFY_URL | Should -Be $DefaultServer
    }
}

Describe "Get-DifySystemModel" -Tag "systemmodel" { 
    BeforeAll {
        Get-DifyModel | Remove-DifyModel -Confirm:$false
        if ($env:PSDIFY_PLUGIN_SUPPORT) {
            if (-not (Get-DifyPlugin -Id "langgenius/openai")) {
                Find-DifyPlugin -Id "langgenius/openai" | Install-DifyPlugin -Wait
            }
        }
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
                $SystemModel.Provider | Should -Match $NewSystemModel.Provider
                $SystemModel.Model | Should -Be $NewSystemModel.Name
            }
        }

        It "should get system models" {
            $SystemModels = Get-DifySystemModel
            foreach ($NewSystemModel in $NewSystemModels) {
                $SystemModel = $SystemModels | Where-Object { $_.Type -eq $NewSystemModel.Type }

                $SystemModel.Type | Should -Be $NewSystemModel.Type
                $SystemModel.Provider | Should -Match $NewSystemModel.Provider
                $SystemModel.Model | Should -Be $NewSystemModel.Name
            }
        }
    }
}