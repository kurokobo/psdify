---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Remove-DifyToolProviderCredential

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Remove credentials from a tool provider.

## SYNTAX

```powershell
Remove-DifyToolProviderCredential [[-Credential] <PSObject[]>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

The `Remove-DifyToolProviderCredential` cmdlet removes one or more credentials from a tool provider in the current workspace. You can specify the credentials to be removed directly or pipe them from the `Get-DifyToolProviderCredential` cmdlet. This cmdlet supports confirmation prompts and the `WhatIf` parameter to preview the changes before applying them.

## EXAMPLES

### Example 1

```powershell
Get-DifyToolProviderCredential -Provider "langgenius/openai_tool/openai" | Remove-DifyToolProviderCredential
```

Remove all credentials from the specified tool provider.

### Example 2

```powershell
$CredentialsToBeRemoved = Get-DifyToolProviderCredential -Provider "langgenius/openai_tool/openai"
Remove-DifyToolProviderCredential -Credential $CredentialsToBeRemoved
```

Remove credentials using the result from `Get-DifyToolProviderCredential`.

### Example 3

```powershell
Get-DifyToolProviderCredential -Provider "langgenius/openai_tool/openai" | Select-Object -First 1 | Remove-DifyToolProviderCredential
```

Remove a specific credential by selecting it first.

## PARAMETERS

### -Credential

Specifies the credentials to be removed. Accepts a list of objects which can be retrieved by `Get-DifyToolProviderCredential`. This parameter accepts pipeline input.

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

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

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

## RELATED LINKS
