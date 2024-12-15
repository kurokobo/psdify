function Add-DifyDocument {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject[]] $Item = @(),
        [String[]] $Path = @(),
        [PSCustomObject] $Knowledge,
        [String] $ChunkMode = "automatic",
        [String] $IndexMode = "high_quality",
        [PSCustomObject] $EmbeddingModel = $null,
        [String] $RetrievalMode = "semantic_search",
        [Switch] $Wait = $false,
        [Int] $Interval = 5,
        [Int] $Timeout = 300
    )

    begin {
        $Files = @()
    }

    process {
        foreach ($ItemObject in $Item) {
            $Files += $ItemObject
        }
    }
    end {
        if (-not $Files -and -not $Path) {
            throw "Path is required"
        }
        if ($Path) {
            $Files += Get-ChildItem -Path $Path
        }

        if (-not $Knowledge) {
            throw "Knowledge is required"
        }
        if (@($Knowledge).Count -gt 1) {
            throw "Only one knowledge can be specified"
        }

        $ValidChunkModes = @("automatic", "custom")
        if (-not $ValidChunkModes.Contains($ChunkMode)) {
            throw "Invalid value for ChunkMode. Must be one of: $($ValidChunkModes -join ', ')"
        }
        $ValidIndexModes = @("high_quality", "economy")
        if (-not $ValidIndexModes.Contains($IndexMode)) {
            throw "Invalid value for IndexMode. Must be one of: $($ValidIndexModes -join ', ')"
        }
        $ValidRetrievalModes = @("semantic_search", "full_text_search", "hybrid_search")
        if (-not $ValidRetrievalModes.Contains($RetrievalMode)) {
            throw "Invalid value for RetrievalMode. Must be one of: $($ValidRetrievalModes -join ', ')"
        }

        # not implemented
        if ($ChunkMode -eq "custom") {
            throw "ChunkMode: custom is not implemented"
        }
        if ($RetrievalMode -eq "full_text_search") {
            throw "RetrievalMode: full_text_search is not implemented"
        }
        if ($RetrievalMode -eq "hybrid_search") {
            throw "RetrievalMode: hybrid_search is not implemented"
        }

        # set embedding model
        $DefaultEmbeddingModel = Get-DifySystemModel -Type "text-embedding"
        if ($IndexMode -eq "high_quality" -and -not $DefaultEmbeddingModel -and -not $EmbeddingModel) {
            throw "Model is required for IndexMode: high_quality"
        }
        if ($IndexMode -eq "high_quality" -and -not $EmbeddingModel) {
            $EmbeddingModel = $DefaultEmbeddingModel
        }

        # upload files
        $UploadedFiles = Add-DifyFile -Path $Files -Source "datasets"
        $UploadedFileIds = $UploadedFiles | Select-Object -ExpandProperty Id

        # add document
        $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/datasets", $Knowledge.Id, "/documents")
        $Method = "POST"
        $Body = @{"data_source"        = @{ 
                "type"      = "upload_file"
                "info_list" = @{ 
                    "data_source_type" = "upload_file"
                    "file_info_list"   = @{ 
                        "file_ids" = @($UploadedFileIds)
                    } 
                } 
            }
            "indexing_technique"       = $IndexMode
            "process_rule"             = @{ 
                "rules" = @{}
                "mode"  = $ChunkMode
            }
            "doc_form"                 = "text_model"
            "doc_language"             = "English"
            "retrieval_model"          = @{ 
                "search_method"           = $RetrievalMode
                "reranking_enable"        = $false
                "reranking_mode"          = $null
                "reranking_model"         = @{ 
                    "reranking_provider_name" = $null
                    "reranking_model_name"    = $null
                }
                "weights"                 = $null
                "top_k"                   = 3
                "score_threshold_enabled" = $false
                "score_threshold"         = 0
            }
            "embedding_model"          = $EmbeddingModel.Model
            "embedding_model_provider" = $EmbeddingModel.Provider
        } | ConvertTo-Json -Depth 10
        try {
            $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body -Token $env:PSDIFY_CONSOLE_TOKEN
        }
        catch {
            throw "Failed to add documents to knowledge: $_"
        }

        if (-not $Response.documents) {
            throw "Failed to add documents to knowledge"
        }

        $Documents = @()
        foreach ($Document in $Response.documents) {
            $CreatedBy = $Members | Where-Object { $_.Id -eq $Document.created_by } | Select-Object -ExpandProperty Email
            if (-not $CreatedBy) {
                $CreatedBy = $Document.created_by
            }
            $UploadedBy = $Members | Where-Object { $_.Id -eq $Document.data_source_detail_dict.upload_file.created_by } | Select-Object -ExpandProperty Email
            if (-not $UploadedBy) {
                $UploadedBy = $Document.data_source_detail_dict.upload_file.created_by
            }
            $DocumentObject = [PSCustomObject]@{
                Batch          = $Response.batch
                KnowledgeId    = $Knowledge.Id
                Id             = $Document.id
                Name           = $Document.name
                DataSourceType = $Document.data_source_type
                WordCount      = $Document.word_count
                HitCount       = $Document.hit_count
                IndexingStatus = $Document.indexing_status
                Enabled        = $Document.enabled
                Archived       = $Document.archived
                CreatedBy      = $CreatedBy
                CreatedAt      = Convert-UnixTimeToLocalDateTime($Document.created_at)
                UploadedBy     = $UploadedBy
                UploadedAt     = Convert-UnixTimeToLocalDateTime($Document.data_source_detail_dict.upload_file.created_at)
            }
            $Documents += $DocumentObject
        }

        if ($Wait) {
            $null = Get-DifyDocumentIndexingStatus -Document $Documents -Wait -Interval $Interval -Timeout $Timeout
            $UpdatedAllDocuments = Get-DifyDocument -Knowledge $Knowledge
            $UpdatedDocuments = @()
            foreach ($Document in $Documents) {
                $UpdatedDocuments += $UpdatedAllDocuments | Where-Object { $_.Id -eq $Document.Id }
            }
            return $UpdatedDocuments
        }
        else {
            return $Documents
        }
    }
}
