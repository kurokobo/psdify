---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# New-DifyKnowledge

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Create new empty knowledge to the workspace.

## SYNTAX

```powershell
New-DifyKnowledge [[-Name] <String>] [[-Description] <String>]
 [<CommonParameters>]
```

## DESCRIPTION

The `New-DifyKnowledge` cmdlet creates a new knowledge in the workspace.

NOTE: This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## EXAMPLES

### Example 1

```powershell
New-DifyKnowledge -Name "My New Knowledge"
```

Adds a new knowledge entity named "My New Knowledge" to the workspace.

### Example 2

```powershell
New-DifyKnowledge -Name "My New Knowledge" -Description "This is a new knowledge."
```

Adds a new knowledge entity named "My New Knowledge" with the description "This is a new knowledge."

## PARAMETERS

### -Description

Specifies a description for the new knowledge entity.

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

Specifies the name for the new knowledge entity.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
