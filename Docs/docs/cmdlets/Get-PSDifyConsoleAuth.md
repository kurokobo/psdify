---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Get-PSDifyConsoleAuth

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Retrieve the current console authentication token for Dify.

## SYNTAX

```powershell
Get-PSDifyConsoleAuth [<CommonParameters>]
```

## DESCRIPTION

The `Get-PSDifyConsoleAuth` cmdlet retrieves the current console authentication session or token that is set by the `Connect-Dify` cmdlet. This value is stored in the module-scoped variable `$script:PSDIFY_CONSOLE_AUTH` and is used internally by other PSDify cmdlets to authenticate API requests.

The type of the returned value depends on the Dify server version:

- For Dify version 1.9.2 or later: Returns a `Microsoft.PowerShell.Commands.WebRequestSession` object
- For Dify version earlier than 1.9.2: Returns a string containing the access token

NOTE: This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## EXAMPLES

### Example 1

```powershell
Get-PSDifyConsoleAuth
```

Retrieve the current console authentication session or token.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

The authentication session or token is set when you successfully authenticate using the `Connect-Dify` cmdlet. If you have not authenticated yet, this cmdlet will return `$null`.

## RELATED LINKS
