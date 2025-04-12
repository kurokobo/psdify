function Get-DifyPlugin {
    [CmdletBinding()]
    param(
        [String] $Category = "",
        [String[]] $Id = @(),
        [String[]] $Name = @(),
        [String[]] $UniqueIdentifier = @(),
        [String] $Search = ""
    )

    if (-not $env:PSDIFY_PLUGIN_SUPPORT) {
        throw "You are not logged in to a Dify server yet, or the Dify server currently logged in does not support plugins."
    }

    $ValidCategories = @("model", "tool", "agent", "extension", "bundle")
    if ($Category -and $Category -notin $ValidCategories) {
        throw "Invalid value for Category. Must be one of: $($ValidCategories -join ', ')"
    }
    if ($Category -eq "agent") {
        $Category = "agent_strategy"
    }

    $Endpoint = Join-Url -Segments @($env:PSDIFY_URL, "/console/api/workspaces/current/plugin/list")
    $Method = "GET"
    try {
        $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Token $env:PSDIFY_CONSOLE_TOKEN
    }
    catch {
        throw "Failed to get plugins: $_"
    }

    $Plugins = @()
    foreach ($Plugin in $Response.plugins) {
        if ($Plugin.declaration.category -eq "model") {
            $ModelProvider = "$($Plugin.plugin_id)/$($Plugin.declaration.model.provider)"
        }
        else {
            $ModelProvider = ""
        }
        $Plugins += [PSCustomObject]@{
            Category         = $Plugin.declaration.category
            Name             = $Plugin.name
            DisplayName      = $Plugin.declaration.label.en_US
            Id               = $Plugin.plugin_id
            Description      = $Plugin.declaration.description.en_US
            Version          = $Plugin.version
            InstallationId   = $Plugin.installation_id
            UniqueIdentifier = $Plugin.plugin_unique_identifier
            ModelProvider    = $ModelProvider
        }
    }

    if ($Category) {
        $Plugins = $Plugins | Where-Object { $_.Category -in $Category }
    }
    if ($Id) {
        $Plugins = $Plugins | Where-Object { $_.Id -in $Id }
    }
    if ($Name) {
        $Plugins = $Plugins | Where-Object { $_.Name -in $Name }
    }
    if ($UniqueIdentifier) {
        $Plugins = $Plugins | Where-Object { $_.UniqueIdentifier -in $UniqueIdentifier }
    }
    if ($Search) {
        $Plugins = $Plugins | Where-Object { $_.Id -like "*$($Search)*" -or $_.Name -like "*$($Search)*" -or $_.DisplayName -like "*$($Search)*" }
    }

    return $Plugins
}
