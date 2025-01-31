---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Get-DifyApp

## SYNOPSIS

Retrieve app information from Dify.

## SYNTAX

```powershell
Get-DifyApp [[-Id] <String>] [[-Name] <String>] [[-Search] <String>] [[-Mode] <String>] [[-Tags] <String[]>]
 [<CommonParameters>]
```

## DESCRIPTION

The `Get-DifyApp` cmdlet allows you to retrieve app information from Dify. You can filter the results by specifying an app ID, name, search term, mode, or tags.

## EXAMPLES

### Example 1

```powershell
Get-DifyApp
```

Get all apps.

### Example 2

```powershell
Get-DifyApp -Id "..."
```

Get apps by ID.

### Example 3

```powershell
Get-DifyApp -Name "..."
```

Get apps by name (complete match).

### Example 4

```powershell
Get-DifyApp -Search "..."
```

Get apps by name (partial match).

### Example 5

```powershell
Get-DifyApp -Mode "chat"
```

Get apps by mode.

### Example 6

```powershell
Get-DifyApp -Tags "...", "..."
```

Get apps by tags (multiple tags can be specified).

### Example 7

```powershell
Get-DifyApp -Name "..." -Mode "chat"
```

Combine filters to get apps by name and mode.

## PARAMETERS

### -Id

The unique identifier of the app to retrieve.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Mode

The mode of the app to retrieve. Valid values are "chat", "workflow", "agent-chat", "channel", and "all".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name

The name of the app to retrieve (exact match).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Search

A partial name or search term to filter apps.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tags

A list of tags to filter apps by.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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
