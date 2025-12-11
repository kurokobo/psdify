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

Describe "Connection" -Tag "workspace" -Skip:($env:PSDIFY_TEST_MODE -ne "community") {
    It "should connect correct server" {
        $env:PSDIFY_URL | Should -Be $DefaultServer
    }
}

Describe "Get-DifyWorkspace" -Tag "workspace" -Skip:($env:PSDIFY_TEST_MODE -ne "community") {
    BeforeAll {
        # WARNING: The following procedure may violate license terms if misused.
        #          They are used here for automated testing purposes only.
        $RandomEmail = "user-$([System.Guid]::NewGuid().ToString('N').Substring(0,8))@example.com"
        $CreatedTenant = docker exec -i docker-api-1 flask create-tenant --email $RandomEmail --name $($RandomEmail -split '@')[0] --language en-US
        $CreatedPlainPassword = $CreatedTenant | Select-String -Pattern "Password: (.+)" | ForEach-Object { $_.Matches[0].Groups[1].Value }
        $CreatedPassword = $CreatedPlainPassword | ConvertTo-SecureString -AsPlainText -Force

        # Invite new account to default workspace
        $null = New-DifyMember -Email $RandomEmail -Role "normal"

        # Connect as the new account
        Disconnect-Dify -Force
        Connect-Dify -Server $DefaultServer -Email $RandomEmail -Password $CreatedPassword
    }
    Context "Manage workspaces" {
        It "should get multiple workspaces" {
            $Workspaces = Get-DifyWorkspace

            @($Workspaces).Count | Should -BeGreaterThan 1
        }

        It "should get current workspace" {
            $SwitchedWorkspace = Set-DifyCurrentWorkspace -Name "Dify's Workspace"
            $CurrentWorkspace = Get-DifyCurrentWorkspace

            $CurrentWorkspace | Should -Not -BeNullOrEmpty
            $CurrentWorkspace.Name | Should -Be "Dify's Workspace"
        }

        It "should switch current workspace" {
            $Workspaces = Get-DifyWorkspace
            $TargetWorkspace = $Workspaces | Where-Object { $_.Current -eq $false } | Select-Object -First 1
            $SwitchedWorkspace = Set-DifyCurrentWorkspace -Id $TargetWorkspace.Id
            $CurrentWorkspace = Get-DifyCurrentWorkspace

            $SwitchedWorkspace | Should -Not -BeNullOrEmpty
            $SwitchedWorkspace.Name | Should -Be $TargetWorkspace.Name

            $CurrentWorkspace | Should -Not -BeNullOrEmpty
            $CurrentWorkspace.Name | Should -Be $TargetWorkspace.Name
            $CurrentWorkspace.Name | Should -Match "^user-[a-z0-9]{8}$"
        }
    }

    AfterAll {
        # Reconnect as the default account
        Disconnect-Dify -Force
        Connect-Dify -Server $DefaultServer -Email $DefaultEmail -Password $DefaultPassword
    }
}
