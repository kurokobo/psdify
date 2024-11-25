function Convert-UnixTimeToLocalDateTime {
    [CmdletBinding()]
    param (
        [Int64] $UnixTime
    )
    return ([datetimeoffset]::FromUnixTimeSeconds($UnixTime)).LocalDateTime
}
