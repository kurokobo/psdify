function Start-DifyInstance {
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

    try {
        $CurrentDifyVersion = (Get-DifyVersion -Server "http://host.docker.internal/").Version
    }
    catch {
        $CurrentDifyVersion = ""
    }

    if ($CurrentDifyVersion -ne $Version) {
        Remove-DifyInstance -Path $Path
        New-DifyInstance -Path $Path -Version $Version -EnvFile $EnvFile -OverrideFile $OverrideFile

        $Server = "http://host.docker.internal/"
        $Email = "dify@example.com"
        $Name = "Dify"
        $InitPassword = "difyai123456" | ConvertTo-SecureString -AsPlainText -Force
        $Password = "difyai123456" | ConvertTo-SecureString -AsPlainText -Force

        $null = Initialize-Dify -Server $Server -Email $Email -Name $Name -InitPassword $InitPassword -Password $Password
    }
}
