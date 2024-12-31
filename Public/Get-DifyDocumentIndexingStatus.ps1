function Get-DifyDocumentIndexingStatus {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject] $Document = $null,
        [PSCustomObject] $Knowledge = $null,
        [String] $Batch,
        [Switch] $Wait = $false,
        [Int] $Interval = 5,
        [Int] $Timeout = 300
    )

    begin {
        $Documents = @()
    }

    process {
        foreach ($DocumentObject in $Document) {
            $Documents += $DocumentObject
        }
    }

    end {
        if (-not $Documents -and -not $Batch -and -not $Knowledge) {
            throw "Document is required"
        }
        if (-not $Documents -and (-not $Batch -or -not $Knowledge)) {
            throw "Batch and Knowledge are required"
        }
        if ($Documents) {
            $Knowledge = Get-DifyKnowledge -Id $Documents[0].KnowledgeId
            $Batch = $Documents[0].Batch
        }

        $AllDocuments = Get-DifyDocument -Knowledge $Knowledge

        $Now = Get-Date
        $WaitUntil = $Now.AddSeconds($Timeout)

        while ($Now -lt $WaitUntil) {
            $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/datasets", $Knowledge.Id, "/batch", $Batch, "/indexing-status")
            $Method = "GET"

            try {
                $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Token $env:PSDIFY_CONSOLE_TOKEN
            }
            catch {
                throw "Failed to obtain indexing status: $_"
            }

            $Statuses = @()
            foreach ($Status in $Response.data) {
                $CurrentDocument = $AllDocuments | Where-Object { $_.Id -eq $Status.id }
                $Statuses += [PSCustomObject]@{
                    KnowledgeId          = $Knowledge.Id
                    Id                   = $CurrentDocument.id
                    Name                 = $CurrentDocument.name
                    IndexingStatus       = $Status.indexing_status
                    ProcessingStartedAt  = Convert-UnixTimeToLocalDateTime($Status.processing_started_at)
                    ParsingCompletedAt   = Convert-UnixTimeToLocalDateTime($Status.parsing_completed_at)
                    CleaningCompletedAt  = Convert-UnixTimeToLocalDateTime($Status.cleaning_completed_at)
                    SplittingCompletedAt = Convert-UnixTimeToLocalDateTime($Status.splitting_completed_at)
                    CompletedAt          = Convert-UnixTimeToLocalDateTime($Status.completed_at)
                    PausedAt             = Convert-UnixTimeToLocalDateTime($Status.paused_at)
                    Error                = $Status.error
                    StoppedAt            = Convert-UnixTimeToLocalDateTime($Status.stopped_at)
                    CompletedSegments    = $Status.completed_segments
                    TotalSegments        = $Status.total_segments
                }
            }

            if (-not $Wait) {
                return $Statuses
            }

            $InProgress = $false
            foreach ($Status in $Statuses) {
                if (-not $Status.CompletedAt) {
                    $InProgress = $true
                    break
                }
            }

            if (-not $InProgress) {
                return $Statuses
            }

            Start-Sleep -Seconds $Interval
            $Now = Get-Date
        }
        return $Statuses
    }
}
