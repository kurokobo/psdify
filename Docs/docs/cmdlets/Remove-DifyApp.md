---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Remove-DifyApp

## SYNOPSIS

Deletes specified apps from Dify.

## SYNTAX

```powershell
Remove-DifyApp [[-App] <PSObject[]>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

The `Remove-DifyApp` cmdlet deletes one or more apps from Dify. It uses the app ID to identify the apps to be removed. This cmdlet supports pipeline input, allowing you to pass app objects directly from other cmdlets like `Get-DifyApp`.

## EXAMPLES

### Example 1

```powershell
Get-DifyApp -Name "..." | Remove-DifyApp
```

Delete an app, specifying directly from `Get-DifyApp`.

### Example 2

```powershell
$AppsToBeRemoved = Get-DifyApp -Name "..."
Remove-DifyApp -App $AppsToBeRemoved
```

Delete an app using the result from `Get-DifyApp`.

## PARAMETERS

### -App

Specifies the app or apps to be deleted. This parameter accepts an array of app objects, which can be obtained using the `Get-DifyApp` cmdlet.

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

- Ensure you have sufficient permissions to delete the apps.
- Be cautious when running this cmdlet, especially with bulk operations, as it permanently removes apps.

## RELATED LINKS
