---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Remove-DifyKnowledge

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Removes knowledge entries from the Dify workspace.

## SYNTAX

```powershell
Remove-DifyKnowledge [[-Knowledge] <PSObject[]>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

The `Remove-DifyKnowledge` cmdlet deletes specified knowledges from the Dify workspace. It supports pipeline input, allowing you to pipe the result of `Get-DifyKnowledge` directly into this cmdlet for deletion.

NOTE: This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## EXAMPLES

### Example 1

```powershell
Get-DifyKnowledge -Name "..." | Remove-DifyKnowledge
```

Delete knowledge, specifying directly from `Get-DifyKnowledge`.

### Example 2

```powershell
$KnowledgeToBeRemoved = Get-DifyKnowledge -Name "..."
Remove-DifyKnowledge -Knowledge $KnowledgeToBeRemoved
```

Delete knowledge using the result from `Get-DifyKnowledge`.

## PARAMETERS

### -Knowledge

Specifies the knowledge objects to be removed. Accepts pipeline input from another cmdlet such as `Get-DifyKnowledge`.

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

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf

Shows what would happen if the cmdlet runs. The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: False
Accept pipeline input: False
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
