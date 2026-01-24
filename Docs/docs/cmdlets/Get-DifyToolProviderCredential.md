---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Get-DifyToolProviderCredential

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Retrieve tool provider credential information for the current workspace.

## SYNTAX

```powershell
Get-DifyToolProviderCredential [-Provider] <String> [-Name <String>]
 [<CommonParameters>]
```

## DESCRIPTION

The `Get-DifyToolProviderCredential` cmdlet retrieves credential information for tool providers in the current workspace. The cmdlet returns list of available credentials for the specified tool provider.

## EXAMPLES

### Example 1

```powershell
Get-DifyToolProviderCredential -Provider "langgenius/openai_tool/openai"
```

Get all credentials for the specified tool provider.

## PARAMETERS

### -Name

Filter credentials by exact name match.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Provider

Specify the tool provider identifier (e.g., "langgenius/openai_tool/openai").

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
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
