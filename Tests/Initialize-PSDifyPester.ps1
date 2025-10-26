# define variables for paths
$env:PSDIFY_TEST_ROOT_MODULE = Split-Path -Path $PSScriptRoot
$env:PSDIFY_TEST_ROOT_TESTS = Join-Path -Path $env:PSDIFY_TEST_ROOT_MODULE -ChildPath "Tests"
$env:PSDIFY_TEST_ROOT_HELPER = Join-Path -Path $env:PSDIFY_TEST_ROOT_TESTS -ChildPath "Helper"
$env:PSDIFY_TEST_ROOT_ASSETS = Join-Path -Path $env:PSDIFY_TEST_ROOT_TESTS -ChildPath "Assets"
$env:PSDIFY_TEST_ROOT_DIFY = Join-Path -Path $env:PSDIFY_TEST_ROOT_ASSETS -ChildPath "Dify"
$env:PSDIFY_TEST_ROOT_TEMP = Join-Path -Path $env:PSDIFY_TEST_ROOT_TESTS -ChildPath "Temp"

# load environment variables
. (Join-Path -Path $env:PSDIFY_TEST_ROOT_TESTS -ChildPath ".env.ps1")

# handle overrides
if ($env:PSDIFY_TEST_OVERRIDE_MODE) {
    $env:PSDIFY_TEST_MODE = $env:PSDIFY_TEST_OVERRIDE_MODE
}
if ($env:PSDIFY_TEST_OVERRIDE_VERSION) {
    $env:PSDIFY_TEST_VERSION = $env:PSDIFY_TEST_OVERRIDE_VERSION
}
if ($env:PSDIFY_TEST_OVERRIDE_OVERRIDE_FILE) {
    $env:PSDIFY_TEST_OVERRIDE_FILE = $env:PSDIFY_TEST_OVERRIDE_OVERRIDE_FILE
}
if ($env:PSDIFY_TEST_OVERRIDE_ENV_FILE) {
    $env:PSDIFY_TEST_ENV_FILE = $env:PSDIFY_TEST_OVERRIDE_ENV_FILE
}

# validate and configure test mode
switch ($env:PSDIFY_TEST_MODE) {
    "community" {
        if (-not $env:PSDIFY_TEST_VERSION) {
            throw "PSDIFY_TEST_VERSION is required for community mode"
        }
        if (@("main") -contains $env:PSDIFY_TEST_VERSION) {
            $env:PSDIFY_TEST_ALLOW_VERSION_TEST = $null
        }
        else {
            $env:PSDIFY_TEST_ALLOW_VERSION_TEST = "true"
        }
    }
    "cloud" {
        if (-not $env:PSDIFY_TEST_EMAIL -and -not $env:PSDIFY_TEST_OVERRIDE_EMAIL) {
            throw "PSDIFY_TEST_EMAIL is required for cloud mode"
        }
    }
    default {
        throw "PSDIFY_TEST_MODE must be either community or cloud"
    }
}
if (-not $env:PSDIFY_TEST_OPENAI_KEY) {
    throw "PSDIFY_TEST_OPENAI_KEY is required"
}

# exit if this script is called before discovery
if ($PesterPhase -eq "BeforeDiscovery") {
    return
}

# define variables for testing
if ($env:PSDIFY_TEST_MODE -eq "community") {
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

# handle overrides
if ($env:PSDIFY_TEST_OVERRIDE_SERVER) {
    $DefaultServer = $env:PSDIFY_TEST_OVERRIDE_SERVER
}
if ($env:PSDIFY_TEST_OVERRIDE_API_SERVER) {
    $DefaultAPIServer = $env:PSDIFY_TEST_OVERRIDE_API_SERVER
}
if ($env:PSDIFY_TEST_OVERRIDE_EMAIL) {
    $DefaultEmail = $env:PSDIFY_TEST_OVERRIDE_EMAIL
}

# import modules and helper scripts
Get-Module -Name PSDify -ListAvailable | Uninstall-Module -Force -Confirm:$false
Import-Module (Join-Path -Path $env:PSDIFY_TEST_ROOT_MODULE -ChildPath "PSDify.psd1") -Force
Get-ChildItem -Path (Join-Path -Path $env:PSDIFY_TEST_ROOT_MODULE -ChildPath "Private") -Filter "*.ps1" | ForEach-Object {
    . $_.FullName
}
Get-ChildItem -Path $env:PSDIFY_TEST_ROOT_HELPER -Filter "*.ps1" | ForEach-Object {
    . $_.FullName
}

# if the environment seems to be already connected to different server, disconnect
if ($env:PSDIFY_URL -and $script:PSDIFY_CONSOLE_AUTH -and ($env:PSDIFY_URL -ne $DefaultServer)) {
    Disconnect-Dify -Force
}

# show configuration for tests
Write-Host "Running tests for:" -ForegroundColor Green
Write-Host " PowerShell : $($PSVersionTable.PSVersion)" -ForegroundColor Cyan
Write-Host " Mode       : $env:PSDIFY_TEST_MODE" -ForegroundColor Cyan
Write-Host " Server     : $DefaultServer" -ForegroundColor Cyan
if ($env:PSDIFY_TEST_MODE -eq "community") {
    Write-Host " Version    : $env:PSDIFY_TEST_VERSION" -ForegroundColor Cyan
}
