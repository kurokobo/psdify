#Requires -Modules @{ ModuleName="Pester"; ModuleVersion="5.6" }

BeforeDiscovery {
    $PesterPhase = "BeforeDiscovery"
    . (Join-Path -Path (Split-Path -Path $PSScriptRoot) -ChildPath "Initialize-PSDifyPester.ps1")
}

BeforeAll {
    . (Join-Path -Path (Split-Path -Path $PSScriptRoot) -ChildPath "Initialize-PSDifyPester.ps1")
}

Describe "Connect-Dify" -Tag "auth" {
    BeforeAll {
        Start-DifyInstance -Path $env:PSDIFY_TEST_ROOT_DIFY -Version $env:PSDIFY_TEST_VERSION
        Disconnect-Dify -Force
    }

    Context "Password authentication against Dify Community Edition" -Skip:($env:PSDIFY_TEST_MODE -ne "community") {
        It "should connect Dify by arguments" {
            $Result = Connect-Dify -Server $DefaultServer -Email $DefaultEmail -Password $DefaultPassword

            $Result.Server | Should -Be $DefaultServer
            if ($env:PSDIFY_TEST_ALLOW_VERSION_TEST) {
                $Result.Version | Should -Be $env:PSDIFY_TEST_VERSION
            }
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
            if ($env:PSDIFY_TEST_ALLOW_VERSION_TEST) {
                $Result.Version | Should -Be $env:PSDIFY_TEST_VERSION
            }
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

    Context "Password authentication against Dify Cloud Edition" -Skip:($env:PSDIFY_TEST_MODE -ne "cloud") {
        It "should connect Dify by arguments" {
            $Result = Connect-Dify -Server $DefaultServer -Email $DefaultEmail -AuthMethod "Code"

            $Result.Server | Should -Be $DefaultServer
            $Result.Email | Should -Be $DefaultEmail
        }
    }
}
