# define global variables for paths
$ModuleRoot = Split-Path -Path $PSScriptRoot
$TestsRoot = Join-Path -Path $ModuleRoot -ChildPath "Tests"

# load .env.ps1 if exists
$EnvPath = Join-Path -Path $TestsRoot -ChildPath ".env.ps1"
if (Test-Path -Path $EnvPath) {
    . $EnvPath
}

# configure test mode
if (-not $env:PSDIFY_TEST_MODE) {
    $env:PSDIFY_TEST_MODE = "community"
}
if (@("community", "cloud") -notcontains $env:PSDIFY_TEST_MODE) {
    throw "PSDIFY_TEST_MODE must be either community or cloud"
}
if ($env:PSDIFY_TEST_MODE -eq "community") {
    $IsCommunity = $true
    $IsCloud = $false
}
else {
    $IsCommunity = $false
    $IsCloud = $true
}
