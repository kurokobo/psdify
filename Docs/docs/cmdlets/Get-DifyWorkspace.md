---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Get-DifyWorkspace

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Retrieves workspace information from Dify.

## SYNTAX

```powershell
Get-DifyWorkspace [[-Id] <String[]>] [[-Name] <String[]>] [[-Search] <String[]>]
 [<CommonParameters>]
```

## DESCRIPTION

The `Get-DifyWorkspace` cmdlet retrieves information about workspaces in Dify. Workspaces can be filtered by their ID, name, or through a search query that matches either the ID or name.

NOTE: This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## EXAMPLES

### Example 1

```powershell
Get-DifyWorkspace
```

Retrieves all available workspaces.

### Example 2

```powershell
Get-DifyWorkspace -Id "..."
```

Retrieves a workspace by its ID.

### Example 3

```powershell
Get-DifyWorkspace -Name "..."
```

Retrieves a workspace by its name.

### Example 4

```powershell
Get-DifyWorkspace -Search "..."
```

Searches for workspaces by ID or name using a wildcard pattern.

## PARAMETERS

### -Id

Specifies the IDs of the workspaces to retrieve. Use this parameter to filter workspaces by their unique IDs.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name

Specifies the names of the workspaces to retrieve. Use this parameter to filter workspaces by their names.

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

### -Search

Specifies a search string to filter workspaces. This parameter matches workspaces where the ID or name contains the specified string (supports wildcard patterns).

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
