---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# New-DifyMember

## SYNOPSIS

Add (invite) a new member to the workspace.

## SYNTAX

```powershell
New-DifyMember [[-Email] <String>] [[-Role] <String>] [[-Language] <String>]
 [<CommonParameters>]
```

## DESCRIPTION

The `New-DifyMember` cmdlet allows you to invite a new member to the workspace by specifying their email address, role, and preferred language for the invitation. The user will receive an invitation link to join the workspace.

## EXAMPLES

### Example 1

```powershell
New-DifyMember -Email "dify@example.com" -Role "normal" -Language "en-US"
```

Invite a new member with the email `dify@example.com` and assign them the role `normal`. The invitation will be sent in English (`en-US`).

## PARAMETERS

### -Email

Specifies the email address of the user to be invited.

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

### -Language

Specifies the language of the invitation. The default value is `en-US`.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Role

Specifies the role of the invited member. Valid values are `admin`, `editor`, and `normal`. The default value is `normal`.

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

### None

## OUTPUTS

### System.Object

## NOTES

- If the role specified is invalid, the cmdlet will throw an error.
- The invitation link for the user will be appended to the returned member object.

## RELATED LINKS
