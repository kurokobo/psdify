---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Set-DifySystemModel

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Set the default system model for the workspace.

## SYNTAX

```powershell
Set-DifySystemModel [[-Model] <PSObject[]>] [[-Type] <String>] [[-Provider] <String>] [[-Name] <String>]
 [<CommonParameters>]
```

## DESCRIPTION

The `Set-DifySystemModel` cmdlet configures the default system model for the workspace. It can take a model object from the pipeline or specify the type, provider, and name directly. This allows granular control over the system model used for different functionalities like LLM, text embedding, speech-to-text, and more.

The cmdlet validates the input parameters to ensure they conform to the supported model types and providers.

NOTE: This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## EXAMPLES

### Example 1

```powershell
Set-DifySystemModel -Type "llm" -Provider "openai" -Name "gpt-4o-mini"
```

Set the system model for "llm" using the OpenAI "gpt-4o-mini" model by directly specifying parameters.

### Example 2

```powershell
Get-DifySystemModel -Type "llm" -Provider "openai" -Name "gpt-4o-mini" | Set-DifySystemModel
```

Set the system model using the result from `Get-DifySystemModel`.

### Example 3

```powershell
$SystemModelToBeChanged = Get-DifySystemModel -Type "llm" -Provider "openai" -Name "gpt-4o-mini"
Set-DifySystemModel -Model $SystemModelToBeChanged
```

Set the system model by passing a model object.

## PARAMETERS

### -Model

Specifies the model object(s) to configure as the default system model. It can be passed directly via the pipeline.

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

### -Name

Specifies the name of the model to set as the default system model. This is required if no model object is provided.

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

### -Provider

Specifies the provider of the model to set as the default system model. This is required if no model object is provided.

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

### -Type

Specifies the type of the model. Valid values are: "llm", "text-embedding", "rerank", "speech2text", "tts". This is required if no model object is provided.

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

## RELATED LINKS
