---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Set-DifyAppTrace

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Enable or disable tracing for a specific Dify app and tracing provider.

## SYNTAX

```powershell
Set-DifyAppTrace [[-App] <PSObject>] [[-Provider] <String>] [-Enable] [-Disable]
 [<CommonParameters>]
```

## DESCRIPTION

The `Set-DifyAppTrace` cmdlet enables or disables tracing for a specified app and tracing provider in your Dify workspace. You must specify either `-Enable` or `-Disable`. When enabling, the provider must also be specified.

## EXAMPLES

### Example 1

```powershell
Get-DifyApp -Name "MyApp" | Set-DifyAppTrace -Provider "langfuse" -Enable
```

Enable tracing for the app using the "langfuse" provider.

### Example 2

```powershell
$App = Get-DifyApp -Name "MyApp"
Set-DifyAppTrace -App $App -Disable
```

Disable tracing for the app.

## PARAMETERS

### -App

Specifies the app object for which tracing will be enabled or disabled. The app object can be passed directly or via a pipeline from `Get-DifyApp`.

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

### -Disable

Disables tracing for the app.

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

### -Enable

Enables tracing for the specified provider.

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

Specifies the tracing provider name. Required when enabling tracing.

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

### System.Management.Automation.PSObject

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
