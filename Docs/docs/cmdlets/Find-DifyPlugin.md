---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Find-DifyPlugin

## SYNOPSIS

Retrieve available plugins from the Dify Marketplace.

## SYNTAX

```powershell
Find-DifyPlugin [[-Category] <String>] [[-Id] <String>] [[-Name] <String>] [[-Search] <String>]
 [<CommonParameters>]
```

## DESCRIPTION

The `Find-DifyPlugin` cmdlet retrieves information about available plugins from the Dify Marketplace. You can filter plugins by category, ID, name, or search string. This cmdlet requires a Dify server that supports plugins.

## EXAMPLES

### Example 1

```powershell
Find-DifyPlugin -Category "model"
```

Retrieve all plugins in the specified category. Valid categories include "model", "tool", "agent", "extension", and "bundle".

### Example 2

```powershell
Find-DifyPlugin -Id "langgenius/openai"
```

Retrieve a specific plugin by its ID.

### Example 3

```powershell
Find-DifyPlugin -Name "openai"
```

Retrieve a specific plugin by its name.

### Example 4

```powershell
Find-DifyPlugin -Search "openai"
```

Search for plugins by keyword in the ID, name, or display name.

## PARAMETERS

### -Category

Specifies the category of the plugin to search for. Valid categories include "model", "tool", "agent", "extension", and "bundle". Use "agent" for agent strategy plugins.

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

Specifies the ID of the plugin to retrieve.

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

### -Name

Specifies the name of the plugin to retrieve. This supports exact matches.

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

### -Search

Specifies a search string to filter plugins by name, ID, or description. This supports partial matches.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

- The Dify server must support plugins for this cmdlet to function. If the server does not support plugins, an error is thrown.
- The `agent` category is internally mapped to `agent-strategy`.

## RELATED LINKS
