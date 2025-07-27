---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Set-DifyAppTraceConfig

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Update the trace configuration for a specific Dify app and tracing provider.

## SYNTAX

```powershell
Set-DifyAppTraceConfig [[-App] <PSObject>] [[-Provider] <String>] [[-Config] <Hashtable>] [-Enable]
 [<CommonParameters>]
```

## DESCRIPTION

The `Set-DifyAppTraceConfig` cmdlet updates the trace configuration for a specified app and tracing provider in your Dify workspace. You can optionally enable tracing for the provider after updating the configuration. The app object can be provided directly or via a pipeline from `Get-DifyApp`.

## EXAMPLES

### Example 1

```powershell
Get-DifyApp -Name "MyApp" | Set-DifyAppTraceConfig -Provider "langfuse" -Config @{
    api_key  = "phoenix-admin-secret-00000000000"
    endpoint = "https://phoenix.example.com/"
    project  = "psdify"
}
```

Update the trace configuration for the app using the "langfuse" provider.

### Example 2

```powershell
$App = Get-DifyApp -Name "MyApp"
Set-DifyAppTraceConfig -App $App -Provider "langsmith" -Config @{
    api_key  = "phoenix-admin-secret-00000000000"
    endpoint = "https://phoenix.example.com/"
    project  = "psdify"
} -Enable
```

Update and enable the trace configuration for the app using the "langsmith" provider.

## PARAMETERS

### -App

Specifies the app object for which the trace configuration will be updated. The app object can be passed directly or via a pipeline from `Get-DifyApp`.

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

### -Config

Specifies the configuration settings for the tracing provider as a hashtable.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Enable

If specified, enables tracing for the provider after updating the configuration.

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

### -Provider

Specifies the tracing provider name for which the configuration will be updated.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: ""
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
