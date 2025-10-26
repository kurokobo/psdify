function Invoke-DifyRestMethod {
    [CmdletBinding()]
    param (
        [String] $Uri,
        [String] $Method = "GET",
        [String] $ContentType = "application/json",
        [String] $Body = $null,
        [Hashtable] $Query = $null,
        [String] $Token = $null,
        [Microsoft.PowerShell.Commands.WebRequestSession] $Session = $null,
        [String] $InFile = $null,
        [Object] $SessionOrToken = $null
    )

    if ($Uri -notmatch "^https?://") {
        throw "No Uri provided. Ensure you have connected to Dify by running Connect-Dify first."
    }

    $RestMethodParams = @{
        Method      = $Method
        Headers     = @{}
        ContentType = $ContentType
        ErrorAction = 'Stop'
    }

    if ($Token) {
        $SessionOrToken = $Token
    }
    if ($Session) {
        $SessionOrToken = $Session
    }
    if ($SessionOrToken) {
        if ($SessionOrToken -is [Microsoft.PowerShell.Commands.WebRequestSession]) {
            $Server = ($Uri -split "/")[0..2] -join "/"
            $CSRFToken = ($SessionOrToken.Cookies.GetCookies($Server) | Where-Object { $_.Name -in @("csrf_token", "__Host-csrf_token") } | Select-Object -First 1).Value
            if ($CSRFToken) {
                $RestMethodParams.Headers["x-csrf-token"] = $CSRFToken
            }
            $RestMethodParams.WebSession = $SessionOrToken
        }
        elseif ($SessionOrToken -is [String]) {
            $RestMethodParams.Headers["authorization"] = "Bearer $SessionOrToken"
        }
    }
    if ($Query) {
        $Uri = $Uri + "?" + (($Query.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "&")
    }
    $RestMethodParams.Uri = $Uri

    if (@("POST", "PUT", "PATCH", "DELETE") -contains $Method) {
        if ($Body) {
            $UTF8NoBOM = New-Object "System.Text.UTF8Encoding" -ArgumentList @($false)
            $RestMethodParams.Body = $UTF8NoBOM.GetBytes($Body)
        }
        if ($InFile) {
            $RestMethodParams.InFile = $InFile
        }
    }

    if ($env:PSDIFY_DISABLE_SSL_VERIFICATION -eq "true") {
        if ($PSVersionTable.PSVersion.Major -ge 6) {
            Write-Verbose "Disabling SSL certificate check for PowerShell 6 or higher"
            $RestMethodParams.SkipCertificateCheck = $true
        }
        else {
            Write-Verbose "Disabling SSL certificate check for PowerShell 5 or lower"
            $DefaultCertPolicy = [System.Net.ServicePointManager]::CertificatePolicy
            if (-not ([System.Management.Automation.PSTypeName]'PSDifyTrustAllCertsPolicy').Type) {
                Add-Type -TypeDefinition "using System.Net; using System.Security.Cryptography.X509Certificates; public class PSDifyTrustAllCertsPolicy : ICertificatePolicy { public bool CheckValidationResult(ServicePoint srvPoint, X509Certificate certificate, WebRequest request, int certificateProblem) { return true; } }"
            }
            [System.Net.ServicePointManager]::CertificatePolicy = New-Object -TypeName PSDifyTrustAllCertsPolicy
        }
    }

    try {
        Write-Verbose "request: $Method $Uri"
        return Invoke-RestMethod @RestMethodParams
    }
    catch {
        if ($PSVersionTable.PSVersion.Major -ge 6) {
            throw $_.ErrorDetails.Message
        }
        else {
            if ($_.Exception.Response) {
                $StreamReader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
                $StreamReader.BaseStream.Position = 0
                $StreamReader.DiscardBufferedData()
                $ErrorMessage = $StreamReader.ReadToEnd()
                throw $ErrorMessage
            }
            else {
                throw $_.Exception.Message
            }
        }
    }
    finally {
        if ($InFile) {
            Remove-Item $InFile -Force -ErrorAction SilentlyContinue
        }
        if ($env:PSDIFY_DISABLE_SSL_VERIFICATION -eq "true" -and $PSVersionTable.PSVersion.Major -le 5) {
            Write-Verbose "Enabling SSL certificate check for PowerShell 5 or lower"
            [System.Net.ServicePointManager]::CertificatePolicy = $DefaultCertPolicy
        }
    }
}
