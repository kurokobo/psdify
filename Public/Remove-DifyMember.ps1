function Remove-DifyMember {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject[]] $Member = @()
    )

    begin {
        $Members = @()
    }

    process {
        foreach ($MemberObject in $Member) {
            $Members += $MemberObject
        }
    }

    end {
        foreach ($Member in $Members) {
            $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current/members", $Member.Id)
            $Method = "DELETE"
            if ($PSCmdlet.ShouldProcess("$($Member.Name) ($($Member.Email) / $($Member.Id))", "Remove Member")) {
                try {
                    $null = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
                }
                catch {
                    throw "Failed to remove member: $_"
                }
            }
        }

        return
    }
}
