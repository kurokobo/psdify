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

        It "should respond with an authenticated session or token" {
            $Auth = Get-PSDifyConsoleAuth

            $Auth | Should -Not -BeNullOrEmpty
        }

        It "should disconnect from Dify" {
            Disconnect-Dify

            $env:PSDIFY_URL | Should -BeNullOrEmpty
            $env:PSDIFY_VERSION | Should -BeNullOrEmpty
        }

        It "should clear the authenticated session or token" {
            $Auth = Get-PSDifyConsoleAuth

            $Auth | Should -BeNullOrEmpty
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

        It "should respond with an authenticated session or token" {
            $Auth = Get-PSDifyConsoleAuth

            $Auth | Should -Not -BeNullOrEmpty
        }

        It "should disconnect from Dify" {
            Disconnect-Dify

            $env:PSDIFY_URL | Should -BeNullOrEmpty
            $env:PSDIFY_VERSION | Should -BeNullOrEmpty
        }

        It "should clear the authenticated session or token" {
            $Auth = Get-PSDifyConsoleAuth

            $Auth | Should -BeNullOrEmpty
        }
    }

    Context "Password authentication against Dify Cloud Edition" -Skip:($env:PSDIFY_TEST_MODE -ne "cloud") {
        It "should connect Dify by arguments" {
            $Result = Connect-Dify -Server $DefaultServer -Email $DefaultEmail -AuthMethod "Code"

            $Result.Server | Should -Be $DefaultServer
            $Result.Email | Should -Be $DefaultEmail
        }
    }

    Context "Access token authentication against Dify Community Edition" -Skip:($env:PSDIFY_TEST_MODE -ne "community") {
        It "should connect Dify by arguments with access token and CSRF token" {
            if (Compare-SimpleVersion -Version $env:PSDIFY_TEST_VERSION -Ge "1.9.2") {
                Connect-Dify -Server $DefaultServer -Email $DefaultEmail -Password $DefaultPassword -Force | Out-Null
                $Auth = Get-PSDifyConsoleAuth
                $ServerHostname = ([System.Uri]$DefaultServer).Host
                $AccessToken = ($Auth.Cookies.GetCookies($DefaultServer) | Where-Object { $_.Name -eq "access_token" } | Select-Object -First 1).Value | ConvertTo-SecureString -AsPlainText -Force
                $CSRFToken = ($Auth.Cookies.GetCookies($DefaultServer) | Where-Object { $_.Name -eq "csrf_token" } | Select-Object -First 1).Value | ConvertTo-SecureString -AsPlainText -Force
                $Result = Connect-Dify -Server $DefaultServer -AuthMethod "AccessToken" -AccessToken $AccessToken -CSRFToken $CSRFToken -Force

                $Result.Server | Should -Be $DefaultServer
                $Result.Name | Should -Be $DefaultName
                $Result.Email | Should -Be $DefaultEmail
            }
        }

        It "should connect Dify by environment variables with access token and CSRF token" {
            if (Compare-SimpleVersion -Version $env:PSDIFY_TEST_VERSION -Ge "1.9.2") {
                Connect-Dify -Server $DefaultServer -Email $DefaultEmail -Password $DefaultPassword -Force | Out-Null
                $Auth = Get-PSDifyConsoleAuth
                $AccessToken = ($Auth.Cookies.GetCookies($DefaultServer) | Where-Object { $_.Name -eq "access_token" } | Select-Object -First 1).Value
                $CSRFToken = ($Auth.Cookies.GetCookies($DefaultServer) | Where-Object { $_.Name -eq "csrf_token" } | Select-Object -First 1).Value

                $env:PSDIFY_URL = $DefaultServer
                $env:PSDIFY_AUTH_METHOD = "AccessToken"
                $env:PSDIFY_ACCESS_TOKEN = $AccessToken
                $env:PSDIFY_CSRF_TOKEN = $CSRFToken

                $Result = Connect-Dify -Force

                $Result.Server | Should -Be $DefaultServer
                $Result.Name | Should -Be $DefaultName
                $Result.Email | Should -Be $DefaultEmail
            }
        }
    }
}
