function Get-DifyApp {
    [CmdletBinding()]
    param(
        [String] $Id = "",
        [String] $Name = "",
        [String] $Search = "",
        [String] $Mode = "",
        [String[]] $Tags = @()
    )

    $ValidModes = @("chat", "workflow", "agent-chat", "channel", "all")
    if ($Mode -and $Mode -notin $ValidModes) {
        throw "Invalid value for Mode. Must be one of: $($ValidModes -join ', ')"
    }

    $Query = @{
        "page"  = 1
        "limit" = 100
    }
    if ($Search) {
        $Query.name = $Search
    }
    if ($Mode) {
        $Query.mode = $Mode
    }
    if ($Tags) {
        $QueryTags = Get-DifyAppTag -Name $Tags
        $Query.tag_ids = ($QueryTags | ForEach-Object { $_.Id }) -join ","
    }

    $Members = Get-DifyMember

    $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/apps")
    $Method = "GET"
    $Apps = @()
    $HasMore = $true
    while ($HasMore) {
        try {
            $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Query $Query -Token $env:PSDIFY_CONSOLE_TOKEN
        }
        catch {
            throw "Failed to obtain apps: $_"
        }

        foreach ($App in $Response.data) {
            $AppTags = @()
            foreach ($Tag in $App.tags) {
                $AppTags += $Tag.name
            }
            $CreatedBy = $Members | Where-Object { $_.Id -eq $App.created_by } | Select-Object -ExpandProperty Email
            if (-not $CreatedBy) {
                $CreatedBy = $App.created_by
            }
            $UpdatedBy = $Members | Where-Object { $_.Id -eq $App.updated_by } | Select-Object -ExpandProperty Email
            if (-not $UpdatedBy) {
                $UpdatedBy = $App.updated_by
            }
            $AppObject = [PSCustomObject]@{
                Id          = $App.id
                Name        = $App.name
                Description = $App.description
                Mode        = $App.mode
                CreatedBy   = $CreatedBy
                CreatedAt   = Convert-UnixTimeToLocalDateTime($App.created_at)
                UpdatedBy   = $UpdatedBy
                UpdatedAt   = Convert-UnixTimeToLocalDateTime($App.updated_at)
                Tags        = $AppTags
            }
            if ($Id -and $AppObject.Id -eq $Id) {
                return $AppObject
            }
            $Apps += $AppObject
        }

        $HasMore = $Response.has_more
        $Query.page++
    }

    if ($Name) {
        $Apps = $Apps | Where-Object { $_.Name -eq $Name }
    }

    return $Apps
}
