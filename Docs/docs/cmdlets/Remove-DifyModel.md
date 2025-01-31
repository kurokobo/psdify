---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Remove-DifyModel

## SYNOPSIS

Removes predefined or customizable models from the workspace.

## SYNTAX

```powershell
Remove-DifyModel [[-Model] <PSObject[]>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

The `Remove-DifyModel` cmdlet allows you to delete models from the workspace. It supports both predefined models (removed by provider) and customizable models (removed by model name and type). The cmdlet uses the `ShouldProcess` feature to confirm the deletion of models, providing safety prompts for potentially impactful actions.

## EXAMPLES

### Example 1

```powershell
Get-DifyModel -Name "..." | Remove-DifyModel
```

Delete models, specifying directly from `Get-DifyModel`.

### Example 2

```powershell
$ModelsToBeRemoved = Get-DifyModel -Name "..."
Remove-DifyModel -Model $ModelsToBeRemoved
```

Delete models using the result from `Get-DifyModel`.

## PARAMETERS

### -Model

Specifies the models to be removed. This parameter accepts objects that represent models, which can be obtained from the `Get-DifyModel` cmdlet.

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

- The `Remove-DifyModel` cmdlet ensures safe deletion by implementing `ShouldProcess` and `ConfirmImpact`.
- Predefined models are removed by their provider, while customizable models require both the model name and type to be specified.
- The environment variable `$env:PSDIFY_CONSOLE_TOKEN` is required for authentication.

## RELATED LINKS
