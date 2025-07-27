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

Describe "Connection" -Tag "trace" {
    It "should connect correct server" {
        $env:PSDIFY_URL | Should -Be $DefaultServer
    }
}

Describe "Get-DifyAppTrace" -Tag "trace" {
    BeforeAll {
        Get-DifyApp | Remove-DifyApp -Confirm:$false

        if ($env:PSDIFY_PLUGIN_SUPPORT) {
            if (-not (Get-DifyPlugin -Id "langgenius/openai")) {
                Find-DifyPlugin -Id "langgenius/openai" | Install-DifyPlugin -Wait
            }
        }

        $null = New-DifyModel -Provider "openai" -From "predefined" -Credential @{
            "openai_api_key" = $env:PSDIFY_TEST_OPENAI_KEY
        }

        $TestApp = Import-DifyApp -Path (Join-Path -Path $env:PSDIFY_TEST_ROOT_ASSETS -ChildPath "app_chat.yml")
    }
    AfterAll {
        Get-DifyApp | Remove-DifyApp -Confirm:$false
    }
    Context "Get app trace (disabled)" {
        It "should get app trace (disabled)" {
            $Trace = Get-DifyAppTrace -App $TestApp
            $Trace.Enabled | Should -BeFalse
            $Trace.Provider | Should -BeNullOrEmpty
        }
    }
    Context "Get app trace config (disabled)" {
        It "should get app trace config (disabled)" {
            $TraceConfigs = Get-DifyAppTraceConfig -App $TestApp
            $TraceConfigs.Count | Should -BeGreaterThan 1
            $TraceConfigs | ForEach-Object {
                $_.IsEnabled | Should -BeFalse
                $_.IsActive | Should -BeFalse
                $_.Config | Should -BeNullOrEmpty
            }
        }
    }
    Context "New app trace config (disabled)" {
        It "should create app trace config" {
            $TraceConfig = New-DifyAppTraceConfig -App $TestApp -Provider "phoenix" -Config @{
                api_key  = "phoenix-admin-secret-00000000000"
                endpoint = "http://phoenix:6006/"
                project  = "psdify"
            }
            $TraceConfig.IsEnabled | Should -BeFalse
            $TraceConfig.IsActive | Should -BeTrue
            $TraceConfig.Config | Should -Not -BeNullOrEmpty

            $Trace = Get-DifyAppTrace -App $TestApp
            $Trace.Enabled | Should -BeFalse
            $Trace.Provider | Should -BeNullOrEmpty
        }
        It "should enable app trace" {
            $Trace = Get-DifyAppTrace -App $TestApp
            $Trace.Enabled | Should -BeFalse
            $Trace.Provider | Should -BeNullOrEmpty

            $Trace = Set-DifyAppTrace -App $TestApp -Provider "phoenix" -Enable
            $Trace.Enabled | Should -BeTrue
            $Trace.Provider | Should -Be "phoenix"

            $Trace = Set-DifyAppTrace -App $TestApp -Provider "phoenix" -Disable
            $Trace.Enabled | Should -BeFalse
            $Trace.Provider | Should -BeNullOrEmpty
        }
        It "should remove app trace config" {
            Remove-DifyAppTraceConfig -App $TestApp -Provider "phoenix" -Confirm:$false
            $TraceConfig = Get-DifyAppTraceConfig -App $TestApp -Provider "phoenix"
            $TraceConfig.IsEnabled | Should -BeFalse
            $TraceConfig.IsActive | Should -BeFalse
            $TraceConfig.Config | Should -BeNullOrEmpty
        }
        It "should create app trace config with enable switch" {
            $TraceConfig = New-DifyAppTraceConfig -App $TestApp -Provider "phoenix" -Config @{
                api_key  = "phoenix-admin-secret-00000000000"
                endpoint = "http://phoenix:6006/"
                project  = "psdify"
            } -Enable
            $TraceConfig.IsEnabled | Should -BeTrue
            $TraceConfig.IsActive | Should -BeTrue
            $TraceConfig.Config | Should -Not -BeNullOrEmpty

            $Trace = Get-DifyAppTrace -App $TestApp
            $Trace.Enabled | Should -BeTrue
            $Trace.Provider | Should -Be "phoenix"

            Remove-DifyAppTraceConfig -App $TestApp -Provider "phoenix" -Confirm:$false
            $TraceConfig = Get-DifyAppTraceConfig -App $TestApp -Provider "phoenix"
            $TraceConfig.IsEnabled | Should -BeFalse
            $TraceConfig.IsActive | Should -BeFalse
        }
        It "should set app trace config" {
            $TraceConfig = New-DifyAppTraceConfig -App $TestApp -Provider "phoenix" -Config @{
                api_key  = "phoenix-admin-secret-00000000000"
                endpoint = "http://phoenix:6006/"
                project  = "psdify"
            }
            $TraceConfig.IsEnabled | Should -BeFalse
            $TraceConfig.IsActive | Should -BeTrue

            $TraceConfig = Set-DifyAppTraceConfig -App $TestApp -Provider "phoenix" -Config @{
                api_key  = "phoenix-admin-secret-00000000000"
                endpoint = "http://phoenix:6006/"
                project  = "psdify"
            } -Enable
            $TraceConfig.IsEnabled | Should -BeTrue
            $TraceConfig.IsActive | Should -BeTrue

            Remove-DifyAppTraceConfig -App $TestApp -Provider "phoenix" -Confirm:$false
            $TraceConfig = Get-DifyAppTraceConfig -App $TestApp -Provider "phoenix"
            $TraceConfig.IsEnabled | Should -BeFalse
            $TraceConfig.IsActive | Should -BeFalse
        }
    }
}