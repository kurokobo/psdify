function New-TemporaryFileForBinaryUpload {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo] $File,
        [String] $Name = "file"
    )

    $Boundary = "----WebKitFormBoundary" + [System.Guid]::NewGuid().ToString("N")
    $UTF8NoBOM = New-Object "System.Text.UTF8Encoding" -ArgumentList @($false)
    $TemporaryFile = New-TemporaryFile

    $FileStream = New-Object System.IO.FileStream($TemporaryFile, [System.IO.FileMode]::Append)
    $BinaryWriter = New-Object System.IO.BinaryWriter($FileStream)

    $BinaryWriter.Write($UTF8NoBOM.GetBytes("--$($Boundary)`r`n"))
    $BinaryWriter.Write($UTF8NoBOM.GetBytes("Content-Disposition: form-data; name=`"$($Name)`"; filename=`"$($File.Name)`"`r`n"))
    $BinaryWriter.Write($UTF8NoBOM.GetBytes("Content-Type: application/octet-stream`r`n`r`n"))
    $BinaryWriter.Write([System.IO.File]::ReadAllBytes($File.FullName))
    $BinaryWriter.Write($UTF8NoBOM.GetBytes("`r`n--$($Boundary)--`r`n"))
    $BinaryWriter.Close()

    $ContentType = "multipart/form-data; boundary=$($Boundary)"

    return @{
        TemporaryFile = $TemporaryFile
        ContentType = $ContentType
    }
}