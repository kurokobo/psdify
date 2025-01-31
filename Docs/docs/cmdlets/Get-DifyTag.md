---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Get-DifyTag

## SYNOPSIS

Retrieve tag information for either apps or knowledge.

## SYNTAX

```powershell
Get-DifyTag [[-Id] <String[]>] [[-Name] <String[]>] [[-Type] <String>]
 [<CommonParameters>]
```

## DESCRIPTION

The `Get-DifyTag` cmdlet retrieves tag information from the Dify platform. Tags can be filtered by their type (`app` or `knowledge`), ID, or name.

## EXAMPLES

### Example 1

```powershell
Get-DifyTag -Type "app"
```

Get tags by type.

### Example 2

```powershell
Get-DifyTag -Type "app" -Id "..."
```

Get tags by ID.

### Example 3

```powershell
Get-DifyTag -Type "app" -Name "..."
```

Get tags by name.

## PARAMETERS

### -Id

Specifies the IDs of the tags to retrieve. Use this parameter to filter tags by their unique IDs.

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

Specifies the names of the tags to retrieve. Use this parameter to filter tags by their names.

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

### -Type

Specifies the type of tags to retrieve. The valid values are `app` or `knowledge`. This parameter is required to execute the cmdlet.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

- The `-Type` parameter is mandatory because the cmdlet requires a tag type to filter results (`app` or `knowledge`).
- Ensure the `$env:PSDIFY_CONSOLE_TOKEN` environment variable is set and valid before executing this cmdlet.

## RELATED LINKS
