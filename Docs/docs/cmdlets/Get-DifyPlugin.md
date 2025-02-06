---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Get-DifyPlugin

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Retrieve plugin information from the current Dify workspace.

## SYNTAX

```powershell
Get-DifyPlugin [[-Category] <String>] [[-Id] <String[]>] [[-Name] <String[]>] [[-UniqueIdentifier] <String[]>]
 [[-Search] <String>] [<CommonParameters>]
```

## DESCRIPTION

The `Get-DifyPlugin` cmdlet retrieves a list of plugins available in the current Dify workspace. You can filter the plugins by category, ID, name, unique identifier, or search term. The cmdlet returns information such as the plugin's category, name, display name, ID, description, version, and unique identifier.

NOTE: This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## EXAMPLES

### Example 1

```powershell
Get-DifyPlugin
```

Retrieve all plugins.

### Example 2

```powershell
Get-DifyPlugin -Category "model"
```

Retrieve plugins by category.

### Example 3

```powershell
Get-DifyPlugin -Id "plugin-id-1234"
```

Retrieve a plugin by its ID.

### Example 4

```powershell
Get-DifyPlugin -Search "example"
```

Search for plugins by name or description.

## PARAMETERS

### -Category

Specifies the category of plugins to retrieve.

Valid categories are:

- "model"
- "tool"
- "agent"
- "extension"
- "bundle"

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

### -Id

Specifies the IDs of plugins to retrieve.

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

Specifies the names of plugins to retrieve.

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

### -Search

Specifies a search term to filter plugins by their ID, name, or display name. Supports partial matches.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UniqueIdentifier

Specifies the unique identifiers of plugins to retrieve.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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
