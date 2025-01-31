---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Uninstall-DifyPlugin

## SYNOPSIS

Uninstalls one or more plugins from the current Dify workspace.

## SYNTAX

```powershell
Uninstall-DifyPlugin [[-Plugin] <PSObject[]>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

The `Uninstall-DifyPlugin` cmdlet is used to uninstall plugins from the current Dify workspace. You can specify plugins to uninstall either by passing them as pipeline objects or directly using the `-Plugin` parameter. The cmdlet requires the Dify server to support plugins, and it will throw an error if plugin support is not available.

## EXAMPLES

### Example 1

```powershell
Get-DifyPlugin -Name "ExamplePlugin" | Uninstall-DifyPlugin
```

Uninstalls the plugin named "ExamplePlugin" from the current workspace.

## PARAMETERS

### -Plugin

Specifies the plugin(s) to uninstall. You can pass the plugin objects directly or pipe them from `Get-DifyPlugin`.

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

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf

Shows what would happen if the cmdlet runs. The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
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

- This cmdlet will throw an error if the current Dify server does not support plugins.
- The `-WhatIf` and `-Confirm` parameters can be used to preview or confirm the operation before execution.

## RELATED LINKS
