---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Get-DifyKnowledge

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Retrieve knowledge information from the Dify workspace.

## SYNTAX

```powershell
Get-DifyKnowledge [[-Id] <String>] [[-Name] <String>] [[-Search] <String>] [[-Tags] <String[]>] [-IncludeAll]
 [<CommonParameters>]
```

## DESCRIPTION

The `Get-DifyKnowledge` cmdlet retrieves knowledge information from the Dify workspace. You can filter the results by specifying knowledge ID, name, search keyword, or associated tags. If no parameters are provided, all available knowledge information is returned.

NOTE: This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## EXAMPLES

### Example 1

```powershell
Get-DifyKnowledge
```

Get all knowledge.

### Example 2

```powershell
Get-DifyKnowledge -Id "..."
```

Get knowledge by ID.

### Example 3

```powershell
Get-DifyKnowledge -Name "..."
```

Get knowledge by name with complete match.

### Example 4

```powershell
Get-DifyKnowledge -Search "..."
```

Get knowledge by name with partial match.

### Example 5

```powershell
Get-DifyKnowledge -Tags "...", "..."
```

Get knowledge by tags, multiple tags can be specified.

## PARAMETERS

### -Id

Specifies the unique identifier of the knowledge to retrieve.

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

### -IncludeAll

Specifies that if the authenticated user is the owner of the workspace, knowledge created by other members will also be included in the retrieval.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name

Specifies the name of the knowledge to retrieve. This performs an exact match search.

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

Specifies a keyword to perform a partial match search on the knowledge name.

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

Specifies one or more tags to filter knowledge by associated tags.

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
