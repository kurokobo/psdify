---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Add-DifyFile

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Upload files to the Dify platform. This is not designed to invoke manually, but rather to be used by other cmdlets.

## SYNTAX

```powershell
Add-DifyFile [[-Item] <PSObject[]>] [[-Path] <String[]>] [[-Source] <String>]
 [<CommonParameters>]
```

## DESCRIPTION

The `Add-DifyFile` cmdlet uploads one or more files to the Dify platform. You can specify files directly using the `-Path` parameter or pass file objects through the pipeline to the `-Item` parameter. An optional `-Source` parameter can be used to provide additional source information for the uploaded files.

NOTE: This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## EXAMPLES

### Example 1

```powershell
Add-DifyFile -Path "Files/*"
```

Upload files (specify file paths, supports wildcards and multiple paths).

### Example 2

```powershell
Get-Item -Path "Files/*" | Add-DifyFile
```

Upload files (specify from Get-Item or Get-ChildItem via pipe).

### Example 3

```powershell
Get-Item -Path "Files/*" | Add-DifyFile -Source "..."
```

Upload files (specify source information).

## PARAMETERS

### -Item

A collection of file objects to upload. You can pass file objects to this parameter through the pipeline.

```yaml
Type: PSObject[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Path

One or more file paths to upload. Wildcards are supported.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Source

Specifies additional source information for the uploaded files.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Management.Automation.PSObject[]

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
