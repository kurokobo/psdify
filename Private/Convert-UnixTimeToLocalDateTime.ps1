function Convert-UnixTimeToLocalDateTime {
    [CmdletBinding()]
    param (
        [Int64] $UnixTime
    )
    if (-not $UnixTime) {
        return $null
    }
    return ([datetimeoffset]::FromUnixTimeSeconds($UnixTime)).LocalDateTime
}
