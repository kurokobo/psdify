#Requires -Modules @{ ModuleName="Pester"; ModuleVersion="5.6" }

BeforeDiscovery {
    . (Join-Path -Path (Split-Path -Path $PSScriptRoot) -ChildPath "Tests/Set-PSDifyTestMode.ps1")
    . (Join-Path -Path (Split-Path -Path $PSScriptRoot) -ChildPath "Tests/Initialize-PSDifyPester.ps1")

    $env:PSDIFY_URL = $DefaultServer
    $env:PSDIFY_EMAIL = $DefaultEmail
    $env:PSDIFY_PASSWORD = $DefaultPlainPassword
    $env:PSDIFY_AUTH_METHOD = $DefaultAuthMethod
    Start-DifyInstance -Path $DifyRoot -Version $env:PSDIFY_TEST_VERSION
    Connect-Dify
}

Describe "Dummy" {
    It "should be dummy" {
        $true | Should -Be $true
    }
}

Describe "Get-DifyPlugin" -Skip:($env:PSDIFY_PLUGIN_SUPPORT -ne "true") { 
    BeforeAll {
        Get-DifyPlugin | Uninstall-DifyPlugin -Confirm:$false
    }

    Context "Find plugins" {
        It "should list available plugins with collections" {
            $Plugins = Find-DifyPlugin

            @($Plugins).Count | Should -BeGreaterThan 0
        }

        It "should list available plugins which has a specific category" {
            $Categories = @("model", "tool")
            foreach ($Category in $Categories) {
                $Plugins = Find-DifyPlugin -Category $Category

                @($Plugins).Count | Should -BeGreaterThan 0
                foreach ($Plugin in $Plugins) {
                    $Plugin.Category | Should -Be $Category
                }
            }
        }

        It "should list available plugins which has a specific id" {
            $Plugins = Find-DifyPlugin -Id "langgenius/openai"

            @($Plugins).Count | Should -Be 1
            $Plugins.Id | Should -Be "langgenius/openai"
            $Plugins.LatestPackageIdentifier | Should -Not -BeNullOrEmpty
        }

        It "should list available plugins which has a specific name" {
            $Plugins = Find-DifyPlugin -Name "openai"

            @($Plugins).Count | Should -BeGreaterThan 0
            foreach ($Plugin in $Plugins) {
                $Plugin.Name | Should -Be "openai"
            }
        }

        It "should list available plugins which has a specific search term" {
            $Plugins = Find-DifyPlugin -Search "openai"

            @($Plugins).Count | Should -BeGreaterThan 1
        }
    }

    Context "Manage plugins" {
        It "should get empty plugins" {
            $Plugins = Get-DifyPlugin

            @($Plugins).Count | Should -Be 0
        }

        It "should install plugin by id" {
            $Id = "langgenius/openai"
            $InstalledPlugins = Install-DifyPlugin -Id $Id -Wait
            $Plugin = Get-DifyPlugin -Id $Id

            @($InstalledPlugins).Count | Should -Be 1
            $InstalledPlugins.Id | Should -Be $Id
            @($Plugin).Count | Should -Be 1
            $Plugin.Id | Should -Be $Id
        }

        It "should install plugin by package identifier" {
            $Id = "langgenius/anthropic"
            $PluginToBeInstalled = Find-DifyPlugin -Id $Id
            $InstalledPlugins = Install-DifyPlugin -UniqueIdentifier $PluginToBeInstalled.LatestPackageIdentifier -Wait
            $Plugin = Get-DifyPlugin -UniqueIdentifier $PluginToBeInstalled.LatestPackageIdentifier

            @($InstalledPlugins).Count | Should -Be 1
            $InstalledPlugins.Id | Should -Be $Id
            @($Plugin).Count | Should -Be 1
            $Plugin.Id | Should -Be $Id
            $Plugin.UniqueIdentifier | Should -Be $PluginToBeInstalled.LatestPackageIdentifier
        }

        It "should install plugin by pipeline" {
            $Id = "langgenius/wikipedia"
            $InstalledPlugins = Find-DifyPlugin -Id $Id | Install-DifyPlugin -Wait
            $Plugin = Get-DifyPlugin -Id $Id

            @($InstalledPlugins).Count | Should -Be 1
            $InstalledPlugins.Id | Should -Be $Id
            @($Plugin).Count | Should -Be 1
            $Plugin.Id | Should -Be $Id
        }

        It "should get installed plugins" {
            $Plugins = Get-DifyPlugin

            @($Plugins).Count | Should -Be 3
        }

        It "should get installed plugins by id" {
            $Plugins = Get-DifyPlugin -Id "langgenius/openai"

            @($Plugins).Count | Should -Be 1
            $Plugins.Id | Should -Be "langgenius/openai"
        }

        It "should get installed plugins by name" {
            $Plugins = Get-DifyPlugin -Name "openai"

            @($Plugins).Count | Should -Be 1
            $Plugins.Name | Should -Be "openai"
        }

        It "should get installed plugins by search term" {
            $Plugins = Get-DifyPlugin -Search "langgenius"

            @($Plugins).Count | Should -Be 3
        }

        It "should get installed plugins by category" {
            $Plugins = Get-DifyPlugin -Category "model"

            @($Plugins).Count | Should -Be 2
            foreach ($Plugin in $Plugins) {
                $Plugin.Category | Should -Be "model"
            }
        }

        It "should uninstall plugin by id" {
            Get-DifyPlugin -Id "langgenius/openai" | Uninstall-DifyPlugin -Confirm:$false
            $Plugins = Get-DifyPlugin -Id "langgenius/openai"

            @($Plugins).Count | Should -Be 0
        }

        It "should uninstall all plugins" {
            Get-DifyPlugin | Uninstall-DifyPlugin -Confirm:$false
            $Plugins = Get-DifyPlugin

            @($Plugins).Count | Should -Be 0
        }
    }
}
