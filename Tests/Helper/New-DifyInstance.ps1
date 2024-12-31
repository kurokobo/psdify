function New-DifyInstance {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Path,

        [String] $Version,
        [String] $EnvFile,
        [String] $OverrideFile
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

    git clone --depth=1 -b $Version https://github.com/langgenius/dify.git $Path

    Set-Location -Path $DockerPath
    Copy-Item -Path ".env.example" -Destination ".env" -Force
    if ($EnvFile) {
        Get-Content $EnvFile | Add-Content -Path ".env"
    }
    docker compose up -d
    Set-Location -Path $CurrentLocation

    Wait-Dify -Server "http://host.docker.internal/"
}
