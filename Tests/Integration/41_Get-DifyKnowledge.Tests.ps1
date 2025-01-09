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

Describe "Connection" -Tag "knowledge" {
    It "should connect correct server" {
        $env:PSDIFY_URL | Should -Be $DefaultServer
    }
}

Describe "Get-DifyKnowledge" -Tag "knowledge" { 
    BeforeAll {
        Get-DifyKnowledge | Remove-DifyKnowledge -Confirm:$false
    }
    Context "Manage knowledges" {
        It "should get no knowledge" {
            $Knowledges = Get-DifyKnowledge

            @($Knowledges).Count | Should -Be 0
        }

        It "should add new knowledges" {
            $NewKnowledgesInfo = @(
                @{
                    Name        = "Test Knowledge 1"
                    Description = "Test Description 2"
                },
                @{
                    Name        = "Test Knowledge 2"
                    Description = "Test Description 2"
                },
                @{
                    Name        = "Hoge"
                    Description = "Fuga"
                }
            )
            foreach ($NewKnowledgeInfo in $NewKnowledgesInfo) {
                $Knowledge = New-DifyKnowledge -Name $NewKnowledgeInfo.Name -Description $NewKnowledgeInfo.Description

                $Knowledge.Name | Should -Be $NewKnowledgeInfo.Name
                $Knowledge.Description | Should -Be $NewKnowledgeInfo.Description
            }
        }

        It "should get all knowledges" {
            $Knowledges = Get-DifyKnowledge

            @($Knowledges).Count | Should -Be 3
        }

        It "should get knowledges by name" {
            $Knowledges = Get-DifyKnowledge -Name "Test Knowledge 1"

            @($Knowledges).Count | Should -Be 1
            $Knowledges[0].Name | Should -Be "Test Knowledge 1"
        }

        It "should get knowledges by search" {
            $Knowledges = Get-DifyKnowledge -Search "Knowledge"

            @($Knowledges).Count | Should -Be 2
        }

        It "should remove knowledge" {
            Get-DifyKnowledge -Name "Hoge" | Remove-DifyKnowledge -Confirm:$false
            $Knowledges = Get-DifyKnowledge

            @($Knowledges).Count | Should -Be 2
        }

        It "should remove all knowledges" {
            Get-DifyKnowledge | Remove-DifyKnowledge -Confirm:$false
            $Knowledges = Get-DifyKnowledge

            @($Knowledges).Count | Should -Be 0
        }
    }
}
