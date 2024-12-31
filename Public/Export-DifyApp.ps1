function Export-DifyApp {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject[]] $App = @(),
        [String] $Path = "DSLs",
        [Switch] $IncludeSecret = $false
    )

    begin {
        if (-not (Test-Path -Path $Path)) {
            $null = New-Item -Path $Path -ItemType Directory
        }
        $Path = Convert-Path -Path $Path
        $ExportedApps = @()
        $Apps = @()
    }

    process {
        foreach ($AppObject in $App) {
            $Apps += $AppObject
        }
    }

    end {
        if (-not $Apps) {
            $Apps = Get-DifyApp
        }
        foreach ($AppObject in $Apps) {
            $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/apps", $AppObject.Id, "/export")
            $Method = "GET"
            $Query = @{
                "include_secret" = $IncludeSecret
            }
            try {
                $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Query $Query -Token $env:PSDIFY_CONSOLE_TOKEN
            }
            catch {
                throw "Failed to export apps: $_"
            }

            $FileNameBase = "$($AppObject.Name)_$($AppObject.Id)" -replace '[<>:"/\\|?*&\[\]]', "_"
            $FileName = "$Path/$FileNameBase.yml"
            $UTF8NoBOM = New-Object "System.Text.UTF8Encoding" -ArgumentList @($false)
            [System.IO.File]::WriteAllText($FileName, $Response.data, $UTF8NoBOM)

            $ExportedApp = [PSCustomObject]@{
                Id            = $AppObject.id
                Name          = $AppObject.name
                IncludeSecret = $IncludeSecret
                FileName      = $FileName
            }
            $ExportedApps += $ExportedApp
        }
        return $ExportedApps
    }
}
