---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Get-DifyAppTrace

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Retrieve the trace settings for a specific Dify app.

## SYNTAX

```powershell
Get-DifyAppTrace [[-App] <PSObject>] [<CommonParameters>]
```

## DESCRIPTION

The `Get-DifyAppTrace` cmdlet retrieves the trace (tracing) settings for a specified app in your Dify workspace. You can provide the app object as input, either directly or via a pipeline from `Get-DifyApp`.

## EXAMPLES

### Example 1

```powershell
Get-DifyApp -Name "MyApp" | Get-DifyAppTrace
```

Get trace settings for the app returned by Get-DifyApp.

### Example 2

```powershell
$App = Get-DifyApp -Name "MyApp"
Get-DifyAppTrace -App $App
```

Get trace settings for the app using a variable.

## PARAMETERS

### -App

Specifies the app object for which the trace settings will be retrieved. The app object can be passed directly or via a pipeline from `Get-DifyApp`.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Management.Automation.PSObject

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
