---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Get-DifyAppAPIKey

## SYNOPSIS

Retrieve the API key(s) associated with a specific app.

## SYNTAX

```powershell
Get-DifyAppAPIKey [[-App] <PSObject>] [<CommonParameters>]
```

## DESCRIPTION

The `Get-DifyAppAPIKey` cmdlet retrieves API key(s) for a specified app in your Dify workspace. You can provide the app object as input, either directly or via a pipeline from `Get-DifyApp`.

## EXAMPLES

### Example 1

```powershell
Get-DifyApp -Name "MyApp" | Get-DifyAppAPIKey
```

Get API key (specify directly from Get-DifyApp).

### Example 2

```powershell
$AppsToGetAPIKey = Get-DifyApp -Name "MyApp"
Get-DifyAppAPIKey -App $AppsToGetAPIKey
```

Get API key (use result from Get-DifyApp).

## PARAMETERS

### -App

Specifies the app object for which the API key(s) will be retrieved. The app object can be passed directly or via a pipeline from `Get-DifyApp`.

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

- This cmdlet requires the `$env:PSDIFY_CONSOLE_TOKEN` environment variable to authenticate the request.
- Ensure the app object provided contains a valid `Id` property for successful API key retrieval.

## RELATED LINKS
