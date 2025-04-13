function Add-DifyFile {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject[]] $Item = @(),
        [String[]] $Path = @(),
        [String] $Source
    )

    begin {
        $Files = @()
    }

    process {
        foreach ($ItemObject in $Item) {
            $Files += $ItemObject
        }
    }

    end {
        if (-not $Files -and -not $Path) {
            throw "Path is required"
        }
        if ($Path) {
            $Files += Get-ChildItem -Path $Path
        }

        $UploadedFiles = @()
        foreach ($File in $Files) {
            $Result = New-TemporaryFileForBinaryUpload -File $File
            $TemporaryFile = $Result.TemporaryFile
            $ContentType = $Result.ContentType

            $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/files/upload")
            $Method = "POST"
            if ($Source) {
                $Query = @{
                    "source" = $Source
                }
            }
            else {
                $Query = $null
            }

            try {
                $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -ContentType $ContentType -Query $Query -InFile $TemporaryFile -Token $env:PSDIFY_CONSOLE_TOKEN
            }
            catch {
                throw "Failed to upload file: $_"
            }

            if (-not $Response.id) {
                throw "Failed to upload file"
            }
        
            $Members = Get-DifyMember

            $CreatedBy = $Members | Where-Object { $_.Id -eq $Response.created_by } | Select-Object -ExpandProperty Email
            if (-not $CreatedBy) {
                $CreatedBy = $Response.created_by
            }

            $UploadedFile = [PSCustomObject]@{
                Id        = $Response.id
                Name      = $Response.name
                Size      = $Response.size
                Extension = $Response.extension
                MimeType  = $Response.mime_type
                CreatedBy = $CreatedBy
                CreatedAt = Convert-UnixTimeToLocalDateTime($Response.created_at)
            }
            $UploadedFiles += $UploadedFile
        }
        return $UploadedFiles
    }
}
