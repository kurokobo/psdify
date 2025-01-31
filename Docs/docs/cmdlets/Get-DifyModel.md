---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Get-DifyModel

## SYNOPSIS

Retrieve workspace model information.

## SYNTAX

```powershell
Get-DifyModel [[-Provider] <String[]>] [[-From] <String[]>] [[-Name] <String[]>] [[-Type] <String[]>] [-Active]
 [-NoConfigure] [<CommonParameters>]
```

## DESCRIPTION

The `Get-DifyModel` cmdlet retrieves information about models available in the workspace. You can filter the models by provider, type, name, and other criteria. It supports retrieving both predefined and customizable models. The cmdlet provides details about model providers, types, and their current status.

## EXAMPLES

### Example 1

```powershell
Get-DifyModel
```

Get all models.

### Example 2

```powershell
Get-DifyModel -Provider "..."
```

Get models by provider.

### Example 3

```powershell
Get-DifyModel -From "..."
```

Get models by configuration type.

### Example 4

```powershell
Get-DifyModel -Name "..."
```

Get models by name.

### Example 5

```powershell
Get-DifyModel -Type "..."
```

Get models by model type.

### Example 6

```powershell
Get-DifyModel -Provider "..." -Type "llm"
```

Combine filters to get models.

## PARAMETERS

### -Active

Filter models to retrieve only those with an "active" status.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -From

Specify the source type of the model. Valid values are "predefined" and "customizable".

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

### -Name

Filter models by their name.

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

### -NoConfigure

Filter models to retrieve only those with a "no-configure" status.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Provider

Filter models by provider.

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

### -Type

Filter models by their type. Valid values are "llm", "text-embedding", "speech2text", "moderation", "tts", and "rerank".

```yaml
Type: String[]
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

This cmdlet retrieves and processes data about models configured in the Dify workspace. The retrieved information can be used for further operations such as adding, modifying, or removing models.

## RELATED LINKS
