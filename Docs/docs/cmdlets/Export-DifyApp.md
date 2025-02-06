---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Export-DifyApp

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Export apps to DSL files. By default, files are saved in the `DSLs` directory.

## SYNTAX

```powershell
Export-DifyApp [[-App] <PSObject[]>] [[-Path] <String>] [-IncludeSecret]
 [<CommonParameters>]
```

## DESCRIPTION

The `Export-DifyApp` cmdlet allows you to export applications as DSL files. You can specify the directory where the files should be saved and include sensitive information (like secrets) in the export if needed.

NOTE: This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## EXAMPLES

### Example 1

```powershell
Get-DifyApp | Export-DifyApp
```

Export apps by specifying directly from Get-DifyApp.

### Example 2

```powershell
$AppsToBeExported = Get-DifyApp
Export-DifyApp -App $AppsToBeExported
```

Export apps by using result from Get-DifyApp.

### Example 3

```powershell
Get-DifyApp | Export-DifyApp -Path "./path/to/your/directory"
```

Export apps to a specific directory.

### Example 4

```powershell
Get-DifyApp | Export-DifyApp -IncludeSecret
```

Export apps with sensitive information.

## PARAMETERS

### -App

Specifies the application object(s) to export. This parameter accepts input from the pipeline.

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

### -IncludeSecret

Includes sensitive information (like secrets) in the exported DSL files.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path

Specifies the directory where the exported DSL files should be saved. If the directory does not exist, it will be created.

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

### System.Management.Automation.PSObject[]

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
