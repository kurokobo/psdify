---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Get-DifyDocumentIndexingStatus

## SYNOPSIS

Retrieve document indexing status.

## SYNTAX

```powershell
Get-DifyDocumentIndexingStatus [[-Document] <PSObject>] [[-Knowledge] <PSObject>] [[-Batch] <String>] [-Wait]
 [[-Interval] <Int32>] [[-Timeout] <Int32>] [<CommonParameters>]
```

## DESCRIPTION

This cmdlet retrieves the indexing status of documents within a specified knowledge base or batch. It can also wait for the indexing process to complete based on the `-Wait` parameter. By default, the cmdlet checks and retrieves the indexing status without waiting.

## EXAMPLES

### Example 1

```powershell
Add-DifyDocument -Knowledge $Knowledge -Path "Docs/*.md" | Get-DifyDocumentIndexingStatus
```

Get indexing status (specify directly from Add-DifyDocument).

### Example 2

```powershell
$DocumentToCheckIndexingStatus = Add-DifyDocument -Knowledge $Knowledge -Path "Docs/*.md"
Get-DifyDocumentIndexingStatus -Document $DocumentToCheckIndexingStatus
```

Get indexing status (specify from Add-DifyDocument result).

### Example 3

```powershell
Get-DifyDocumentIndexingStatus -Knowledge $Knowledge -Batch "..."
```

Get indexing status (specify knowledge and batch ID).

### Example 4

```powershell
Get-DifyDocumentIndexingStatus -Knowledge $Knowledge -Batch "..." -Wait
```

Get indexing status (wait for completion).

### Example 5

```powershell
Get-DifyDocumentIndexingStatus -Knowledge $Knowledge -Batch "..." -Wait -Interval 10 -Timeout 600
```

Get indexing status (change waiting time).

## PARAMETERS

### -Batch

Specifies the batch ID for which to retrieve the indexing status. This is required if no documents are provided.

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

### -Document

Specifies the document object(s) to retrieve the indexing status for. If provided, the knowledge and batch are inferred from the document metadata.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Interval

Specifies the interval, in seconds, at which the cmdlet checks the indexing status when the `-Wait` parameter is used.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 5
Accept pipeline input: False
Accept wildcard characters: False
```

### -Knowledge

Specifies the knowledge object for which to retrieve the indexing status. This is required if no documents are provided.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Timeout

Specifies the timeout duration, in seconds, for the wait operation when the `-Wait` parameter is used.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 300
Accept pipeline input: False
Accept wildcard characters: False
```

### -Wait

Indicates that the cmdlet should wait for the indexing process to complete before returning.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Management.Automation.PSObject

## OUTPUTS

### System.Object

## NOTES

This cmdlet is useful for monitoring and managing the indexing process of documents within the Dify environment. Ensure proper use of environment variables like `$env:PSDIFY_URL` and `$env:PSDIFY_CONSOLE_TOKEN` for authentication and API interaction.

## RELATED LINKS
