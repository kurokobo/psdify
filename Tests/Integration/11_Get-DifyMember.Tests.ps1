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

Describe "Connection" -Tag "member" {
    It "should connect correct server" {
        $env:PSDIFY_URL | Should -Be $DefaultServer
    }
}

Describe "Get-DifyMember" -Tag "member" -Skip:($env:PSDIFY_TEST_MODE -ne "community") {
    BeforeAll {
        Get-DifyMember | Where-Object { $_.Email -ne $DefaultEmail } | Remove-DifyMember -Confirm:$false
    }
    Context "Manage members" {
        It "should get only owner" {
            $Members = Get-DifyMember

            @($Members).Count | Should -Be 1
            $Members.Name | Should -Be "Dify"
            $Members.Email | Should -Be $DefaultEmail
            $Members.Role | Should -Be "owner"
            $Members.Status | Should -Be "active"
        }

        It "should invite members" {
            $NewMembersInfo = @(
                @{
                    Email = "editor1@example.com"
                    Role  = "editor"
                },
                @{
                    Email = "editor2@example.com"
                    Role  = "editor"
                },
                @{
                    Email = "normal1@example.com"
                    Role  = "normal"
                },
                @{
                    Email = "normal2@example.com"
                    Role  = "normal"
                }
            )
            foreach ($NewMemberInfo in $NewMembersInfo) {
                $Member = New-DifyMember -Email $NewMemberInfo.Email -Role $NewMemberInfo.Role

                $Member.Name | Should -Be ($NewMemberInfo.Email -split "@")[0]
                $Member.Email | Should -Be $NewMemberInfo.Email
                $Member.Role | Should -Be $NewMemberInfo.Role
                $Member.InvitationLink | Should -BeLike "*/activate*"
            }
        }

        It "should get all members" {
            $Members = Get-DifyMember

            @($Members).Count | Should -Be 5
        }

        It "should get members by name" {
            $Members = Get-DifyMember -Name "editor1", "editor2"

            @($Members).Count | Should -Be 2
        }

        It "should get members by email" {
            $Members = Get-DifyMember -Email "normal1@example.com", "normal2@example.com"

            @($Members).Count | Should -Be 2
        }

        It "should set member role" {
            $Member = Get-DifyMember -Email "normal1@example.com"
            $UpdatedMember = $Member | Set-DifyMemberRole -Role "admin"

            @($UpdatedMember).Count | Should -Be 1
            $Member.Email | Should -Be "normal1@example.com"
            $UpdatedMember.Role | Should -Be "admin"
        }

        It "should remove members" {
            Get-DifyMember -Email "normal1@example.com" | Remove-DifyMember -Confirm:$false
            $Members = Get-DifyMember

            @($Members).Count | Should -Be 4
        }

        It "should remove all members" {
            Get-DifyMember | Where-Object { $_.Email -ne $DefaultEmail } | Remove-DifyMember -Confirm:$false
            $Members = Get-DifyMember

            @($Members).Count | Should -Be 1
        }
    }
}
