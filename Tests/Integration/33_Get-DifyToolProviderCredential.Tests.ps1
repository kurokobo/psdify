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

Describe "Connection" -Tag "tool" {
    It "should connect correct server" {
        $env:PSDIFY_URL | Should -Be $DefaultServer
    }
}

Describe "Get-DifyToolProviderCredential and New-DifyToolProviderCredential" -Tag "tool" {
    BeforeAll {
        if ($env:PSDIFY_PLUGIN_SUPPORT) {
            if (-not (Get-DifyPlugin -Id "langgenius/openai_tool")) {
                Write-Host "  Cooling down for 10 seconds before installing the plugin" -ForegroundColor Cyan
                Start-Sleep -Seconds 10
                Find-DifyPlugin -Id "langgenius/openai_tool" | Install-DifyPlugin -Wait
            }
        }
        Get-DifyToolProviderCredential -Provider "langgenius/openai_tool/openai" | Remove-DifyToolProviderCredential -Confirm:$false
    }

    Context "Manage tool credentials" {
        It "should get empty credentials initially" {
            $Credentials = Get-DifyToolProviderCredential -Provider "langgenius/openai_tool/openai"

            @($Credentials).Count | Should -Be 0
        }

        It "should create new tool credential" {
            $Credentials = New-DifyToolProviderCredential -Provider "langgenius/openai_tool/openai" -Credential @{
                "openai_api_key" = $env:PSDIFY_TEST_OPENAI_KEY
            }

            @($Credentials).Count | Should -Be 1
            $Credentials[0].Provider | Should -Be "langgenius/openai_tool/openai"
            $Credentials[0].CredentialType | Should -Be "api-key"
            $Credentials[0].Name | Should -Be "API KEY 1"
        }

        It "should create additional tool credential with auto-incremented name" {
            $Credentials = New-DifyToolProviderCredential -Provider "langgenius/openai_tool/openai" -Credential @{
                "openai_api_key" = $env:PSDIFY_TEST_OPENAI_KEY
            }

            @($Credentials).Count | Should -Be 2
            $Credentials[1].Name | Should -Be "API KEY 2"
        }

        It "should create tool credential with custom name" {
            $Credentials = New-DifyToolProviderCredential -Provider "langgenius/openai_tool/openai" -Credential @{
                "openai_api_key" = $env:PSDIFY_TEST_OPENAI_KEY
            } -AuthorizationName "Custom Key Name"

            @($Credentials).Count | Should -Be 3
            ($Credentials | Where-Object { $_.Name -eq "Custom Key Name" }) | Should -Not -BeNullOrEmpty
        }

        It "should get all credentials" {
            $Credentials = Get-DifyToolProviderCredential -Provider "langgenius/openai_tool/openai"

            @($Credentials).Count | Should -Be 3
            $Credentials[0].Provider | Should -Be "langgenius/openai_tool/openai"
            $Credentials[0].CredentialType | Should -Be "api-key"
        }

        It "should remove tool credential" {
            $Credentials = Get-DifyToolProviderCredential -Provider "langgenius/openai_tool/openai"
            $Credentials[0] | Remove-DifyToolProviderCredential -Confirm:$false

            $RemainingCredentials = Get-DifyToolProviderCredential -Provider "langgenius/openai_tool/openai"
            @($RemainingCredentials).Count | Should -Be 2
        }

        It "should remove all remaining credentials" {
            Get-DifyToolProviderCredential -Provider "langgenius/openai_tool/openai" | Remove-DifyToolProviderCredential -Confirm:$false

            $Credentials = Get-DifyToolProviderCredential -Provider "langgenius/openai_tool/openai"
            @($Credentials).Count | Should -Be 0
        }
    }
}
