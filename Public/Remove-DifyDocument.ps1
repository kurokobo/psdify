function Remove-DifyDocument {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject[]] $Document = @()
    )

    begin {
        $Documents = @()
    }

    process {
        foreach ($DocumentObject in $Document) {
            $Documents += $DocumentObject
        }
    }

    end {
        foreach ($Document in $Documents) {
            $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/datasets", $Document.KnowledgeId, "documents", $Document.Id)
            $Method = "DELETE"
            if ($PSCmdlet.ShouldProcess("$($Document.Name) ($($Document.Id))", "Remove Document")) {
                try {
                    $null = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
                }
                catch {
                    throw "Failed to remove document: $_"
                }
            }
        }

        return
    }
}
