---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Wait-Dify

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Waits for the Dify instance to become ready.

## SYNTAX

```powershell
Wait-Dify [[-Server] <String>] [[-Interval] <Int32>] [[-Timeout] <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION

The `Wait-Dify` cmdlet waits for the Dify instance to become ready. It polls the specified server at regular intervals until it is ready or the timeout is exceeded. This is useful for scenarios where you need to ensure the Dify instance is operational before proceeding with other operations.

NOTE: This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## EXAMPLES

### Example 1

```powershell
Wait-Dify -Server "https://dify.example.com"
```

Wait for the Dify instance at `\<https://dify.example.com\>` to be ready.

### Example 2

```powershell
Wait-Dify -Server "https://dify.example.com" -Interval 5 -Timeout 300
```

Wait for the Dify instance at `\<https://dify.example.com\>` to be ready, specifying an interval of 5 seconds and a maximum timeout of 300 seconds.

## PARAMETERS

### -Interval

Specifies the interval, in seconds, between each poll to check if the Dify instance is ready.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 5
Accept pipeline input: False
Accept wildcard characters: False
```

### -Server

Specifies the URL of the Dify server to check. If the `$env:PSDIFY_URL` environment variable is set, this parameter is optional.

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

### -Timeout

Specifies the maximum time, in seconds, to wait for the Dify instance to become ready. If the timeout is exceeded, the cmdlet throws an error.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 300
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
