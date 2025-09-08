---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Get-DifyModelProviderCredential

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Retrieve model provider credential information for the current workspace.

## SYNTAX

```powershell
Get-DifyModelProviderCredential [[-Provider] <String>] [[-From] <String>] [[-Name] <String>] [[-Type] <String>]
 [<CommonParameters>]
```

## DESCRIPTION

The `Get-DifyModelProviderCredential` cmdlet retrieves credential information for model providers in the current workspace. You can filter credentials by provider, model type, model name, and credential type (predefined or customizable). The cmdlet returns list of available credentials.

## EXAMPLES

### Example 1

```powershell
Get-DifyModelProviderCredential
```

Get all model provider credentials.

### Example 2

```powershell
Get-DifyModelProviderCredential -Provider "langgenius/openai/openai"
```

Get credentials for the specified provider.

### Example 3

```powershell
Get-DifyModelProviderCredential -From "customizable"
```

Get credentials for customizable models only.

### Example 4

```powershell
Get-DifyModelProviderCredential -Name "gpt-4.1-nano"
```

Get credentials for a specific model name.

### Example 5

```powershell
Get-DifyModelProviderCredential -Type "llm"
```

Get credentials for a specific model type.

## PARAMETERS

### -From

Specify the source type of the credential. Valid values are "predefined" and "customizable".

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

### -Name

Filter credentials by model name.

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

### -Provider

Filter credentials by provider name.

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

### -Type

Filter credentials by model type. Valid values are "llm", "text-embedding", "speech2text", "moderation", "tts", and "rerank".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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
