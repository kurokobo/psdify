function New-DifyKnowledge {
    [CmdletBinding()]
    param(
        [String] $Name,
        [String] $Description = ""
    )

    if (-not $Name) {
        throw "Name is required"
    }

    $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/datasets")
    $Method = "POST"
    $Body = @{
        "name"        = $Name
        "description" = $Description
    } | ConvertTo-Json
    try {
        $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body -Token $env:PSDIFY_CONSOLE_TOKEN
    }
    catch {
        throw "Failed to create knowledge: $_"
    }

    if (-not $Response.id) {
        throw "Failed to create knowledge"
    }

    $Members = Get-DifyMember

    $KnowledgeTags = @()
    foreach ($Tag in $Response.tags) {
        $KnowledgeTags += $Tag.name
    }
    $CreatedBy = $Members | Where-Object { $_.Id -eq $Response.created_by } | Select-Object -ExpandProperty Email
    if (-not $CreatedBy) {
        $CreatedBy = $Response.created_by
    }
    $UpdatedBy = $Members | Where-Object { $_.Id -eq $Response.updated_by } | Select-Object -ExpandProperty Email
    if (-not $UpdatedBy) {
        $UpdatedBy = $Response.updated_by
    }
    $KnowledgeObject = [PSCustomObject]@{
        Id            = $Response.id
        Name          = $Response.name
        Description   = $Response.description
        Permission    = $Response.permission
        AppCount      = $Response.app_count
        DocumentCount = $Response.document_count
        WordCount     = $Response.word_count
        CreatedBy     = $CreatedBy
        CreatedAt     = Convert-UnixTimeToLocalDateTime($Response.created_at)
        UpdatedBy     = $UpdatedBy
        UpdatedAt     = Convert-UnixTimeToLocalDateTime($Response.updated_at)
        Tags          = $KnowledgeTags
    }

    return $KnowledgeObject
}
