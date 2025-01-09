function Start-DifyInstance {
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

    # check if the instance is already running
    try {
        Write-Host "Gathering the version of the running instance." -ForegroundColor Magenta
        $IsRunning = (Get-DifyVersion -Server "http://host.docker.internal/").Version
    }
    catch {
        $IsRunning = $null
    }

    # gather the current version by reading the docker image label
    if ($IsRunning) {
        try {
            Write-Host "Gathering the tag of the running container image." -ForegroundColor Magenta
            $CurrentVersion = (((docker inspect docker-api-1 | ConvertFrom-Json).Config.Image) -split ":")[1]
        }
        catch {
            $CurrentVersion = $null
        }
    }

    if ($IsRunning -and ($CurrentVersion -eq $Version)) {
        Write-Host "Skipping starting Dify instance since it is already running with the specified version." -ForegroundColor Magenta
        return
    }

    Write-Host "Removing existing instance and creating new instance." -ForegroundColor Magenta
    Remove-DifyInstance -Path $Path
    New-DifyInstance -Path $Path -Version $Version -EnvFile $EnvFile

    $Server = "http://host.docker.internal/"
    $Email = "dify@example.com"
    $Name = "Dify"
    $InitPassword = "difyai123456" | ConvertTo-SecureString -AsPlainText -Force
    $Password = "difyai123456" | ConvertTo-SecureString -AsPlainText -Force

    Write-Host "Initializing Dify instance." -ForegroundColor Magenta
    $null = Initialize-Dify -Server $Server -Email $Email -Name $Name -InitPassword $InitPassword -Password $Password
}
