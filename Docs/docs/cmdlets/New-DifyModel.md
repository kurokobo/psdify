---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# New-DifyModel

## SYNOPSIS

Creates a new model in the workspace, either predefined or customizable, depending on the specified parameters.

## SYNTAX

```powershell
New-DifyModel [[-Provider] <String>] [[-From] <String>] [[-Name] <String>] [[-Type] <String>]
 [[-Credential] <Hashtable>] [<CommonParameters>]
```

## DESCRIPTION

The `New-DifyModel` cmdlet allows you to add new models to the workspace. The credentials required depend on the provider and the model. You can choose between predefined models and customizable models. For customizable models, additional details such as model name, type, and credentials must be specified.

## EXAMPLES

### Example 1

```powershell
New-DifyModel -Provider "openai" -From "predefined" `
  -Credential @{
    "openai_api_key" = "sk-proj-****************"
  }
```

Add predefined models (example for OpenAI).

### Example 2

```powershell
New-DifyModel -Provider "openai" -From "customizable" `
  -Type "llm" -Name "gpt-4o-mini" `
  -Credential @{
    "openai_api_key" = "sk-proj-****************"
  }
```

Add customizable models (example for OpenAI).

## PARAMETERS

### -Credential

Specifies the credentials required for the model. The credential format depends on the provider and the model configuration.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -From

Specifies the source type of the model. Possible values are "predefined" or "customizable".

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

Specifies the name of the model. This is required for customizable models.

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

Specifies the provider (e.g., "openai", "cohere") for the model.

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

Specifies the type of the model for customizable models. Valid values include "llm", "text-embedding", "speech2text", "moderation", and "tts".

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
