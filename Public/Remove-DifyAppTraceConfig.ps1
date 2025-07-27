function Remove-DifyAppTraceConfig {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject] $App = $null,
        [String] $Provider = ""
    )

    end {
        $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/apps", $App.Id, "/trace-config")
        $Method = "DELETE"
        $Query = @{
            "tracing_provider" = $Provider
        }
        if ($PSCmdlet.ShouldProcess("$($Provider)", "Remove Trace Config")) {
            try {
                $null = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Query $Query -Token $env:PSDIFY_CONSOLE_TOKEN
            }
            catch {
                throw "Failed to remove app trace config: $_"
            }
        }

        $Trace = Get-DifyAppTrace -App $App
        if ($Trace -and $Trace.Enabled -and $Trace.TracingProvider -eq $Provider) {
            try {
                $null = Set-DifyAppTrace -App $App -Provider $Provider -Disable
            }
            catch {
                throw "Failed to disable app trace: $_"
            }
        }

        return
    }
}
