---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Get-DifyDSLContent

## SYNOPSIS

Retrieve content from a DSL file as a string in UTF-8 format without BOM.

## SYNTAX

```powershell
Get-DifyDSLContent [[-Path] <String>] [<CommonParameters>]
```

## DESCRIPTION

`Get-DifyDSLContent` retrieves the content of a specified DSL file and ensures it is read in UTF-8 format without BOM. This cmdlet is useful for reading files and processing their content as a string.

## EXAMPLES

### Example 1

```powershell
$RawContent = Get-DifyDSLContent -Path "DSLs/old.yml"
```

Retrieve content from DSL file.

## PARAMETERS

### -Path

Specifies the path to the DSL file from which the content is to be retrieved.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
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

- The cmdlet throws an error if the `-Path` parameter is not provided or if the specified file does not exist.
- Ensure the file specified is accessible and in a readable format.

## RELATED LINKS
