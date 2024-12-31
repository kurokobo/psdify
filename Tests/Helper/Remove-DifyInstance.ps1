function Remove-DifyInstance {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Path
    )

    if ($env:PSDIFY_TEST_MODE -ne "cloud") {
        $CurrentLocation = Get-Location
        $FullPath = [System.IO.Path]::GetFullPath($Path)
        if (-not $FullPath.StartsWith($CurrentLocation)) {
            throw "Specified path is not a child of the current location"
        }
        $DockerPath = Join-Path -Path $Path -ChildPath "docker"

        if ((Test-Path $DockerPath) -and (Test-Path (Join-Path -Path $DockerPath -ChildPath "docker-compose.yaml"))) {
            Set-Location -Path $DockerPath
            docker compose kill
            docker compose down -v
            Set-Location -Path $CurrentLocation
        }

        if (Test-Path $Path) {
            Remove-Item $Path -Recurse -Force
        }
    }

    $env:PSDIFY_URL = ""
    $env:PSDIFY_CONSOLE_TOKEN = ""
    $env:PSDIFY_CONSOLE_REFRESH_TOKEN = ""
    $env:PSDIFY_VERSION = ""

    $env:PSDIFY_AUTH_METHOD = ""
    $env:PSDIFY_EMAIL = ""
    $env:PSDIFY_INIT_PASSWORD = ""
    $env:PSDIFY_PASSWORD = ""
}
