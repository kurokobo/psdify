function Wait-Dify {
    [CmdletBinding()]
    param (
        [String] $Server,
        [Int] $Interval = 5,
        [Int] $Timeout = 300
    )

    # Validate parameter: Server
    if ($env:PSDIFY_URL) {
        $Server = $env:PSDIFY_URL
    }
    if (-not $Server) {
        throw "Server URL is required"
    }

    $Now = Get-Date
    $WaitUntil = $Now.AddSeconds($Timeout)
    while ($Now -lt $WaitUntil) {
        try {
            if (Get-DifyVersion -Server $Server) {
                return
            }
        }
        catch {
            Start-Sleep -Seconds $Interval
            $Now = Get-Date
        }
    }
    throw "Timeout exceeded while waiting for Dify to be ready"
}
