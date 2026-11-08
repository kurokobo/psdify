function Enable-DifyRateLimitRetry {
    param (
        [Int] $MaxRetry = 3,
        [Int] $WaitSeconds = 65
    )

    # Dify Cloud limits knowledge base requests per minute depending on the subscription plan.
    # Wrap Invoke-DifyRestMethod in the module scope to wait and retry when the request is rejected by the rate limit.
    $Module = Get-Module -Name PSDify | Select-Object -First 1
    & $Module {
        param ($MaxRetry, $WaitSeconds)

        $script:PSDIFY_TEST_RATE_LIMIT_RETRY = @{
            MaxRetry    = $MaxRetry
            WaitSeconds = $WaitSeconds
        }
        if (${function:Invoke-DifyRestMethodWithoutRetry}) {
            return
        }

        $Original = ${function:Invoke-DifyRestMethod}
        ${function:script:Invoke-DifyRestMethodWithoutRetry} = $Original
        $ParamBlock = $Original.Ast.Body.ParamBlock.Extent.Text
        if (-not $ParamBlock) {
            throw "Failed to get the parameters of Invoke-DifyRestMethod"
        }
        Invoke-Expression @"
function script:Invoke-DifyRestMethod {
    $ParamBlock

    `$Retry = `$script:PSDIFY_TEST_RATE_LIMIT_RETRY
    for (`$Attempt = 1; ; `$Attempt++) {
        # Invoke-DifyRestMethod removes the file passed by InFile, so keep a copy for retrying
        `$BackupFile = `$null
        if (`$InFile) {
            `$BackupFile = "`$(`$InFile).retry"
            Copy-Item -Path `$InFile -Destination `$BackupFile -Force
        }
        try {
            return Invoke-DifyRestMethodWithoutRetry @PSBoundParameters
        }
        catch {
            if (`$Attempt -gt `$Retry.MaxRetry -or "`$_" -notmatch "request rate limit") {
                throw
            }
            Write-Host "Rate limit exceeded, retrying in `$(`$Retry.WaitSeconds) seconds (`$(`$Attempt)/`$(`$Retry.MaxRetry)): `$Method `$Uri" -ForegroundColor Yellow
            Start-Sleep -Seconds `$Retry.WaitSeconds
            if (`$BackupFile) {
                Move-Item -Path `$BackupFile -Destination `$InFile -Force
                `$BackupFile = `$null
            }
        }
        finally {
            if (`$BackupFile) {
                Remove-Item -Path `$BackupFile -Force -ErrorAction SilentlyContinue
            }
        }
    }
}
"@
    } $MaxRetry $WaitSeconds
}
