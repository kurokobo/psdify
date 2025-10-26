function Get-DifyDocument {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject] $Knowledge,
        [String] $Id = "",
        [String] $Name = "",
        [String] $Search = ""
    )

    begin {
        $Knowledges = @()
    }
    
    process {
        foreach ($KnowledgeObject in $Knowledge) {
            $Knowledges += $KnowledgeObject
        }
    }

    end {
        if (-not $Knowledges) {
            throw "Knowledge is required"
        }
        if ($Knowledges.Count -gt 1) {
            throw "Only one knowledge is allowed"
        }

        $Query = @{
            "page"  = 1
            "limit" = 100
        }
        if ($Search) {
            $Query.keyword = $Search
        }

        $Members = Get-DifyMember

        $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/datasets", $Knowledge.Id, "/documents")
        $Method = "GET"
        $Documents = @()
        $HasMore = $true
        while ($HasMore) {
            try {
                $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Query $Query -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
            }
            catch {
                throw "Failed to obtain documents: $_"
            }

            foreach ($Document in $Response.data) {
                $CreatedBy = $Members | Where-Object { $_.Id -eq $Document.created_by } | Select-Object -ExpandProperty Email
                if (-not $CreatedBy) {
                    $CreatedBy = $Document.created_by
                }
                $UploadedBy = $Members | Where-Object { $_.Id -eq $Document.data_source_detail_dict.upload_file.created_by } | Select-Object -ExpandProperty Email
                if (-not $UploadedBy) {
                    $UploadedBy = $Document.data_source_detail_dict.upload_file.created_by
                }
                $DocumentObject = [PSCustomObject]@{
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
                if ($Id -and $DocumentObject.Id -eq $Id) {
                    return $DocumentObject
                }
                $Documents += $DocumentObject
            }

            $HasMore = $Response.has_more
            $Query.page++
        }

        if ($Name) {
            $Documents = $Documents | Where-Object { $_.Name -eq $Name }
        }

        return $Documents
    }
}
