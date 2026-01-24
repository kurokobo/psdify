function Remove-DifyToolProviderCredential {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject[]] $Credential = @()
    )

    begin {
        $Credentials = @()
    }

    process {
        foreach ($CredentialObject in $Credential) {
            $Credentials += $CredentialObject
        }
    }

    end {
        foreach ($Credential in $Credentials) {
            $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current/tool-provider/builtin", $Credential.Provider, "delete")
            $Method = "POST"
            $Body = @{
                "credential_id" = $Credential.Id
            } | ConvertTo-Json -Depth 10

            if ($PSCmdlet.ShouldProcess("$($Credential.Name) on $($Credential.Provider)", "Remove Tool Credential")) {
                try {
                    $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
                }
                catch {
                    throw "Failed to remove tool credential: $_"
                }
                if (-not $Response.result -or $Response.result -ne "success") {
                    throw "Failed to remove tool credential"
                }
            }
        }
    }
}
