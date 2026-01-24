---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Set-DifyPluginPermission

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Update plugin install/debug permissions for the current workspace.

## SYNTAX

```powershell
Set-DifyPluginPermission [[-InstallPermission] <String>] [[-DebugPermission] <String>]
 [<CommonParameters>]
```

## DESCRIPTION

The `Set-DifyPluginPermission` cmdlet updates the plugin permission settings of the currently selected workspace. You can change the install permission, the debug permission, or both in one call. If a parameter is omitted, the current value is kept. When no change is necessary, the cmdlet simply returns the current permissions.

This cmdlet requires a connection to a Dify instance that supports plugins (`Connect-Dify` against a server with plugin support). It throws if plugin support is unavailable or if the server returns an unexpected response from the API.

## EXAMPLES

### Example 1

```powershell
Set-DifyPluginPermission -InstallPermission admins -DebugPermission admins
```

Restrict both install and debug to workspace admins.

### Example 2

```powershell
Set-DifyPluginPermission -InstallPermission everyone
```

Allow anyone in the workspace to install plugins while leaving the debug permission unchanged.

## PARAMETERS

### -DebugPermission

Sets who can debug plugins in the workspace.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: everyone, admins, noone

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstallPermission

Sets who can install plugins in the workspace.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: everyone, admins, noone

Required: False
Position: 0
Default value: None
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
