---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Get-DifyPluginPermission

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Retrieve plugin install/debug permissions for the current workspace.

## SYNTAX

```powershell
Get-DifyPluginPermission [<CommonParameters>]
```

## DESCRIPTION

The `Get-DifyPluginPermission` cmdlet fetches the plugin permission settings of the currently selected workspace. It calls the console API to read the workspace plugin preferences and returns a simple object containing both install and debug permissions.

This cmdlet requires a connection to a Dify instance that supports plugins (`Connect-Dify` against a server with plugin support). It throws if plugin support is unavailable or if the server returns an unexpected response.

## EXAMPLES

### Example 1

```powershell
Get-DifyPluginPermission
```

Get the current plugin permissions for the workspace.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
