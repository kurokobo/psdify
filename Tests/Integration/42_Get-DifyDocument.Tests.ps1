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

Describe "Connection" -Tag "document" {
    It "should connect correct server" {
        $env:PSDIFY_URL | Should -Be $DefaultServer
    }
}

Describe "Get-DifyDoument" -Tag "document" { 
    BeforeAll {
        Get-DifyKnowledge | Remove-DifyKnowledge -Confirm:$false

        if ($env:PSDIFY_PLUGIN_SUPPORT) {
            if (-not (Get-DifyPlugin -Id "langgenius/openai")) {
                Find-DifyPlugin -Id "langgenius/openai" | Install-DifyPlugin -Wait
            }
        }

        $null = New-DifyModel -Provider "openai" -From "predefined" -Credential @{
            "openai_api_key" = $env:PSDIFY_TEST_OPENAI_KEY
        }
        $null = Set-DifySystemModel -Type "text-embedding" -Provider "openai" -Name "text-embedding-3-small"

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
                (Join-Path -Path $env:PSDIFY_TEST_ROOT_ASSETS -ChildPath "document_test1.md"),
                (Join-Path -Path $env:PSDIFY_TEST_ROOT_ASSETS -ChildPath "document_test2.md")
            )
            $Documents = Add-DifyDocument -Knowledge $TestKnowledge1 -Path $TestFiles

            @($Documents).Count | Should -Be 2
            $Documents[0].Batch | Should -Not -BeNullOrEmpty
        }

        It "should add new documents and wait for indexing" {
            $TestFile = Join-Path -Path $env:PSDIFY_TEST_ROOT_ASSETS -ChildPath "document_test3.md"
            $Document = Add-DifyDocument -Knowledge $TestKnowledge1 -Path $TestFile -Wait

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
            $TestFile = Join-Path -Path $env:PSDIFY_TEST_ROOT_ASSETS -ChildPath "document_test1.md"
            $Document = Add-DifyDocument -Knowledge $TestKnowledge2 -Path $TestFile

            @($Document).Count | Should -Be 1
            $Document.Name | Should -Be "document_test1.md"
        }

        It "should add new documents with custom mode" {
            $TestFile = Join-Path -Path $env:PSDIFY_TEST_ROOT_ASSETS -ChildPath "document_test2.md"
            $Document = Add-DifyDocument -Knowledge $TestKnowledge2 -Path $TestFile -ChunkMode "custom"

            @($Document).Count | Should -Be 1
            $Document.Name | Should -Be "document_test2.md"
        }
    }
}
