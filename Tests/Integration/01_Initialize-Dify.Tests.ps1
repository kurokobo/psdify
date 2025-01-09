#Requires -Modules @{ ModuleName="Pester"; ModuleVersion="5.6" }

BeforeDiscovery {
    $PesterPhase = "BeforeDiscovery"
    . (Join-Path -Path (Split-Path -Path $PSScriptRoot) -ChildPath "Initialize-PSDifyPester.ps1")
}

BeforeAll {
    . (Join-Path -Path (Split-Path -Path $PSScriptRoot) -ChildPath "Initialize-PSDifyPester.ps1")
}

Describe "Initialize-Dify" -Tag "init" -Skip:($env:PSDIFY_TEST_MODE -ne "community") {

    Context "Initialize vanilla Dify instance" {
        BeforeAll {
            Remove-DifyInstance -Path $env:PSDIFY_TEST_ROOT_DIFY
            New-DifyInstance -Path $env:PSDIFY_TEST_ROOT_DIFY -Version $env:PSDIFY_TEST_VERSION
        }

        It "should not initialized" {
            $SetUpEndpoint = Join-Url -Segments @($DefaultServer, "/console/api/setup")
            $InitEndpoint = Join-Url -Segments @($DefaultServer, "/console/api/init")
            $SetUpStatus = (Invoke-DifyRestMethod -Uri $SetUpEndpoint -Method "GET").step
            $InitStatus = (Invoke-DifyRestMethod -Uri $InitEndpoint -Method "GET").status

            $SetUpStatus | Should -Be "not_started"
            $InitStatus | Should -Be "finished"
        }

        It "should initialize Dify" {
            $Result = Initialize-Dify -Server $DefaultServer -Email $DefaultEmail -Name $DefaultName -Password $DefaultPassword

            $Result.Server | Should -Be $DefaultServer
            if ($env:PSDIFY_TEST_ALLOW_VERSION_TEST) {
                $Result.Version | Should -Be $env:PSDIFY_TEST_VERSION
            }
            $Result.Name | Should -Be $DefaultName
            $Result.Email | Should -Be $DefaultEmail
        }
    }

    Context "Initialize Dify instance which has INIT_PASSWORD" {
        BeforeAll {
            Remove-DifyInstance -Path $env:PSDIFY_TEST_ROOT_DIFY
            New-DifyInstance -Path $env:PSDIFY_TEST_ROOT_DIFY -Version $env:PSDIFY_TEST_VERSION -EnvFile (Join-Path -Path $env:PSDIFY_TEST_ROOT_ASSETS -ChildPath "env_init_password.env")
        }

        It "should not initialized" {
            $SetUpEndpoint = Join-Url -Segments @($DefaultServer, "/console/api/setup")
            $InitEndpoint = Join-Url -Segments @($DefaultServer, "/console/api/init")
            $SetUpStatus = (Invoke-DifyRestMethod -Uri $SetUpEndpoint -Method "GET").step
            $InitStatus = (Invoke-DifyRestMethod -Uri $InitEndpoint -Method "GET").status

            $SetUpStatus | Should -Be "not_started"
            $InitStatus | Should -Be "not_started"
        }

        It "should initialize Dify" {
            $Result = Initialize-Dify -Server $DefaultServer -Email $DefaultEmail -Name $DefaultName -InitPassword $DefaultInitPassword -Password $DefaultPassword

            $Result.Server | Should -Be $DefaultServer
            if ($env:PSDIFY_TEST_ALLOW_VERSION_TEST) {
                $Result.Version | Should -Be $env:PSDIFY_TEST_VERSION
            }
            $Result.Name | Should -Be $DefaultName
            $Result.Email | Should -Be $DefaultEmail

            $env:PSDIFY_URL | Should -Be $DefaultServer
            if ($env:PSDIFY_TEST_ALLOW_VERSION_TEST) {
                $env:PSDIFY_VERSION | Should -Be $env:PSDIFY_TEST_VERSION
            }
            $env:PSDIFY_CONSOLE_TOKEN | Should -Not -BeNullOrEmpty
            $env:PSDIFY_CONSOLE_REFRESH_TOKEN | Should -Not -BeNullOrEmpty
        }
    }
}
