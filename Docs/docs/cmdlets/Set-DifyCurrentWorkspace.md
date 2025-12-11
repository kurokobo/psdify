---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Set-DifyCurrentWorkspace

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Switches the current workspace to a specified workspace.

## SYNTAX

```powershell
Set-DifyCurrentWorkspace [[-Workspace] <PSObject[]>] [[-Id] <String[]>] [[-Name] <String[]>]
 [<CommonParameters>]
```

## DESCRIPTION

The `Set-DifyCurrentWorkspace` cmdlet switches the current active workspace in Dify to a specified workspace. You can specify the target workspace by providing a workspace object (from `Get-DifyWorkspace`), an ID, or a name. This cmdlet supports pipeline input, allowing you to pass workspace objects directly from other cmdlets.

NOTE: This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## EXAMPLES

### Example 1

```powershell
Get-DifyWorkspace -Name "..." | Set-DifyCurrentWorkspace
```

Switches to a workspace by specifying it directly from `Get-DifyWorkspace`.

### Example 2

```powershell
Set-DifyCurrentWorkspace -Id "..."
```

Switches to a workspace by its ID.

### Example 3

```powershell
Set-DifyCurrentWorkspace -Name "..."
```

Switches to a workspace by its name.

## PARAMETERS

### -Id

Specifies the ID of the workspace to switch to. Use this parameter to identify the target workspace by its unique ID.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name

Specifies the name of the workspace to switch to. Use this parameter to identify the target workspace by its name.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Workspace

Specifies the workspace object to switch to. This parameter accepts workspace objects obtained from the `Get-DifyWorkspace` cmdlet and supports pipeline input.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Management.Automation.PSObject[]

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
