function Set-PSDifyConfiguration {
    [CmdletBinding()]
    param (
        [Boolean] $IgnoreSSLVerification = $false 
    )

    switch ($IgnoreSSLVerification) {
        $true {
            $env:PSDIFY_DISABLE_SSL_VERIFICATION = "true"
            Write-Host -ForegroundColor Yellow "[PSDify] SSL verification is disabled"
        }
        $false {
            $env:PSDIFY_DISABLE_SSL_VERIFICATION = $null
            Write-Host -ForegroundColor Green "[PSDify] SSL verification is enabled"
        }
    }
}
