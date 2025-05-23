---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# New-DifyAppAPIKey

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Creates a new API key for a specified app.

## SYNTAX

```powershell
New-DifyAppAPIKey [[-App] <PSObject>] [<CommonParameters>]
```

## DESCRIPTION

The `New-DifyAppAPIKey` cmdlet generates a new API key for the given app. API keys are used to authenticate and authorize app-related operations.

NOTE: This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## EXAMPLES

### Example 1

```powershell
Get-DifyApp -Name "..." | New-DifyAppAPIKey
```

Creates a new API key for the app named "...".

## PARAMETERS

### -App

The app for which the API key should be created. This parameter accepts an app object, typically retrieved using the `Get-DifyApp` cmdlet.

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
