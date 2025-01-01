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
        $IsRunning = (Get-DifyVersion -Server "http://host.docker.internal/").Version
    }
    catch {
        $IsRunning = $null
    }

    # gather the current version by reading the docker image label
    if ($IsRunning) {
        try {
            $CurrentVersion = (docker inspect docker-api-1 | ConvertFrom-Json).Config.Labels."org.opencontainers.image.version"
        }
        catch {
            $CurrentVersion = $null
        }
    }

    if ($IsRunning -and ($CurrentVersion -eq $Version)) {
        return
    }

    Remove-DifyInstance -Path $Path
    New-DifyInstance -Path $Path -Version $Version -EnvFile $EnvFile

    $Server = "http://host.docker.internal/"
    $Email = "dify@example.com"
    $Name = "Dify"
    $InitPassword = "difyai123456" | ConvertTo-SecureString -AsPlainText -Force
    $Password = "difyai123456" | ConvertTo-SecureString -AsPlainText -Force

    $null = Initialize-Dify -Server $Server -Email $Email -Name $Name -InitPassword $InitPassword -Password $Password
}
