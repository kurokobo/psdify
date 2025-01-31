---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Get-DifyAppTag

## SYNOPSIS

Retrieve tag information for apps.

## SYNTAX

```powershell
Get-DifyAppTag [[-Id] <String[]>] [[-Name] <String[]>]
 [<CommonParameters>]
```

## DESCRIPTION

The `Get-DifyAppTag` cmdlet retrieves tag information for apps. This is equivalent to `Get-DifyTag -Type "app"`.

## EXAMPLES

### Example 1

```powershell
Get-DifyAppTag
```

Retrieve all app tags.

### Example 2

```powershell
Get-DifyAppTag -Id "..."
```

Retrieve app tags by specifying an ID.

### Example 3

```powershell
Get-DifyAppTag -Name "..."
```

Retrieve app tags by specifying a name.

## PARAMETERS

### -Id

Specifies the IDs of the app tags to retrieve.

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

Specifies the names of the app tags to retrieve.

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
