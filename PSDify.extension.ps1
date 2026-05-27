$ExtensionFiles = @(
    "Extension/background.js",
    "Extension/manifest.json",
    "Extension/options.html",
    "Extension/options.js",
    "Extension/icons/icon16.png",
    "Extension/icons/icon32.png",
    "Extension/icons/icon48.png",
    "Extension/icons/icon128.png"
)

# Remove existing ZIP and create a new working directory
$WorkingDirectory = "Dist/Extension"
$ZipPath = "Dist/PSDify.extension.zip"

if (Test-Path "Dist") {
    Remove-Item -Path "Dist" -Recurse -Force
}
$null = New-Item -Path "$WorkingDirectory/icons" -ItemType Directory -Force

# Copy extension files to the working directory
foreach ($File in $ExtensionFiles) {
    $Destination = Join-Path $WorkingDirectory ($File -replace "^Extension/", "")
    Copy-Item -Path $File -Destination $Destination
}

# Create ZIP archive
Compress-Archive -Path "$WorkingDirectory/*" -DestinationPath $ZipPath
Write-Host "Created: $ZipPath"
