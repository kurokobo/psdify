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
        [String] $InFile = $null
    )

    if ($Uri -notmatch "^https?://") {
        throw "No Uri provided. Ensure you have connected to Dify by running Connect-Dify first."
    }

    $Headers = @{}
    if ($Token) {
        $Headers = @{
            "authorization" = "Bearer $Token"
        }
    }
    if ($Query) {
        $Uri = $Uri + "?" + (($Query.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "&")
    }

    $RestMethodParams = @{
        Uri         = $Uri
        Method      = $Method
        ContentType = $ContentType
        Headers     = $Headers
        ErrorAction = 'Stop'
    }
    if ($Session) {
        $RestMethodParams.WebSession = $Session
    }
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
