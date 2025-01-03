#Requires -Modules @{ ModuleName="Pester"; ModuleVersion="5.6" }

BeforeDiscovery {
    . (Join-Path -Path (Split-Path -Path $PSScriptRoot) -ChildPath "Tests/Set-PSDifyTestMode.ps1")
}

BeforeAll {
    . (Join-Path -Path (Split-Path -Path $PSScriptRoot) -ChildPath "Tests/Initialize-PSDifyPester.ps1")

    $env:PSDIFY_URL = $DefaultServer
    $env:PSDIFY_EMAIL = $DefaultEmail
    $env:PSDIFY_PASSWORD = $DefaultPlainPassword
    $env:PSDIFY_AUTH_METHOD = $DefaultAuthMethod
    Start-DifyInstance -Path $DifyRoot -Version $env:PSDIFY_TEST_VERSION
    Connect-Dify
}

Describe "Get-DifyDoument" { 
    BeforeAll {
        Get-DifyKnowledge | Remove-DifyKnowledge -Confirm:$false
        $TestKnowledge1 = New-DifyKnowledge -Name "Test Knowledge 1"
        $TestKnowledge2 = New-DifyKnowledge -Name "Test Knowledge 2"
    }
    AfterAll {
        Get-DifyKnowledge | Remove-DifyKnowledge -Confirm:$false
    }
    Context "Manage documents" {
        It "should get no documents" {
            $Documents = Get-DifyDocument -Knowledge $TestKnowledge1

            @($Documents).Count | Should -Be 0
        }

        It "should add new documents" {
            $TestFiles = @(
                (Join-Path -Path $AssetsRoot -ChildPath "document_test1.md"),
                (Join-Path -Path $AssetsRoot -ChildPath "document_test2.md")
            )
            $Documents = Add-DifyDocument -Knowledge $TestKnowledge1 -Path $TestFiles -IndexMode "economy"

            @($Documents).Count | Should -Be 2
            $Documents[0].Batch | Should -Not -BeNullOrEmpty
        }

        It "should add new documents and wait for indexing" {
            $TestFile = Join-Path -Path $AssetsRoot -ChildPath "document_test3.md"
            $Document = Add-DifyDocument -Knowledge $TestKnowledge1 -Path $TestFile -IndexMode "economy" -Wait

            @($Document).Count | Should -Be 1
            $Document.Name | Should -Be "document_test3.md"
            $Document.WordCount | Should -BeGreaterThan 0
            $Document.IndexingStatus | Should -Be "completed"
        }

        It "should get all documents" {
            $Documents = Get-DifyDocument -Knowledge $TestKnowledge1

            @($Documents).Count | Should -Be 3
        }

        It "should get documents by name" {
            $Document = Get-DifyDocument -Knowledge $TestKnowledge1 -Name "document_test1.md"

            @($Document).Count | Should -Be 1
            $Document[0].Name | Should -Be "document_test1.md"
        }

        It "should get documents by search" {
            $Documents = Get-DifyDocument -Knowledge $TestKnowledge1 -Search "test"

            @($Documents).Count | Should -Be 3
        }

        It "should remove document" {
            Get-DifyDocument -Knowledge $TestKnowledge1 -Name "document_test1.md" | Remove-DifyDocument -Confirm:$false
            $Documents = Get-DifyDocument -Knowledge $TestKnowledge1

            @($Documents).Count | Should -Be 2
        }

        It "should remove all documents" {
            Get-DifyDocument -Knowledge $TestKnowledge1 | Remove-DifyDocument -Confirm:$false
            $Documents = Get-DifyDocument -Knowledge $TestKnowledge1

            @($Documents).Count | Should -Be 0
        }
    }

    Context "Chunking modes" {
        It "should add new documents with automatic mode" {
            $TestFile = Join-Path -Path $AssetsRoot -ChildPath "document_test1.md"
            $Document = Add-DifyDocument -Knowledge $TestKnowledge2 -Path $TestFile -IndexMode "economy"

            @($Document).Count | Should -Be 1
            $Document.Name | Should -Be "document_test1.md"
        }

        It "should add new documents with custom mode" {
            $TestFile = Join-Path -Path $AssetsRoot -ChildPath "document_test2.md"
            $Document = Add-DifyDocument -Knowledge $TestKnowledge2 -Path $TestFile -ChunkMode "custom" -IndexMode "economy"

            @($Document).Count | Should -Be 1
            $Document.Name | Should -Be "document_test2.md"
        }
    }
}
