function Get-DifyKnowledge {
    [CmdletBinding()]
    param(
        [String] $Id = "",
        [String] $Name = "",
        [String] $Search = "",
        [String[]] $Tags = @(),
        [Switch] $IncludeAll = $false
    )

    $Query = @{
        "page"  = 1
        "limit" = 100
    }
    if ($Search) {
        $Query.keyword = $Search
    }
    if ($Tags) {
        $QueryTags = Get-DifyKnowledgeTag -Name $Tags
        $QueryTagString = ($QueryTags | ForEach-Object { "tag_ids=$($_.Id)" }) -join "&"
    }
    if ($IncludeAll) {
        $Query["include_all"] = "true"
    }

    $Members = Get-DifyMember

    $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/datasets")
    $Method = "GET"
    $Knowledges = @()
    $HasMore = $true
    while ($HasMore) {
        try {
            $QueryString = ($Query.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "&"
            if ($QueryTagString) {
                $QueryString += "&$QueryTagString"
            }
            $Uri = "$($Endpoint)?$($QueryString)"
            $Response = Invoke-DifyRestMethod -Uri $Uri -Method $Method -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
        }
        catch {
            throw "Failed to obtain knowledges: $_"
        }

        foreach ($Knowledge in $Response.data) {
            $KnowledgeTags = @()
            foreach ($Tag in $Knowledge.tags) {
                $KnowledgeTags += $Tag.name
            }
            $CreatedBy = $Members | Where-Object { $_.Id -eq $Knowledge.created_by } | Select-Object -ExpandProperty Email
            if (-not $CreatedBy) {
                $CreatedBy = $Knowledge.created_by
            }
            $UpdatedBy = $Members | Where-Object { $_.Id -eq $Knowledge.updated_by } | Select-Object -ExpandProperty Email
            if (-not $UpdatedBy) {
                $UpdatedBy = $Knowledge.updated_by
            }
            $KnowledgeObject = [PSCustomObject]@{
                Id            = $Knowledge.id
                Name          = $Knowledge.name
                Description   = $Knowledge.description
                Permission    = $Knowledge.permission
                AppCount      = $Knowledge.app_count
                DocumentCount = $Knowledge.document_count
                WordCount     = $Knowledge.word_count
                CreatedBy     = $CreatedBy
                CreatedAt     = Convert-UnixTimeToLocalDateTime($Knowledge.created_at)
                UpdatedBy     = $UpdatedBy
                UpdatedAt     = Convert-UnixTimeToLocalDateTime($Knowledge.updated_at)
                Tags          = $KnowledgeTags
            }
            if ($Id -and $KnowledgeObject.Id -eq $Id) {
                return $KnowledgeObject
            }
            $Knowledges += $KnowledgeObject
        }

        $HasMore = $Response.has_more
        $Query.page++
    }

    if ($Name) {
        $Knowledges = $Knowledges | Where-Object { $_.Name -eq $Name }
    }

    return $Knowledges
}
