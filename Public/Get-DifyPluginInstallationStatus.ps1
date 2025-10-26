function Get-DifyPluginInstallationStatus {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject] $TaskInfo = $null,
        [String] $TaskId,
        [Switch] $Wait = $false,
        [Int] $Interval = 5,
        [Int] $Timeout = 300
    )

    if (-not $TaskInfo -and -not $TaskId) {
        throw "TaskInfo or TaskId is required."
    }
    if ($TaskInfo) {
        $TaskId = $TaskInfo.TaskId
    }

    $AllTasks = @()
    $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current/plugin/tasks")
    $Method = "GET"
    $Query = @{
        "page"      = 1
        "page_size" = 100
    }
    try {
        $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Query $Query -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
    }
    catch {
        throw "Failed to get plugin installation status: $_"
    }
    $AllTasks += $Response.tasks

    if (-not ($AllTasks | Where-Object { $_.id -eq $TaskId })) {
        throw "TaskId $TaskId not found."
    }

    $Now = Get-Date
    $WaitUntil = $Now.AddSeconds($Timeout)

    while ($Now -lt $WaitUntil) {
        $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current/plugin/tasks/", $TaskId)
        $Method = "GET"

        try {
            $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
        }
        catch {
            throw "Failed to get plugin installation status: $_"
        }

        $Plugins = @()
        foreach ($Plugin in $Response.task.plugins) {
            $Plugins += [PSCustomObject]@{
                UniqueIdentifier = $Plugin.plugin_unique_identifier
                Id               = $Plugin.plugin_id
                DisplayName      = $Plugin.label.en_US
                Status           = $Plugin.status
                Message          = $Plugin.message
            }
        }
        $Status = [PSCustomObject]@{
            Id               = $Response.task.id
            CreatedAt        = $Response.task.created_at
            UpdatedAt        = $Response.task.updated_at
            Status           = $Response.task.status
            TotalPlugins     = $Response.task.total_plugins
            CompletedPlugins = $Response.task.completed_plugins
            Plugins          = $Plugins
        }

        if (-not $Wait) {
            return $Status
        }

        $InProgress = $false
        if (@("success", "failed") -notcontains $Status.Status) {
            $InProgress = $true
        }

        if (-not $InProgress) {
            return $Status
        }

        Start-Sleep -Seconds $Interval
        $Now = Get-Date
    }
    return $Status
}
