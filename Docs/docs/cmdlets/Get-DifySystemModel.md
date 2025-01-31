---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Get-DifySystemModel

## SYNOPSIS

Retrieve system model information for the workspace.

## SYNTAX

```powershell
Get-DifySystemModel [[-Type] <String[]>] [<CommonParameters>]
```

## DESCRIPTION

The `Get-DifySystemModel` cmdlet retrieves information about the system models configured in the workspace. These models are categorized by type, such as "llm" (Large Language Model), "text-embedding", "rerank", "speech2text", and "tts". You can specify one or more types to filter the results or retrieve all available types by default.

## EXAMPLES

### Example 1

```powershell
Get-DifySystemModel
```

Get system model.

### Example 2

```powershell
Get-DifySystemModel -Type "..."
```

Get system model by type.

## PARAMETERS

### -Type

Specifies the type of system models to retrieve. Valid values are "llm", "text-embedding", "rerank", "speech2text", and "tts". If not specified, all types will be retrieved.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

This cmdlet uses the `$env:PSDIFY_CONSOLE_TOKEN` environment variable to authenticate with the Dify server. Ensure that the token is set and valid before using the cmdlet.

## RELATED LINKS
