---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Send-DifyChatMessage

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Sends chat messages to the app and displays the response in the console.

## SYNTAX

```powershell
Send-DifyChatMessage [-NewSession] [[-Message] <String>] [[-Inputs] <Hashtable>]
 [<CommonParameters>]
```

## DESCRIPTION

The `Send-DifyChatMessage` cmdlet allows users to send chat messages to a Dify app. It requires environment variables `$env:PSDIFY_APP_URL` (URL of the Dify API server) and `$env:PSDIFY_APP_TOKEN` (application token) to function. The cmdlet starts a new conversation if `-NewSession` is specified. It also logs the conversation and response in the `Logs` folder.

NOTE: This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## EXAMPLES

### Example 1

```powershell
$env:PSDIFY_APP_URL = "https://dify.example.com"
$env:PSDIFY_APP_TOKEN = "app-****************"
```

Set environment variables for Dify.

### Example 2

```powershell
Send-DifyChatMessage -Message "Hello, Dify!"
```

Send chat messages.

### Example 3

```powershell
Send-DifyChatMessage -Message "Hello, Dify!" -NewSession
```

Send chat messages and start a new session.

## PARAMETERS

### -Inputs

Specifies additional inputs to be sent with the chat message.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Message

Specifies the message to be sent to the app.

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

### -NewSession

Indicates that a new conversation session should be started.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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
