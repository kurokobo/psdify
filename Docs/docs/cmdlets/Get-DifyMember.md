---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Get-DifyMember

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Retrieve workspace member information.

## SYNTAX

```powershell
Get-DifyMember [[-Id] <String[]>] [[-Name] <String[]>] [[-Email] <String[]>]
 [<CommonParameters>]
```

## DESCRIPTION

The `Get-DifyMember` cmdlet retrieves information about members in the workspace. You can filter members by their ID, name, or email address.

NOTE: This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## EXAMPLES

### Example 1

```powershell
Get-DifyMember
```

Get all members.

### Example 2

```powershell
Get-DifyMember -Id "..."
```

Get member by ID.

### Example 3

```powershell
Get-DifyMember -Name "..."
```

Get member by name.

### Example 4

```powershell
Get-DifyMember -Email "..."
```

Get member by email.

## PARAMETERS

### -Email

Specify one or more email addresses to filter the members by their email.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id

Specify one or more IDs to filter the members by their unique identifier.

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

Specify one or more names to filter the members by their name.

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
