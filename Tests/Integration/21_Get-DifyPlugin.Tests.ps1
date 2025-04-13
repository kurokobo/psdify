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

Describe "Connection" -Tag "plugin" {
    It "should connect correct server" {
        $env:PSDIFY_URL | Should -Be $DefaultServer
    }
}

Describe "Get-DifyPlugin" -Tag "plugin" { 
    BeforeAll {
        if ($env:PSDIFY_PLUGIN_SUPPORT) {
            Get-DifyPlugin | Uninstall-DifyPlugin -Confirm:$false
        }
    }

    Context "Not available" {
        It "should throw error when plugin is not supported" {
            if (-not $env:PSDIFY_PLUGIN_SUPPORT) {
                { Install-DifyPlugin -Id "langgenius/openai" } | Should -Throw
                { Get-DifyPlugin -Id "langgenius/openai" } | Should -Throw
                { Uninstall-DifyPlugin -Id "langgenius/openai" } | Should -Throw
            }
        }
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

        It "should download plugins when -Download parameter is specified" {
            $Id = "langgenius/openai"
            $DownloadedFiles = Find-DifyPlugin -Id $Id -Download

            @($DownloadedFiles).Count | Should -Be 1
            $DownloadedFiles | Should -BeOfType [System.IO.FileInfo]
            Test-Path -Path $DownloadedFiles.FullName | Should -BeTrue

            $Plugin = Find-DifyPlugin -Id $Id
            $ExpectedFileName = "$($Id.Replace('/', '-'))_$($Plugin.LatestVersion).difypkg"
            $DownloadedFiles.Name | Should -Be $ExpectedFileName

            Remove-Item -Path $DownloadedFiles.FullName -Force
        }

        It "should download multiple plugins when -Download parameter is specified" {
            $DownloadedFiles = Find-DifyPlugin -Category "model" -Search "openai" -Download

            @($DownloadedFiles).Count | Should -BeGreaterThan 1
            foreach ($File in $DownloadedFiles) {
                $File | Should -BeOfType [System.IO.FileInfo]
                Test-Path -Path $File.FullName | Should -BeTrue
            }

            foreach ($File in $DownloadedFiles) {
                Remove-Item -Path $File.FullName -Force
            }
        }

        It "should throw error when no plugins found with -Download parameter" {
            { Find-DifyPlugin -Id "non-existent-plugin-id" -Download } | Should -Throw "No plugins found to download"
        }
    }

    Context "Manage plugins - Marketplace" {
        It "should get empty plugins" {
            if ($env:PSDIFY_PLUGIN_SUPPORT) {
                $Plugins = Get-DifyPlugin

                @($Plugins).Count | Should -Be 0
            }
        }

        It "should install plugin by id" {
            if ($env:PSDIFY_PLUGIN_SUPPORT) {
                $Id = "langgenius/openai"
                $InstalledPlugins = Install-DifyPlugin -Id $Id -Wait
                $Plugin = Get-DifyPlugin -Id $Id

                @($InstalledPlugins).Count | Should -Be 1
                $InstalledPlugins.Id | Should -Be $Id
                @($Plugin).Count | Should -Be 1
                $Plugin.Id | Should -Be $Id
            }
        }

        It "should install plugin by package identifier" {
            if ($env:PSDIFY_PLUGIN_SUPPORT) {
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
        }

        It "should install plugin by pipeline" {
            if ($env:PSDIFY_PLUGIN_SUPPORT) {
                $Id = "langgenius/wikipedia"
                $InstalledPlugins = Find-DifyPlugin -Id $Id | Install-DifyPlugin -Wait
                $Plugin = Get-DifyPlugin -Id $Id

                @($InstalledPlugins).Count | Should -Be 1
                $InstalledPlugins.Id | Should -Be $Id
                @($Plugin).Count | Should -Be 1
                $Plugin.Id | Should -Be $Id
            }
        }

        It "should get installed plugins" {
            if ($env:PSDIFY_PLUGIN_SUPPORT) {
                $Plugins = Get-DifyPlugin

                @($Plugins).Count | Should -Be 3
            }
        }

        It "should get installed plugins by id" {
            if ($env:PSDIFY_PLUGIN_SUPPORT) {
                $Plugins = Get-DifyPlugin -Id "langgenius/openai"

                @($Plugins).Count | Should -Be 1
                $Plugins.Id | Should -Be "langgenius/openai"
            }
        }

        It "should get installed plugins by name" {
            if ($env:PSDIFY_PLUGIN_SUPPORT) {
                $Plugins = Get-DifyPlugin -Name "openai"

                @($Plugins).Count | Should -Be 1
                $Plugins.Name | Should -Be "openai"
            }
        }

        It "should get installed plugins by search term" {
            if ($env:PSDIFY_PLUGIN_SUPPORT) {
                $Plugins = Get-DifyPlugin -Search "langgenius"

                @($Plugins).Count | Should -Be 3
            }
        }

        It "should get installed plugins by category" {
            if ($env:PSDIFY_PLUGIN_SUPPORT) {
                $Plugins = Get-DifyPlugin -Category "model"

                @($Plugins).Count | Should -Be 2
                foreach ($Plugin in $Plugins) {
                    $Plugin.Category | Should -Be "model"
                }
            }
        }

        It "should uninstall plugin by id" {
            if ($env:PSDIFY_PLUGIN_SUPPORT) {
                Get-DifyPlugin -Id "langgenius/openai" | Uninstall-DifyPlugin -Confirm:$false
                $Plugins = Get-DifyPlugin -Id "langgenius/openai"

                @($Plugins).Count | Should -Be 0
            }
        }

        It "should uninstall all plugins" {
            if ($env:PSDIFY_PLUGIN_SUPPORT) {
                Get-DifyPlugin | Uninstall-DifyPlugin -Confirm:$false
                $Plugins = Get-DifyPlugin

                @($Plugins).Count | Should -Be 0
            }
        }
    }

    Context "Manage plugins - Local file" {
        BeforeAll {
            if ($env:PSDIFY_PLUGIN_SUPPORT) {
                $PluginFileInfo = Find-DifyPlugin -Id "langgenius/openai" -Download
            }
        }

        AfterAll {
            if ($env:PSDIFY_PLUGIN_SUPPORT) {
                if ($PluginFileInfo -and (Test-Path -Path $PluginFileInfo.FullName)) {
                    Remove-Item -Path $PluginFileInfo.FullName -Force
                }
            }
        }

        It "should install plugin from local file path" {
            if ($env:PSDIFY_PLUGIN_SUPPORT) {
                $InstalledPlugins = Install-DifyPlugin -LocalFile $PluginFileInfo.FullName -Wait
                $Plugins = Get-DifyPlugin

                @($InstalledPlugins).Count | Should -BeGreaterThan 0
                @($Plugins).Count | Should -BeGreaterThan 0

                Get-DifyPlugin | Uninstall-DifyPlugin -Confirm:$false
            }
        }
        
        It "should install plugin from FileInfo object" {
            if ($env:PSDIFY_PLUGIN_SUPPORT) {
                $InstalledPlugins = Install-DifyPlugin -LocalFile $PluginFileInfo -Wait
                $Plugins = Get-DifyPlugin

                @($InstalledPlugins).Count | Should -BeGreaterThan 0
                @($Plugins).Count | Should -BeGreaterThan 0

                Get-DifyPlugin | Uninstall-DifyPlugin -Confirm:$false
            }
        }
        
        It "should throw error when file not found" {
            if ($env:PSDIFY_PLUGIN_SUPPORT) {
                $NonExistentPath = Join-Path -Path $TestDrive -ChildPath "non-existent-plugin.difypkg"
                { Install-DifyPlugin -LocalFile $NonExistentPath } | Should -Throw
            }
        }

        It "should uninstall all plugins" {
            if ($env:PSDIFY_PLUGIN_SUPPORT) {
                Get-DifyPlugin | Uninstall-DifyPlugin -Confirm:$false
                $Plugins = Get-DifyPlugin
                @($Plugins).Count | Should -Be 0
            }
        }
    }
}
