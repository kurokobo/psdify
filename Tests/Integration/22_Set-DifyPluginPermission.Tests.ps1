#Requires -Modules @{ ModuleName="Pester"; ModuleVersion="5.6" }

BeforeDiscovery {
    $PesterPhase = "BeforeDiscovery"
    . (Join-Path -Path (Split-Path -Path $PSScriptRoot) -ChildPath "Initialize-PSDifyPester.ps1")
}

BeforeAll {
    . (Join-Path -Path (Split-Path -Path $PSScriptRoot) -ChildPath "Initialize-PSDifyPester.ps1")

    Start-DifyInstance -Path $env:PSDIFY_TEST_ROOT_DIFY -Version $env:PSDIFY_TEST_VERSION
    Show-DifyConnectionStatus (Connect-Dify -Server $DefaultServer -Email $DefaultEmail -Password $DefaultPassword -AuthMethod $DefaultAuthMethod)

    if ($env:PSDIFY_PLUGIN_SUPPORT) {
        $script:OriginalPermission = Get-DifyPluginPermission
    }
}

AfterAll {
    if ($env:PSDIFY_PLUGIN_SUPPORT -and $script:OriginalPermission) {
        Set-DifyPluginPermission -InstallPermission $script:OriginalPermission.InstallPermission -DebugPermission $script:OriginalPermission.DebugPermission | Out-Null
    }
}

Describe "Connection" -Tag "pluginpermission" {
    It "should connect correct server" {
        $env:PSDIFY_URL | Should -Be $DefaultServer
    }
}

Describe "DifyPluginPermission" -Tag "pluginpermission" {
    Context "Not available" {
        It "should throw error when plugin is not supported" {
            if (-not $env:PSDIFY_PLUGIN_SUPPORT) {
                { Get-DifyPluginPermission } | Should -Throw
                { Set-DifyPluginPermission -InstallPermission "admins" -DebugPermission "admins" } | Should -Throw
            }
        }
    }

    Context "Manage plugin permission" {
        It "should get plugin permission" {
            if ($env:PSDIFY_PLUGIN_SUPPORT) {
                $Permission = Get-DifyPluginPermission

                $Permission.InstallPermission | Should -BeIn @("everyone", "admins", "noone")
                $Permission.DebugPermission | Should -BeIn @("everyone", "admins", "noone")
            }
        }

        It "should update plugin permission" {
            if ($env:PSDIFY_PLUGIN_SUPPORT) {
                $UpdatedPermission = Set-DifyPluginPermission -InstallPermission "admins" -DebugPermission "admins"

                $UpdatedPermission.InstallPermission | Should -Be "admins"
                $UpdatedPermission.DebugPermission | Should -Be "admins"
            }
        }

        It "should update install permission only" {
            if ($env:PSDIFY_PLUGIN_SUPPORT) {
                $Before = Get-DifyPluginPermission
                $NextInstallPermission = if ($Before.InstallPermission -eq "admins") { "everyone" } else { "admins" }

                $UpdatedPermission = Set-DifyPluginPermission -InstallPermission $NextInstallPermission

                $UpdatedPermission.InstallPermission | Should -Be $NextInstallPermission
                $UpdatedPermission.DebugPermission | Should -Be $Before.DebugPermission
            }
        }

        It "should no-op when permission is unchanged" {
            if ($env:PSDIFY_PLUGIN_SUPPORT) {
                $Before = Get-DifyPluginPermission

                $After = Set-DifyPluginPermission -InstallPermission $Before.InstallPermission -DebugPermission $Before.DebugPermission

                $After.InstallPermission | Should -Be $Before.InstallPermission
                $After.DebugPermission | Should -Be $Before.DebugPermission
            }
        }
    }
}
