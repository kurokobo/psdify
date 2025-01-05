function New-DifyInstanceWithPluginSupport {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Path,

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

    Write-Host "Cloning Dify repository to $Path." -ForegroundColor Magenta
    git clone --quiet --depth=1 -b $env:PLUGIN_BRANCH https://github.com/langgenius/dify.git $Path

    Copy-Item (Join-Path -Path $AssetsRoot -ChildPath "compose_plugin.yaml") -Destination (Join-Path -Path $DockerPath -ChildPath "docker-compose.override.yaml") -Force

    Set-Location -Path $DockerPath
    $NginxTemplatePath = "nginx/conf.d/default.conf.template"
    $InsertContent = "location /e { proxy_pass http://plugin:80; include proxy.conf; }"
    (Get-Content $NginxTemplatePath) -replace '    location / {', "$($InsertContent)`n    location / {" | Set-Content $NginxTemplatePath
    Copy-Item -Path ".env.example" -Destination ".env" -Force
    if ($EnvFile) {
        Get-Content $EnvFile | Add-Content -Path ".env"
    }
    $null = New-Item -ItemType Directory -Path "volumes/plugin/storage/plugin" -ErrorAction SilentlyContinue
    $null = New-Item -ItemType Directory -Path "volumes/plugin/storage/persistence" -ErrorAction SilentlyContinue
    Write-Host "Pulling container images." -ForegroundColor Magenta
    docker compose pull
    Write-Host "Starting Dify instance." -ForegroundColor Magenta
    docker compose up -d

    Write-Host "Waiting Dify instance to be started." -ForegroundColor Magenta
    Wait-Dify -Server "http://host.docker.internal/"

    Write-Host "Creating required table on database and inserting values." -ForegroundColor Magenta
    $SQL = "CREATE TABLE staging_account_whitelists (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), email VARCHAR(255) NOT NULL, disabled BOOLEAN NOT NULL DEFAULT FALSE, created_at TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0), updated_at TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0)); INSERT INTO staging_account_whitelists (id, email, disabled, created_at, updated_at) VALUES (uuid_generate_v4(), 'dify@example.com', FALSE, CURRENT_TIMESTAMP(0), CURRENT_TIMESTAMP(0));"
    docker compose exec -t db psql -U postgres -d dify -c "$($SQL)"
    Set-Location -Path $CurrentLocation
}
