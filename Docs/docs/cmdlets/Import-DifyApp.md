---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Import-DifyApp

## SYNOPSIS

Import apps from local DSL files or inline content.

## SYNTAX

```powershell
Import-DifyApp [[-Item] <Object>] [[-Path] <String[]>] [-Content]
 [<CommonParameters>]
```

## DESCRIPTION

The `Import-DifyApp` cmdlet allows you to import applications into Dify by specifying DSL file paths, objects, or inline content. It supports multiple files and wildcards, making it flexible for batch imports. You can also pipe the content directly to the cmdlet for processing.

## EXAMPLES

### Example 1

```powershell
Import-DifyApp -Path "DSLs/*.yml"
Import-DifyApp -Path "DSLs/demo1.yml", "DSLs/demo2.yml"
```

Import apps by specifying file paths (supports wildcards and multiple paths).

### Example 2

```powershell
Get-Item -Path "DSLs/*.yml" | Import-DifyApp
```

Import apps by specifying directly from `Get-Item` or `Get-ChildItem`.

### Example 3

```powershell
$DSLFiles = Get-ChildItem -Path "DSLs/*.yml"
Import-DifyApp -Item $DSLFiles
```

Import apps by using the result from `Get-ChildItem`.

### Example 4

```powershell
Get-DifyDSLContent -Path "DSLs/demo.yml" | Import-DifyApp -Content
```

Import an app by specifying the content of the DSL file directly via pipe.

## PARAMETERS

### -Content

Indicates that the content of the DSL file will be directly provided via pipeline instead of specifying file paths.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Item

Specifies the item(s) to be imported. This can include objects retrieved from `Get-Item` or `Get-ChildItem`.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Path

Specifies the file paths of the DSL files to be imported. Supports multiple paths and wildcards.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object

## OUTPUTS

### System.Object

## NOTES

This cmdlet is particularly useful for batch importing applications or when working with customized DSL content that may be dynamically generated or modified.

## RELATED LINKS
