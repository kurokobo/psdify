function New-DifyInstance {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Path,

        [String] $Version,
        [String] $EnvFile
    )

    if ($env:PSDIFY_TEST_MODE -eq "cloud") {
        return
    }

    $CurrentLocation = Get-Location
    $FullPath = [System.IO.Path]::GetFullPath($Path)
    if (-not $FullPath.StartsWith($CurrentLocation)) {
        throw "Specified path is not a child of the current location"
    }
    $DockerPath = Join-Path -Path $Path -ChildPath "docker"

    Write-Host "Cloning Dify repository to $($Path)." -ForegroundColor Magenta
    git clone --quiet --depth=1 -b $Version https://github.com/langgenius/dify.git $Path

    if ($env:PSDIFY_TEST_OVERRIDE_FILE -and $env:PSDIFY_TEST_OVERRIDE_FILE -ne "none") {
        Copy-Item (Join-Path -Path $env:PSDIFY_TEST_ROOT_ASSETS -ChildPath $env:PSDIFY_TEST_OVERRIDE_FILE) -Destination (Join-Path -Path $DockerPath -ChildPath "docker-compose.override.yaml") -Force
    }

    Set-Location -Path $DockerPath
    Copy-Item -Path ".env.example" -Destination ".env" -Force
    if ($EnvFile) {
        Get-Content $EnvFile | Add-Content -Path ".env"
    }
    if ($env:PSDIFY_TEST_ENV_FILE -and $env:PSDIFY_TEST_ENV_FILE -ne "none") {
        Get-Content (Join-Path -Path $env:PSDIFY_TEST_ROOT_ASSETS -ChildPath $env:PSDIFY_TEST_ENV_FILE) | Add-Content -Path ".env"
    }
    Write-Host "Pulling container images." -ForegroundColor Magenta
    docker compose pull
    Write-Host "Starting Dify instance." -ForegroundColor Magenta
    docker compose up -d
    Set-Location -Path $CurrentLocation

    Write-Host "Waiting Dify instance to be started." -ForegroundColor Magenta
    Wait-Dify -Server "http://host.docker.internal/"
}
