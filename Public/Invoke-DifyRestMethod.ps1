function Invoke-DifyRestMethod {
    [CmdletBinding()]
    param (
        [String] $Uri,
        [String] $Method = "GET",
        [String] $ContentType = "application/json",
        [Object] $Body = $null,
        [Hashtable] $Query = $null,
        [String] $Token = $null,
        [Microsoft.PowerShell.Commands.WebRequestSession] $Session = $null
    )

    $Headers = @{}
    if ($Token) {
        $Headers = @{
            "authorization" = "Bearer $Token"
        }
    }
    if ($Query) {
        $Uri = $Uri + "?" + (($Query.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "&")
    }

    try {
        Write-Verbose "request: $Method $Uri"
        if (@("POST", "PUT", "PATCH") -notcontains $Method) {
            if ($Session) {
                return Invoke-RestMethod -Uri "$Uri" -Method $Method -ContentType $ContentType -Headers $Headers -WebSession $Session -ErrorAction Stop
            }
            else {
                return Invoke-RestMethod -Uri "$Uri" -Method $Method -ContentType $ContentType -Headers $Headers -ErrorAction Stop
            }
        }
        else {
            if ($Session) {
                return Invoke-RestMethod -Uri "$Uri" -Method $Method -ContentType $ContentType -Headers $Headers -Body $Body -WebSession $Session -ErrorAction Stop
            }
            else {
                return Invoke-RestMethod -Uri "$Uri" -Method $Method -ContentType $ContentType -Headers $Headers -Body $Body -ErrorAction Stop
            }
        }

    }
    catch {
        if ($PSVersionTable.PSVersion.Major -lt 6) {
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
        else {
            throw $_.ErrorDetails.Message
        }
    }
}
