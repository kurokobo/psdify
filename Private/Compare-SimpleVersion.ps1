function Compare-SimpleVersion {
    param(
        [Parameter(Mandatory)]
        [string] $Version,
        [string] $Eq,
        [string] $Gt,
        [string] $Lt,
        [string] $Ge,
        [string] $Le
    )
    $Params = @($Eq, $Gt, $Lt, $Ge, $Le)
    $Specified = $Params | Where-Object { $_ }
    if ($Specified.Count -ne 1) {
        throw "Specify exactly one of -Eq, -Gt, -Lt, -Ge, -Le."
    }
    $Version = $Version -replace '[+-].*$', ''
    $CompareTo = $Specified -replace '[+-].*$', ''
    try {
        $VersionObjA = [Version]$Version
        $VersionObjB = [Version]$CompareTo
    }
    catch {
        throw "Invalid version format: $Version or $CompareTo"
    }
    if ($Eq) { return $VersionObjA -eq $VersionObjB }
    elseif ($Gt) { return $VersionObjA -gt $VersionObjB }
    elseif ($Lt) { return $VersionObjA -lt $VersionObjB }
    elseif ($Ge) { return $VersionObjA -ge $VersionObjB }
    elseif ($Le) { return $VersionObjA -le $VersionObjB }
}
