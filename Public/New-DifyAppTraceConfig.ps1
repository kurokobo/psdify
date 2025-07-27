function New-DifyAppTraceConfig {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject] $App = $null,
        [String] $Provider = "",
        [Hashtable] $Config = $null,
        [Switch] $Enable = $false
    )

    end {
        Invoke-DifyAppTraceConfig -App $App -Provider $Provider -Config $Config -Method "POST"

        if ($Enable) {
            try { $null = Set-DifyAppTrace -App $App -Provider $Provider -Enable }
            catch { throw "Failed to enable app trace: $_" }
        }

        return Get-DifyAppTraceConfig -App $App -Provider $Provider
    }
}
