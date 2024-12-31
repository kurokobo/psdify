#Requires -Modules @{ ModuleName="Pester"; ModuleVersion="5.6" }

BeforeDiscovery {
    . (Join-Path -Path (Split-Path -Path $PSScriptRoot) -ChildPath "Tests/Set-PSDifyTestMode.ps1")
}

BeforeAll {
    . (Join-Path -Path (Split-Path -Path $PSScriptRoot) -ChildPath "Tests/Initialize-PSDifyPester.ps1")
}

Describe "Connect-Dify" {
    BeforeAll {
        Start-DifyInstance -Path $DifyRoot -Version $env:PSDIFY_TEST_VERSION
        Disconnect-Dify -Force
    }

    Context "Password authentication against Dify Community Edition" -Skip:$IsCloud {
        It "should connect Dify by arguments" {
            $Result = Connect-Dify -Server $DefaultServer -Email $DefaultEmail -Password $DefaultPassword

            $Result.Server | Should -Be $DefaultServer
            $Result.Version | Should -Be $env:PSDIFY_TEST_VERSION
            $Result.Name | Should -Be $DefaultName
            $Result.Email | Should -Be $DefaultEmail
        }

        It "should disconnect from Dify" {
            Disconnect-Dify

            $env:PSDIFY_URL | Should -BeNullOrEmpty
            $env:PSDIFY_CONSOLE_TOKEN | Should -BeNullOrEmpty
            $env:PSDIFY_CONSOLE_REFRESH_TOKEN | Should -BeNullOrEmpty
            $env:PSDIFY_VERSION | Should -BeNullOrEmpty
        }

        It "should connect Dify by environment variables" {
            $env:PSDIFY_URL = $DefaultServer
            $env:PSDIFY_EMAIL = $DefaultEmail
            $env:PSDIFY_PASSWORD = $DefaultPlainPassword

            $Result = Connect-Dify

            $Result.Server | Should -Be $DefaultServer
            $Result.Version | Should -Be $env:PSDIFY_TEST_VERSION
            $Result.Name | Should -Be $DefaultName
            $Result.Email | Should -Be $DefaultEmail
        }

        It "should disconnect from Dify" {
            Disconnect-Dify

            $env:PSDIFY_URL | Should -BeNullOrEmpty
            $env:PSDIFY_CONSOLE_TOKEN | Should -BeNullOrEmpty
            $env:PSDIFY_CONSOLE_REFRESH_TOKEN | Should -BeNullOrEmpty
            $env:PSDIFY_VERSION | Should -BeNullOrEmpty
        }
    }

    Context "Password authentication against Dify Cloud Edition" -Skip:$IsCommunity {
        It "should connect Dify by arguments" {
            $Result = Connect-Dify -Server $DefaultServer -Email $DefaultEmail -AuthMethod "Code"

            $Result.Server | Should -Be $DefaultServer
            $Result.Version | Should -Be $env:PSDIFY_TEST_VERSION
            $Result.Email | Should -Be $DefaultEmail
        }
    }
}
