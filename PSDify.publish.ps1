$PublishDirectories = @(
    "Private",
    "Public",
    "LICENSE",
    "PSDify.psd1",
    "PSDify.psm1"
)

# Remove existing files and directories, and create a new working directory
$WorkingDirectory = "Dist"
if (Test-Path $WorkingDirectory) {
    Remove-Item -Path $WorkingDirectory -Recurse -Force
}
$null = New-Item -Path $WorkingDirectory -ItemType Directory

# Copy files and directories to the working directory
foreach ($PublishDirectory in $PublishDirectories) {
    Copy-Item -Path $PublishDirectory -Destination $WorkingDirectory -Recurse
}

# Invoke PSScriptAnalyzer
Invoke-ScriptAnalyzer -Path $WorkingDirectory -Settings PSGallery -Recurse

# Publish the module to the PowerShell Gallery
Set-Location $WorkingDirectory
Publish-PSResource -Path ./ -Repository PSGallery -ApiKey $env:PSDIFY_PSGALLERY_APIKEY -Verbose
