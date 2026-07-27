---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Set-DifyAppAPI

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Enable or disable API access for an app.

## SYNTAX

```powershell
Set-DifyAppAPI [[-App] <PSObject[]>] [-Enable] [-Disable]
 [<CommonParameters>]
```

## DESCRIPTION

The `Set-DifyAppAPI` cmdlet enables or disables API access for an app. Either `-Enable` or `-Disable` must be specified; they cannot be combined with each other.

NOTE: This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## EXAMPLES

### Example 1

```powershell
Get-DifyApp -Name "My App" | Set-DifyAppAPI -Enable
```

Enable API access for the specified app.

### Example 2

```powershell
Get-DifyApp | Set-DifyAppAPI -Disable
```

Disable API access for all apps.

## PARAMETERS

### -App

Specifies the app objects to update. This parameter accepts pipeline input from `Get-DifyApp`.

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

### -Disable

Disables API access for the app. Cannot be combined with `-Enable`.

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

### -Enable

Enables API access for the app. Cannot be combined with `-Disable`.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Management.Automation.PSObject[]

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
