# define global variables for paths
$ModuleRoot = Split-Path -Path $PSScriptRoot
$TestsRoot = Join-Path -Path $ModuleRoot -ChildPath "Tests"
$HelperRoot = Join-Path -Path $TestsRoot -ChildPath "Helper"
$AssetsRoot = Join-Path -Path $TestsRoot -ChildPath "Assets"
$DifyRoot = Join-Path -Path $AssetsRoot -ChildPath "Dify"
$TempRoot = Join-Path -Path $TestsRoot -ChildPath "Temp"

# configure test mode
if ($env:PSDIFY_TEST_MODE -eq "community") {
    $IsCommunity = $true
    $IsCloud = $false
}
else {
    $IsCommunity = $false
    $IsCloud = $true
}

# check if the required environment variables are set
if ($IsCommunity -and -not $env:PSDIFY_TEST_VERSION) {
    throw "PSDIFY_TEST_VERSION is required for community mode"
}
if (-not $env:PSDIFY_TEST_OPENAI_KEY) {
    throw "PSDIFY_TEST_OPENAI_KEY is required"
}
if ($IsCloud -and -not $env:PSDIFY_TEST_EMAIL) {
    throw "PSDIFY_TEST_EMAIL is required for cloud mode"
}

# define global variables for configuration
if ($IsCommunity) {
    $DefaultServer = "http://host.docker.internal/"
    $DefaultAPIServer = "http://host.docker.internal/"
    $DefaultAuthMethod = "Password"
    $DefaultEmail = "dify@example.com"
    $DefaultName = "Dify"
    $DefaultPlainPassword = "difyai123456"
    $DefaultPassword = $DefaultPlainPassword | ConvertTo-SecureString -AsPlainText -Force
    $DefaultPlainInitPassword = "difyai123456"
    $DefaultInitPassword = $DefaultPlainInitPassword | ConvertTo-SecureString -AsPlainText -Force
}
else {
    $DefaultServer = "https://cloud.dify.ai/"
    $DefaultAPIServer = "https://api.dify.ai/"
    $DefaultAuthMethod = "Code"
    $DefaultEmail = $env:PSDIFY_TEST_EMAIL
}
if (@("main") -contains $env:PSDIFY_TEST_VERSION) {
    $InvokeVersionTests = $true
}
else {
    $InvokeVersionTests = $false
}

# import modules and helper scripts
Get-Module -Name PSDify -ListAvailable | Uninstall-Module -Force -Confirm:$false
Import-Module (Join-Path -Path $ModuleRoot -ChildPath "PSDify.psd1") -Force
Get-ChildItem -Path (Join-Path -Path $ModuleRoot -ChildPath "Private") -Filter "*.ps1" | ForEach-Object {
    . $_.FullName
}
Get-ChildItem -Path $HelperRoot -Filter "*.ps1" | ForEach-Object {
    . $_.FullName
}

# message for the test mode
Write-Host "Running tests for:" -ForegroundColor Green
Write-Host " Mode   : $env:PSDIFY_TEST_MODE" -ForegroundColor Cyan
Write-Host " Server : $DefaultServer" -ForegroundColor Cyan
if ($IsCommunity) {
    Write-Host " Version: $env:PSDIFY_TEST_VERSION" -ForegroundColor Cyan
}
