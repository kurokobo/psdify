---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Add-DifyDocument

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Uploads documents to a specified knowledge in Dify, with options for chunking, indexing, and waiting for indexing to complete.

## SYNTAX

```powershell
Add-DifyDocument [[-Item] <PSObject[]>] [[-Path] <String[]>] [[-Knowledge] <PSObject>] [[-ChunkMode] <String>]
 [[-IndexMode] <String>] [[-EmbeddingModel] <PSObject>] [[-RetrievalMode] <String>] [-Wait]
 [[-Interval] <Int32>] [[-Timeout] <Int32>] [<CommonParameters>]
```

## DESCRIPTION

The `Add-DifyDocument` cmdlet allows users to upload documents to a specified Knowledge in Dify. It supports various options such as chunking mode, indexing mode, embedding models, and retrieval modes. Users can also wait for the indexing process to complete with a customizable interval and timeout.

Currently, detailed configuration is not implemented.

NOTE: This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## EXAMPLES

### Example 1

```powershell
$Knowledge = Get-DifyKnowledge -Name "My New Knowledge"
Add-DifyDocument -Knowledge $Knowledge -Path "Docs/*.md"
```

Upload documents by specifying file paths, supports wildcards and multiple paths.

### Example 2

```powershell
$Knowledge = Get-DifyKnowledge -Name "My New Knowledge"
Get-Item -Path "Docs/*.md" | Add-DifyDocument -Knowledge $Knowledge
```

Upload documents by specifing files from Get-Item or Get-ChildItem via pipe.

### Example 3

```powershell
$Knowledge = Get-DifyKnowledge -Name "My New Knowledge"
Add-DifyDocument -Knowledge $Knowledge -Path "Docs/*.md" -ChunkMode "custom"
```

Upload documents with specifying chunk settings.

### Example 4

```powershell
$Knowledge = Get-DifyKnowledge -Name "My New Knowledge"
$EmbeddingModel = Get-DifyModel -Provider "openai" -Name "text-embedding-3-small"
Add-DifyDocument -Knowledge $Knowledge -Path "Docs/*.md" -IndexMode "high_quality" -Model $EmbeddingModel
```

Upload documents with specifying embedding model.

### Example 5

```powershell
$Knowledge = Get-DifyKnowledge -Name "My New Knowledge"
Add-DifyDocument -Knowledge $Knowledge -Path "Docs/*.md" -IndexMode "economy"
```

Upload documents with specifying indexing mode.

### Example 6

```powershell
$Knowledge = Get-DifyKnowledge -Name "My New Knowledge"
Add-DifyDocument -Knowledge $Knowledge -Path "Docs/*.md" -Wait
```

Wait for indexing to complete.

### Example 7

```powershell
$Knowledge = Get-DifyKnowledge -Name "My New Knowledge"
Add-DifyDocument -Knowledge $Knowledge -Path "Docs/*.md" -Wait -Interval 10 -Timeout 600
```

Custom wait settings.

## PARAMETERS

### -ChunkMode

Defines the chunking mode for document processing. Valid values are:

- "automatic" (default): Automatically determines chunking rules.
- "custom": Allows specifying custom chunking rules.

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

### -EmbeddingModel

Specifies the embedding model to use for high-quality indexing. If omitted, the system's default embedding model is used.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IndexMode

Determines the indexing mode for documents. Valid values are:

- "high_quality" (default): Uses advanced embedding models.
- "economy": Uses a less resource-intensive indexing method.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Interval

Specifies the interval (in seconds) to wait between indexing status checks when `-Wait` is used.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Item

Specifies the document objects to upload. Accepts objects from the pipeline.

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

### -Knowledge

Specifies the knowledge base to which the documents will be uploaded. Only one knowledge base can be specified.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path

Specifies the file paths of the documents to upload. Supports wildcards and multiple paths.

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

### -RetrievalMode

Defines the retrieval mode for document search. Valid values are:

- "semantic_search" (default): Uses semantic search.
- "full_text_search": Not yet implemented.
- "hybrid_search": Not yet implemented.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Timeout

Specifies the maximum time (in seconds) to wait for indexing completion when `-Wait` is used.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Wait

Indicates whether to wait for indexing to complete before returning.

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

### System.Management.Automation.PSObject[]

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
