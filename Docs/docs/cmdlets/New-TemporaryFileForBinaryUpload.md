---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# New-TemporaryFileForBinaryUpload

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Internal helper function: Creates a temporary file formatted for binary file uploads using multipart/form-data.

## SYNTAX

```powershell
New-TemporaryFileForBinaryUpload [-File] <FileInfo> [<CommonParameters>]
```

## DESCRIPTION

The `New-TemporaryFileForBinaryUpload` cmdlet creates a temporary file that contains the specified binary file encoded in multipart/form-data format. This cmdlet is primarily used internally by other PSDify cmdlets such as `Add-DifyFile` and is not typically intended for direct use by users.

The cmdlet returns a hashtable containing the path to the temporary file and the appropriate Content-Type header value.

## EXAMPLES

### Example 1

```powershell
PS C:\> $File = Get-Item -Path "C:\path\to\document.pdf"
PS C:\> $UploadData = New-TemporaryFileForBinaryUpload -File $File
```

Creates a temporary file containing the specified PDF file encoded in multipart/form-data format. This cmdlet is typically used internally by other PSDify cmdlets.

## PARAMETERS

### -File

Specifies the file to be prepared for upload. This parameter accepts a FileInfo object, which can be obtained using the Get-Item cmdlet.

```yaml
Type: FileInfo
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
