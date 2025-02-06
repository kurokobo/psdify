---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Get-DifyKnowledgeTag

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Retrieve tag information for knowledge.

## SYNTAX

```powershell
Get-DifyKnowledgeTag [[-Id] <String[]>] [[-Name] <String[]>]
 [<CommonParameters>]
```

## DESCRIPTION

The `Get-DifyKnowledgeTag` cmdlet retrieves tag information associated with knowledge in the workspace. This is equivalent to executing `Get-DifyTag -Type "knowledge"`.

NOTE: This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## EXAMPLES

### Example 1

```powershell
Get-DifyKnowledgeTag
```

Retrieve all knowledge tags.

### Example 2

```powershell
Get-DifyKnowledgeTag -Id "..."
```

Retrieve knowledge tags by ID.

### Example 3

```powershell
Get-DifyKnowledgeTag -Name "..."
```

Retrieve knowledge tags by name.

## PARAMETERS

### -Id

Specifies the IDs of the knowledge tags to retrieve.

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

Specifies the names of the knowledge tags to retrieve.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
