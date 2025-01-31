---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Get-DifyDocument

## SYNOPSIS

Retrieve document information in knowledge.

## SYNTAX

```powershell
Get-DifyDocument [[-Knowledge] <PSObject>] [[-Id] <String>] [[-Name] <String>] [[-Search] <String>]
 [<CommonParameters>]
```

## DESCRIPTION

The `Get-DifyDocument` cmdlet retrieves document information associated with a specified knowledge object. You can filter documents by ID, name, or search keyword. This cmdlet can return all documents for a given knowledge object or specific documents based on the provided parameters.

## EXAMPLES

### Example 1

```powershell
Get-DifyKnowledge -Name "..." | Get-DifyDocument
```

Get all documents, specifying directly from `Get-DifyKnowledge`.

### Example 2

```powershell
$Knowledge = Get-DifyKnowledge -Name "..."
Get-DifyDocument -Knowledge $Knowledge
```

Get all documents using the result from `Get-DifyKnowledge`.

### Example 3

```powershell
Get-DifyKnowledge -Name "..." | Get-DifyDocument -Id "..."
```

Get documents by ID.

### Example 4

```powershell
Get-DifyKnowledge -Name "..." | Get-DifyDocument -Name "..."
```

Get documents by name (complete match).

### Example 5

```powershell
Get-DifyKnowledge -Name "..." | Get-DifyDocument -Search "..."
```

Get documents by name (partial match).

## PARAMETERS

### -Id

Specifies the ID of the document to retrieve. If this parameter is provided, only the document with the matching ID will be returned.

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

### -Knowledge

Specifies the knowledge object from which to retrieve documents. This parameter supports pipeline input.

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

### -Name

Specifies the name of the document to retrieve. Only documents with a name that exactly matches the specified value will be returned.

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

### -Search

Specifies a keyword to search for documents. Documents with names that contain the specified keyword will be returned.

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

### System.Management.Automation.PSObject

## OUTPUTS

### System.Object

## NOTES

Ensure that the `$env:PSDIFY_URL` and `$env:PSDIFY_CONSOLE_TOKEN` environment variables are set correctly before using this cmdlet. These variables are required for successful API communication with the Dify instance.

## RELATED LINKS
