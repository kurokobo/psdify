---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Remove-DifyMember

## SYNOPSIS

Remove members from the workspace.

## SYNTAX

```powershell
Remove-DifyMember [[-Member] <PSObject[]>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

The `Remove-DifyMember` cmdlet removes one or more members from the current workspace. You can specify the members to be removed directly or pipe them from the `Get-DifyMember` cmdlet. This cmdlet supports confirmation prompts and the `WhatIf` parameter to preview the changes before applying them.

## EXAMPLES

### Example 1

```powershell
Get-DifyMember -Name "..." | Remove-DifyMember
```

Remove members, specifying directly from `Get-DifyMember`.

### Example 2

```powershell
$MembersToBeRemoved = Get-DifyMember -Name "..."
Remove-DifyMember -Member $MembersToBeRemoved
```

Remove members using the result from `Get-DifyMember`.

## PARAMETERS

### -Member

Specifies the members to be removed. Accepts a list of `PSCustomObject` objects representing the members. This parameter accepts pipeline input.

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

- This cmdlet requires a valid Dify URL and authentication token to operate.
- The `Remove-DifyMember` cmdlet is irreversible. Ensure you have specified the correct member(s) before executing.

## RELATED LINKS
