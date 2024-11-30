function Remove-DifyKnowledge {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject[]] $Knowledge = @()
    )

    begin {
        $Knowledges = @()
    }

    process {
        foreach ($KnowledgeObject in $Knowledge) {
            $Knowledges += $KnowledgeObject
        }
    }

    end {
        foreach ($Knowledge in $Knowledges) {
            $Endpoint = "$($env:PSDIFY_URL)/console/api/datasets/$($Knowledge.Id)"
            $Method = "DELETE"
            if ($PSCmdlet.ShouldProcess("$($Knowledge.Name) ($($Knowledge.Id))", "Remove Knowledge")) {
                try {
                    $null = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Token $env:PSDIFY_CONSOLE_TOKEN
                }
                catch {
                    throw "Failed to remove knowledge: $_"
                }
            }
        }

        return
    }
}
