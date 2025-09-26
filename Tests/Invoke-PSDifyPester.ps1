param (
    [String[]] $Env = @(),
    [Int[]] $Ps = @(),
    [String[]] $Tag = @()
)

# load environment variables
. (Join-Path -Path (Split-Path -Path $PSScriptRoot) -ChildPath "Tests/.env.ps1")

# define test environments
$Environments = @(
    @{
        Id        = "cloud-prod"
        Mode      = "cloud"
        Server    = $env:PSDIFY_TEST_CLOUD_PROD_SERVER
        ApiServer = $env:PSDIFY_TEST_CLOUD_PROD_API_SERVER
        Email     = $env:PSDIFY_TEST_CLOUD_PROD_EMAIL
    },
    @{
        Id      = "community-legacy"
        Mode    = "community"
        Version = "0.15.5"
    },
    @{
        Id       = "community-release"
        Mode     = "community"
        Version  = "1.9.0"
        Override = "compose_release.yaml"
        Env      = "env_release.env"
    },
    @{
        Id       = "community-main"
        Mode     = "community"
        Version  = "main"
        Override = "compose_main.yaml"
        Env      = "env_main.env"
    }
)

# define powershell executables
$Executables = @(
    @{
        Version    = 5
        Executable = "powershell.exe"
    }
    @{
        Version    = 7
        Executable = "pwsh.exe"
    }
)

# define available tags in tests
$AvailableTags = @("init", "auth", "member", "plugin", "model", "systemmodel", "knowledge", "document", "app", "trace", "chat")

# apply filters
if ($Env) {
    if ($Env | Where-Object { $Environments.Id -notcontains $_ }) {
        throw "Invalid environment ids: $($Env -join ', ')"
    }
    $Environments = $Environments | Where-Object { $Env -contains $_.Id }
}
if ($Ps) {
    if ($Ps | Where-Object { $Executables.Version -notcontains $_ }) {
        throw "Invalid powershell versions: $($Ps -join ', ')"
    }
    $Executables = $Executables | Where-Object { $Ps -contains $_.Version }
}
if ($Tag) {
    if ($Tag | Where-Object { $AvailableTags -notcontains $_ }) {
        throw "Invalid tags: $($Tag -join ', ')"
    }
    $JoinedTags = $Tag -join ", "
}

# list test patters
Write-Host "Test patterns:" -ForegroundColor Green
foreach ($Environment in $Environments) {
    foreach ($Executable in $Executables) {
        if ($Tag) {
            $TagString = $JoinedTags
        }
        else {
            $TagString = "all tags"
        }
        Write-Host " - $($Environment.Id) on v$($Executable.Version) ($($TagString))" -ForegroundColor Cyan
    }
}

# invoke tests
foreach ($Environment in $Environments) {
    try {
        $env:PSDIFY_TEST_OVERRIDE_MODE = $Environment.Mode
        $env:PSDIFY_TEST_OVERRIDE_VERSION = $Environment.Version
        $env:PSDIFY_TEST_OVERRIDE_SERVER = $Environment.Server
        $env:PSDIFY_TEST_OVERRIDE_API_SERVER = $Environment.ApiServer
        $env:PSDIFY_TEST_OVERRIDE_EMAIL = $Environment.Email
        if ($Environment.Override) {
            $env:PSDIFY_TEST_OVERRIDE_OVERRIDE_FILE = $Environment.Override
        }
        else {
            $env:PSDIFY_TEST_OVERRIDE_OVERRIDE_FILE = "none"
        }
        if ($Environment.Env) {
            $env:PSDIFY_TEST_OVERRIDE_ENV_FILE = $Environment.Env
        }
        else {
            $env:PSDIFY_TEST_OVERRIDE_ENV_FILE = "none"
        }
        foreach ($Executable in $Executables) {
            & $Executable.Executable -NoProfile -ExecutionPolicy Bypass -Command {
                param(
                    [String] $Tag = ""
                )
                $Tags = $Tag -split "," | ForEach-Object { $_.Trim() }
                Invoke-Pester -Output Detailed -Tag $Tags
            } -args $JoinedTags
        }
    }
    finally {
        $env:PSDIFY_TEST_OVERRIDE_MODE = $null
        $env:PSDIFY_TEST_OVERRIDE_VERSION = $null
        $env:PSDIFY_TEST_OVERRIDE_SERVER = $null
        $env:PSDIFY_TEST_OVERRIDE_API_SERVER = $null
        $env:PSDIFY_TEST_OVERRIDE_EMAIL = $null
        $env:PSDIFY_TEST_OVERRIDE_ENV_FILE = $null
    }
}
