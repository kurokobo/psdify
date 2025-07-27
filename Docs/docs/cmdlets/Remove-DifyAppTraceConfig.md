---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Remove-DifyAppTraceConfig

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Remove the trace configuration for a specific Dify app and tracing provider.

## SYNTAX

```powershell
Remove-DifyAppTraceConfig [[-App] <PSObject>] [[-Provider] <String>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

The `Remove-DifyAppTraceConfig` cmdlet removes the trace configuration for a specified app and tracing provider in your Dify workspace. If the trace is currently enabled for the provider, it will also be disabled automatically.

## EXAMPLES

### Example 1

```powershell
Get-DifyApp -Name "MyApp" | Remove-DifyAppTraceConfig -Provider "langfuse"
```

Remove the trace configuration for the app using the "langfuse" provider.

### Example 2

```powershell
$App = Get-DifyApp -Name "MyApp"
Remove-DifyAppTraceConfig -App $App -Provider "langsmith"
```

Remove the trace configuration for the app using the "langsmith" provider.

## PARAMETERS

### -App

Specifies the app object for which the trace configuration will be removed. The app object can be passed directly or via a pipeline from `Get-DifyApp`.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Provider

Specifies the tracing provider name for which the configuration will be removed.

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

### System.Management.Automation.PSObject

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
