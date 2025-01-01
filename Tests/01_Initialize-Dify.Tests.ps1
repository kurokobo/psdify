#Requires -Modules @{ ModuleName="Pester"; ModuleVersion="5.6" }

BeforeDiscovery {
    . (Join-Path -Path (Split-Path -Path $PSScriptRoot) -ChildPath "Tests/Set-PSDifyTestMode.ps1")
}

BeforeAll {
    . (Join-Path -Path (Split-Path -Path $PSScriptRoot) -ChildPath "Tests/Initialize-PSDifyPester.ps1")
}

Describe "Initialize-Dify" -Skip:$IsCloud {

    Context "Initialize vanilla Dify instance" {
        BeforeAll {
            Remove-DifyInstance -Path $DifyRoot
            New-DifyInstance -Path $DifyRoot -Version $env:PSDIFY_TEST_VERSION
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
            if ($InvokeVersionTests) {
                $Result.Version | Should -Be $env:PSDIFY_TEST_VERSION
            }
            $Result.Name | Should -Be $DefaultName
            $Result.Email | Should -Be $DefaultEmail
        }
    }

    Context "Initialize Dify instance which has INIT_PASSWORD" {
        BeforeAll {
            Remove-DifyInstance -Path $DifyRoot
            New-DifyInstance -Path $DifyRoot -Version $env:PSDIFY_TEST_VERSION -EnvFile (Join-Path -Path $AssetsRoot -ChildPath "env_init_password.env")
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
            if ($InvokeVersionTests) {
                $Result.Version | Should -Be $env:PSDIFY_TEST_VERSION
            }
            $Result.Name | Should -Be $DefaultName
            $Result.Email | Should -Be $DefaultEmail

            $env:PSDIFY_URL | Should -Be $DefaultServer
            if ($InvokeVersionTests) {
                $env:PSDIFY_VERSION | Should -Be $env:PSDIFY_TEST_VERSION
            }
            $env:PSDIFY_CONSOLE_TOKEN | Should -Not -BeNullOrEmpty
            $env:PSDIFY_CONSOLE_REFRESH_TOKEN | Should -Not -BeNullOrEmpty
        }
    }
}
