---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Get-DifyAppTraceConfig

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Retrieve the trace configuration(s) for a specific Dify app and tracing provider(s).

## SYNTAX

```powershell
Get-DifyAppTraceConfig [[-App] <PSObject>] [[-Provider] <String[]>]
 [<CommonParameters>]
```

## DESCRIPTION

The `Get-DifyAppTraceConfig` cmdlet retrieves the trace configuration(s) for a specified app in your Dify workspace. You can specify one or more tracing providers. If no provider is specified, all supported providers will be queried. The app object can be provided directly or via a pipeline from `Get-DifyApp`.

## EXAMPLES

### Example 1

```powershell
Get-DifyApp -Name "MyApp" | Get-DifyAppTraceConfig
```

Get trace configurations for all supported providers for the app returned by Get-DifyApp.

### Example 2

```powershell
$App = Get-DifyApp -Name "MyApp"
Get-DifyAppTraceConfig -App $App -Provider "langfuse", "langsmith"
```

Get trace configurations for specific providers for the app using a variable.

## PARAMETERS

### -App

Specifies the app object for which the trace configuration(s) will be retrieved. The app object can be passed directly or via a pipeline from `Get-DifyApp`.

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

Specifies one or more tracing provider names to query. If not specified, all supported providers will be queried.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: All supported providers
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
