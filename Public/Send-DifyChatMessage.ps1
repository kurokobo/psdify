function Send-DifyChatMessage {
    [CmdletBinding()]
    param (
        [Switch] $NewSession = $false,
        [String] $Message = "",
        [Hashtable] $Inputs = @{}
    )

    if (-not $Message) {
        throw "Message is required"
    }
    if (-not $env:PSDIFY_APP_URL) {
        throw "Specify URL of the api server as `$env:PSDIFY_APP_URL before using this cmdlet, e.g. https://api.dify.ai"
    }
    if (-not $env:PSDIFY_APP_TOKEN) {
        throw "Specify the token as `$env:PSDIFY_APP_TOKEN before using this cmdlet"
    }

    $ConversationId = if ($NewSession -or -not $env:PSDIFY_CONVERSATION_ID) { "" } else { $env:PSDIFY_CONVERSATION_ID }
    $IsNewSession = -not $ConversationId

    # display the message from user
    if ($IsNewSession) {
        Write-Host -ForegroundColor DarkGray ("-" * 72)
    }
    Write-Host -BackgroundColor DarkYellow -NoNewline " User "
    Write-Host ""
    Write-Host -ForegroundColor Yellow $Message
    Write-Host ""

    $Endpoint = Join-Url -Segments @($env:PSDIFY_APP_URL, "/v1/chat-messages")
    $Method = "POST"
    $Body = @{
        "inputs"          = $Inputs
        "query"           = $Message
        "response_mode"   = "blocking"
        "conversation_id" = $ConversationId
        "user"            = "PSDify"
        "files"           = @()
    } | ConvertTo-Json
    $StartTime = Get-Date
    try {
        $Response = Invoke-DifyRestMethod -Uri $Endpoint -Method $Method -Body $Body -Token $env:PSDIFY_APP_TOKEN
    }
    catch {
        throw "Failed to send chat message: $_"
    }
    $EndTime = Get-Date

    $env:PSDIFY_CONVERSATION_ID = $Response.conversation_id

    # display the message from dify
    Write-Host -BackgroundColor DarkCyan -NoNewline " Dify "
    Write-Host ""
    Write-Host -ForegroundColor Cyan $Response.answer
    Write-Host ""

    # display the metadata
    Write-Host -BackgroundColor DarkGray -NoNewline " Meta "
    Write-Host ""
    if ($IsNewSession) {
        Write-Host -ForegroundColor DarkGray "Conversation ID: $($Response.conversation_id) (New)"
    }
    else {
        Write-Host -ForegroundColor DarkGray "Conversation ID: $($Response.conversation_id)"
    }
    Write-Host -ForegroundColor DarkGray "Duration: $([int]($EndTime - $StartTime).TotalMilliseconds) ms ($($StartTime.ToString("HH:mm:ss"))) to ($($EndTime.ToString("HH:mm:ss")))"
    Write-Host ""

    # save the log
    $Log = @{
        "Message"        = $Message
        "Response"       = $Response.answer
        "ConversationId" = $Response.conversation_id
        "IsNewSession"   = (-not $ConversationId)
        "StartTime"      = $StartTime
        "EndTime"        = $EndTime
        "Duration"       = [int]($EndTime - $StartTime).TotalMilliseconds
    }
    if (-not (Test-Path -Path ".\Logs")) {
        $null = New-Item -Path ".\Logs" -ItemType Directory
    }
    $Log | ConvertTo-Json -Compress | Out-File -Append -FilePath ".\Logs\ChatMessages-$(Get-Date -Format 'yyyy-MM-dd').json"

    return
}
