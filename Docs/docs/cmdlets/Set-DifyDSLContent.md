---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Set-DifyDSLContent

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Writes the provided content to a DSL file at the specified path, ensuring UTF-8 encoding without BOM.

## SYNTAX

```powershell
Set-DifyDSLContent [[-Content] <String>] [[-Path] <String>]
 [<CommonParameters>]
```

## DESCRIPTION

The `Set-DifyDSLContent` cmdlet writes content to a specified DSL file. If the file does not exist, it creates a new file. The content is written in UTF-8 encoding without a byte order mark (BOM). This cmdlet is particularly useful for modifying DSL files programmatically or preparing them for other cmdlets that use DSL files.

NOTE: This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## EXAMPLES

### Example 1

```powershell
$RawContent = Get-DifyDSLContent -Path "DSLs/old.yml"
$RawContent -replace "8b960203-299d-4345-b953-3308663dd790", "574d9556-189a-4d35-b296-09231b859667" | Set-DifyDSLContent -Path "DSLs/new.yml"
```

This example replaces an old knowledge ID in the `$RawContent` variable with a new knowledge ID and saves the modified content to a new DSL file located at `DSLs/new.yml`.

## PARAMETERS

### -Content

The content to be written to the DSL file. This parameter accepts pipeline input.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Path

The path to the DSL file where the content will be written. If the specified file does not exist, it will be created.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
