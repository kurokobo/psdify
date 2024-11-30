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

            $Boundary = "----WebKitFormBoundary" + [System.Guid]::NewGuid().ToString("N")
            $UTF8NoBOM = New-Object "System.Text.UTF8Encoding" -ArgumentList @($false)
            $TemporaryFile = New-TemporaryFile
            Write-Verbose "using $($TemporaryFile.FullName) as temporary file"

            $FileStream = New-Object System.IO.FileStream($TemporaryFile, [System.IO.FileMode]::Append)
            $BinaryWriter = New-Object System.IO.BinaryWriter($FileStream)

            $BinaryWriter.Write($UTF8NoBOM.GetBytes("--$($Boundary)`r`n"))
            $BinaryWriter.Write($UTF8NoBOM.GetBytes("Content-Disposition: form-data; name=`"file`"; filename=`"$($File.Name)`"`r`n"))
            $BinaryWriter.Write($UTF8NoBOM.GetBytes("Content-Type: application/octet-stream`r`n`r`n"))
            $BinaryWriter.Write([System.IO.File]::ReadAllBytes($File.FullName))
            $BinaryWriter.Write($UTF8NoBOM.GetBytes("`r`n--$($Boundary)--`r`n"))
            $BinaryWriter.Close()

            $Endpoint = "$($env:PSDIFY_URL)/console/api/files/upload"
            $ContentType = "multipart/form-data; boundary=$($Boundary)"
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
