---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# New-DifyToolProviderCredential

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Create a new credential for a tool provider.

## SYNTAX

```powershell
New-DifyToolProviderCredential [-Provider] <String> [-Credential] <Hashtable> [[-AuthorizationName] <String>]
 [<CommonParameters>]
```

## DESCRIPTION

The `New-DifyToolProviderCredential` cmdlet creates a new API key credential for a tool provider in the current workspace. Currently, only API Key type credentials are supported. The cmdlet returns the newly created credential for the specified tool provider.

## EXAMPLES

### Example 1

```powershell
New-DifyToolProviderCredential -Provider "langgenius/openai_tool/openai" -Credential @{
    "openai_api_key" = "sk-proj-..."
}
```

Create a new credential with an automatically generated name.

### Example 2

```powershell
New-DifyToolProviderCredential -Provider "langgenius/openai_tool/openai" -Credential @{
    "openai_api_key" = "sk-proj-..."
} -AuthorizationName "Production Key"
```

Create a new credential with a custom name.

## PARAMETERS

### -AuthorizationName

Specify the name for the credential. If not specified, the cmdlet automatically generates a name in the format "API KEY N" where N is an incremented number.

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

### -Credential

Specify the credential information as a hashtable. The required keys depend on the tool provider. For example, OpenAI Tool requires `openai_api_key`.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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
