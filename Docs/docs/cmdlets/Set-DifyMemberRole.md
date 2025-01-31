---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Set-DifyMemberRole

## SYNOPSIS

Change a member's role in the workspace.

## SYNTAX

```powershell
Set-DifyMemberRole [[-Member] <PSObject[]>] [[-Role] <String>]
 [<CommonParameters>]
```

## DESCRIPTION

The `Set-DifyMemberRole` cmdlet changes the role of one or more members in the workspace. The available roles are:

- `normal`
- `editor`
- `admin`

If the specified role is invalid, an error will be thrown. This cmdlet requires the Dify API token to be set in the `$env:PSDIFY_CONSOLE_TOKEN` environment variable.

## EXAMPLES

### Example 1

```powershell
Get-DifyMember -Name "John Doe" | Set-DifyMemberRole -Role "editor"
```

This example retrieves the member `John Doe` using `Get-DifyMember` and changes their role to `editor`.

## PARAMETERS

### -Member

Specifies the member or members whose role will be changed. Accepts objects from the pipeline.

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

### -Role

Specifies the new role to assign to the members. Valid values are:

- `normal`
- `editor`
- `admin`

If an invalid role is provided, an error will be thrown.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Management.Automation.PSObject[]

## OUTPUTS

### System.Object

## NOTES

- Ensure the `$env:PSDIFY_CONSOLE_TOKEN` environment variable is properly set before using this cmdlet.
- The cmdlet throws an error if the role change fails.

## RELATED LINKS
