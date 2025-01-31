---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Remove-DifyDocument

## SYNOPSIS

Deletes documents from a Dify knowledge base.

## SYNTAX

```powershell
Remove-DifyDocument [[-Document] <PSObject[]>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

The `Remove-DifyDocument` cmdlet removes specified documents from a Dify knowledge base. You can specify the documents to be removed directly, or pipe them from other cmdlets like `Get-DifyDocument`.

## EXAMPLES

### Example 1

```powershell
Get-DifyKnowledge -Name "..." | Get-DifyDocument | Remove-DifyDocument
```

Retrieve documents from a knowledge base and remove them directly.

### Example 2

```powershell
$DocumentsToBeRemoved = Get-DifyKnowledge -Name "..." | Get-DifyDocument
Remove-DifyDocument -Document $DocumentsToBeRemoved
```

Store documents in a variable before removing them.

## PARAMETERS

### -Document

Specifies the documents to be removed. This parameter accepts an array of document objects, which can be piped from other cmdlets like `Get-DifyDocument`.

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
Default value: None
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
Default value: None
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

The cmdlet uses REST API calls for document deletion. Ensure that `$env:PSDIFY_URL` and `$env:PSDIFY_CONSOLE_TOKEN` are configured properly to authenticate and specify the target Dify instance.

## RELATED LINKS
