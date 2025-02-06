---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Disconnect-Dify

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Log out from Dify and clear all related environment variables.

## SYNTAX

```powershell
Disconnect-Dify [-Force] [<CommonParameters>]
```

## DESCRIPTION

The `Disconnect-Dify` cmdlet logs out the current user from Dify by invalidating the issued tokens and clears all related environment variables. If the `-Force` parameter is specified, local environment variables are cleared regardless of whether the logout process succeeds.

NOTE: This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## EXAMPLES

### Example 1

```powershell
PS C:\> Disconnect-Dify
```

Log out from Dify and invalidate issued tokens.

### Example 2

```powershell
PS C:\> Disconnect-Dify -Force
```

Force logout and clear all local environment variables, even if the logout process fails.

## PARAMETERS

### -Force

Forces the removal of local environment variables regardless of the success of the logout process.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
