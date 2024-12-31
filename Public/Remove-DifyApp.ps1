function Remove-DifyApp {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject[]] $App = @()
    )

    begin {
        $Apps = @()
    }

    process {
        foreach ($AppObject in $App) {
            $Apps += $AppObject
        }
    }

    end {
        foreach ($App in $Apps) {
            $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/apps", $App.Id)
            $Method = "DELETE"
            if ($PSCmdlet.ShouldProcess("$($App.Name) ($($App.Id))", "Remove App")) {
                try {
                    $null = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Token $env:PSDIFY_CONSOLE_TOKEN
                }
                catch {
                    throw "Failed to remove app: $_"
                }
            }
        }

        return
    }
}
