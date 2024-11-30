# List of PSDify Cmdlets

PSDify includes the following cmdlets.

Detailed help is not provided, so please refer to the examples on this page for cmdlet usage.

| Category | Cmdlet | Description |
| --- | --- | --- |
| Authentication | [Connect-Dify](#connect-dify) | Authenticate with Dify using password or email authentication, enabling operations with other PSDify cmdlets. |
| Authentication | [Disconnect-Dify](#disconnect-dify) | Log out from Dify. |
| Application Management | [Get-DifyApp](#get-difyapp) | Retrieve app information. |
| Application Management | [Remove-DifyApp](#remove-difyapp) | Delete apps. |
| Application Management | [Import-DifyApp](#import-difyapp) | Import apps from local DSL files. |
| Application Management | [Export-DifyApp](#export-difyapp) | Export apps to DSL files. |
| Application Management | [Get-DifyDSLContent](#get-difydslcontent--set-difydslcontent) | Retrieve content from DSL file as string. |
| Application Management | [Set-DifyDSLContent](#get-difydslcontent--set-difydslcontent) | Write content to DSL file. |
| Application Management | [Get-DifyAppAPIKey](#get-difyappapikey) | Retrieve app API keys. |
| Application Management | [New-DifyAppAPIKey](#new-difyappapikey) | Create app API keys. |
| Application Management | [Remove-DifyAppAPIKey](#remove-difyappapikey) | Delete app API keys. ||
| Knowledge Management | [Get-DifyKnowledge](#get-difyknowledge) | Retrieve knowledge information. |
| Knowledge Management | [New-DifyKnowledge](#new-difyknowledge) | Add new empty knowledge. |
| Knowledge Management | [Remove-DifyKnowledge](#remove-difyknowledge) | Delete knowledge. |
| Knowledge Management | [Get-DifyDocument](#get-difydocument) | Retrieve document information in knowledge. |
| Knowledge Management | [Add-DifyDocument](#add-difydocument) | Upload documents to knowledge. |
| Member Management | [Get-DifyMember](#get-difymember) | Retrieve workspace member information. |
| Member Management | [New-DifyMember](#new-difymember) | Add (invite) a new member to the workspace. |
| Member Management | [Remove-DifyMember](#remove-difymember) | Remove members from the workspace. |
| Member Management | [Set-DifyMemberRole](#set-difymemberrole) | Change members' role in the workspace. |
| Model Management | [Get-DifyModel](#get-difymodel) | Retrieves workspace model information. |
| Model Management | [New-DifyModel](#new-difymodel) | Add new models to the workspace. |
| Model Management | [Get-DifySystemModel](#get-difysystemmodel) | Retrieve system model information for the workspace. |
| Model Management | [Set-DifySystemModel](#set-difysystemmodel) | Change the system model in the workspace. |
| Tag Management | [Get-DifyTag](#get-difytag) | Retrieve tag information. |
| Tag Management | [Get-DifyAppTag](#get-difyapptag) | Retrieve tag information for apps. |
| Tag Management | [Get-DifyKnowledgeTag](#get-difyknowledgetag) | Retrieve tag information for knowledge. |
| Information Retrieval | [Get-DifyVersion](#get-difyversion) | Retrieve Dify version information. |
| Information Retrieval | [Get-DifyProfile](#get-difyprofile) | Retrieve authenticated account information. |
| Instance Initialization | [Initialize-Dify](#initialize-dify) | Create an admin account (Community Edition only). |
| Miscellaneous | [Set-PSDifyConfiguration](#set-psdifyconfiguration) | Disables SSL certificate verification for HTTPS connections. |
| Miscellaneous | [Add-DifyFile](#add-difyfile) | Upload files. |
| Miscellaneous | [Get-DifyDocumentIndexingStatus](#get-difydocumentindexingstatus) | Retrieve document indexing status. |
| Miscellaneous | [Invoke-DifyRestMethod](#invoke-difyrestmethod) | Invoke REST API methods. |
| Chat Operations | [Send-DifyChatMessage](#send-difychatmessage) | Send chat messages to the app. |

## ✨ Authentication

### Connect-Dify

Authenticate with Dify using password or email-based login, enabling operations with other PSDify cmdlets.

> [!NOTE]
> Upon successful authentication, the following environment variables will be set:
>
> ```powershell
> $env:PSDIFY_CONSOLE_TOKEN = "..."
> $env:PSDIFY_CONSOLE_REFRESH_TOKEN = "..."
> ```

#### Email Authentication (For Cloud Edition)

SSO-authenticated accounts can also log in via email authentication using the associated email address.

```powershell
# Email authentication (enter the code manually manually which will be sent to your email address after execution)
Connect-Dify -AuthMethod "Code" -Email "dify@example.com"
```

> [!NOTE]
> You can use environment variables to simplify cmdlet arguments.
>
> ```powershell
> $env:PSDIFY_URL = "https://cloud.dify.ai"
> $env:PSDIFY_AUTH_METHOD = "Code"
> $env:PSDIFY_EMAIL = "dify@example.com"
> ```

#### Password Authentication (For Community Edition)

> [!NOTE]
> If using a self-signed certificate for HTTPS in the Community Edition, disable certificate verification before invoking `Connect-Dify`.
>
> ```powershell
> # Disable certificate verification
> Set-PSDifyConfiguration -IgnoreSSLVerification $true
> ```

```powershell
# Password authentication (enter the password manually after execution)
Connect-Dify -Server "https://dify.example.com" -Email "dify@example.com"

# Password authentication (use predefined password)
$DifyPassword = ConvertTo-SecureString -String "AwesomeDify123!" -AsPlainText -Force
Connect-Dify -Server "https://dify.example.com" -Email "dify@example.com" -Password $DifyPassword
```

> [!NOTE]
> You can use environment variables to simplify cmdlet arguments.
>
> ```powershell
> $env:PSDIFY_URL = "https://dify.example.com"
> $env:PSDIFY_AUTH_METHOD = "Password"
> $env:PSDIFY_EMAIL = "dify@example.com"
> $env:PSDIFY_PASSWORD = "AwesomeDify123!"
> $env:PSDIFY_DISABLE_SSL_VERIFICATION = "true"  # For self-signed certificates
> ```

### Disconnect-Dify

Log out from Dify.

```powershell
# Logout (invalidate issued tokens)
Disconnect-Dify

# Force logout (remove local environment variables regardless of logout success)
Disconnect-Dify -Force
```

## ✨ Application Management

### Get-DifyApp

Retrieve app information.

```powershell
# Get all apps
Get-DifyApp

# Get apps by ID
Get-DifyApp -Id "..."

# Get apps by name (complete match)
Get-DifyApp -Name "..."

# Get apps by name (partial match)
Get-DifyApp -Search "..."

# Get apps by mode
## Modes: "chat", "workflow", "agent-chat", "channel", "all"
Get-DifyApp -Mode "chat"

# Get apps by tags (multiple tags can be specified)
Get-DifyApp -Tags "...", "..."

# Example: Combine filters
Get-DifyApp -Name "..." -Mode "chat"
```

### Remove-DifyApp

Delete apps.

```powershell
# Delete app (specify directly from Get-DifyApp)
Get-DifyApp -Name "..." | Remove-DifyApp

# Delete app (use result from Get-DifyApp)
$AppsToBeRemoved = Get-DifyApp -Name "..."
Remove-DifyApp -App $AppsToBeRemoved
```

### Import-DifyApp

Import apps from local DSL files.

```powershell
# Import apps (specify file paths, supports wildcards and multiple paths)
Import-DifyApp -Path "DSLs/*.yml"
Import-DifyApp -Path "DSLs/demo1.yml", "DSLs/demo2.yml"

# Import apps (specify directly from Get-Item or Get-ChildItem)
Get-Item -Path "DSLs/*.yml" | Import-DifyApp

# Import apps (use result from Get-ChildItem)
$DSLFiles = Get-ChildItem -Path "DSLs/*.yml"
Import-DifyApp -Item $DSLFiles
```

### Export-DifyApp

Export apps to DSL files. By default, files are saved in the `DSLs` directory.

```powershell
# Export app (specify directly from Get-DifyApp)
Get-DifyApp | Export-DifyApp

# Export app (use result from Get-DifyApp)
$AppsToBeExported = Get-DifyApp
Export-DifyApp -App $AppsToBeExported

# Export app (change target directory)
Get-DifyApp | Export-DifyApp -Path "./path/to/your/directory"

# Export app (include secrets)
Get-DifyApp | Export-DifyApp -IncludeSecret
```

### Get-DifyDSLContent / Set-DifyDSLContent

Retrieve content from DSL file as string and write content to DSL file.

This is useful when you want to rewrite part of an existing DSL file and save it as another file. It is designed to handle DSL files consistently in UTF-8 without BOM.

```powershell
# Retrieve content from DSL file
$RawContent = Get-DifyDSLContent -Path "DSLs/old.yml"

# Rewrite the old knowledge ID in the DSL file to the new knowledge ID and save it as another DSL file
$RawContent -replace "8b960203-299d-4345-b953-3308663dd790", "574d9556-189a-4d35-b296-09231b859667" | Set-DifyDSLContent -Path "DSLs/new.yml"
```

### Get-DifyAppAPIKey

Retrieve the API key of the app.

```powershell
# Get API key (specify directly from Get-DifyApp)
Get-DifyApp -Name "..." | Get-DifyAppAPIKey

# Get API key (use result from Get-DifyApp)
$AppsToGetAPIKey = Get-DifyApp -Name "..."
Get-DifyAppAPIKey -App $AppsToGetAPIKey
```

### New-DifyAppAPIKey

Create an API key for the app.

```powershell
# Create an API key (specify directly from Get-DifyApp)
Get-DifyApp -Name "..." | New-DifyAppAPIKey

# Create an API key (use result from Get-DifyApp)
$AppsToCreateAPIKey = Get-DifyApp -Name "..."
```

### Remove-DifyAppAPIKey

Delete the API key of the app.

```powershell
# Delete the API key (specify directly from Get-DifyAppAPIKey)
Get-DifyApp -Name "..." | Get-DifyAppAPIKey | Remove-DifyAppAPIKey

# Delete the API key (use result from Get-DifyAppAPIKey)
$APIKeysToBeRemoved = Get-DifyApp -Name "..." | Get-DifyAppAPIKey
Remove-DifyAppAPIKey -APIKey $APIKeysToBeRemoved
```

## ✨ Knowledge Management

### Get-DifyKnowledge

Retrieve knowledge information.

```powershell
# Get all knowledge
Get-DifyKnowledge

# Get knowledge by ID
Get-DifyKnowledge -Id "..."

# Get knowledge by name (complete match)
Get-DifyKnowledge -Name "..."

# Get knowledge by name (partial match)
Get-DifyKnowledge -Search "..."

# Get knowledge by tags (multiple tags can be specified)
Get-DifyKnowledge -Tags "...", "..."
```

### New-DifyKnowledge

Add new empty knowledge.

```powershell
# Add new knowledge
New-DifyKnowledge -Name "My New Knowledge"

# Add new knowledge with description
New-DifyKnowledge -Name "My New Knowledge" -Description "This is a new knowledge."
```

### Remove-DifyKnowledge

Delete knowledge.

```powershell
# Delete knowledge (specify directly from Get-DifyKnowledge)
Get-DifyKnowledge -Name "..." | Remove-DifyKnowledge

# Delete knowledge (use result from Get-DifyKnowledge)
$KnowledgeToBeRemoved = Get-DifyKnowledge -Name "..."
Remove-DifyKnowledge -Knowledge $KnowledgeToBeRemoved
```

### Get-DifyDocument

Retrieve document information in knowledge.

```powershell
# Get all documents (specify directly from Get-DifyKnowledge)
Get-DifyKnowledge -Name "..." | Get-DifyDocument

# Get all documents (use result from Get-DifyKnowledge)
$Knowledge = Get-DifyKnowledge -Name "..."
Get-DifyDocument -Knowledge $Knowledge

# Get documents by ID
Get-DifyKnowledge -Name "..." | Get-DifyDocument -Id "..."

# Get documents by name (complete match)
Get-DifyKnowledge -Name "..." | Get-DifyDocument -Name "..."

# Get documents by name (partial match)
Get-DifyKnowledge -Name "..." | Get-DifyDocument -Search "..."
```

### Add-DifyDocument

Upload documents to knowledge. By default, the settings for Automatic, High Quality with system model, and Vector Aearch are applied.

Currently, detailed configuration is not implemented.

```powershell
# Prerequisite: Get the knowledge to upload the document
$Knowledge = Get-DifyKnowledge -Name "My New Knowledge"

# Upload documents (specify file paths, supports wildcards and multiple paths)
Add-DifyDocument -Knowledge $Knowledge -Path "Docs/*.md"

# Upload documents (specify from Get-Item or Get-ChildItem via pipe)
Get-Item -Path "Docs/*.md" | Add-DifyDocument -Knowledge $Knowledge

# Upload documents (use any model)
$EmbeddingModel = Get-DifyModel -Provider "openai" -Name "text-embedding-3-small"
Add-DifyDocument -Knowledge $Knowledge -Path "Docs/*.md" -IndexMode "high_quality" -Model $EmbeddingModel

# Upload documents (use economy mode)
Add-DifyDocument -Knowledge $Knowledge -Path "Docs/*.md" -IndexMode "economy"

# Wait for indexing to complete
Add-DifyDocument -Knowledge $Knowledge -Path "Docs/*.md" -Wait

# Custom wait settings
Add-DifyDocument -Knowledge $Knowledge -Path "Docs/*.md" -Wait -Interval 10 -Timeout 600
```

## ✨ Member Management

### Get-DifyMember

Retrieve workspace member information.

```powershell
# Get all members
Get-DifyMember

# Get member by ID
Get-DifyMember -Id "..."

# Get member by name
Get-DifyMember -Name "..."

# Get member by email
Get-DifyMember -Email "..."
```

### New-DifyMember

Add (invite) a new member to the workspace.

```powershell
# Invite a new member
## Roles: "admin", "editor", "normal"
New-DifyMember -Email "dify@example.com" -Role "normal" -Language "en-US"
```

### Remove-DifyMember

Remove members from the workspace.

```powershell
# Remove members (specify directly from Get-DifyMember)
Get-DifyMember -Name "..." | Remove-DifyMember

# Remove members (use result from Get-DifyMember)
$MembersToBeRemoved = Get-DifyMember -Name "..."
Remove-DifyMember -Member $MembersToBeRemoved
```

### Set-DifyMemberRole

Change members' role in the workspace.

```powershell
# Change role (specify directly from Get-DifyMember)
Get-DifyMember -Name "..." | Set-DifyMemberRole -Role "editor"

# Change role (use result from Get-DifyMember)
$MembersToBeChanged = Get-DifyMember -Name "..."
Set-DifyMemberRole -Member $MembersToBeChanged -Role "editor"
```

## ✨ Model Management

### Get-DifyModel

Retrieve workspace model information.

```powershell
# Get all models
Get-DifyModel

# Get models by provider
Get-DifyModel -Provider "..."

# Get models by type
## Types: "predefined", "customizable"
Get-DifyModel -From "..."

# Get models by name
Get-DifyModel -Name "..."

# Get models by model type
## Model types: "llm", "text-embedding", "speech2text", "moderation", "tts", "rerank"
Get-DifyModel -Type "..."

# Example: Combine filters
Get-DifyModel -Provider "..." -Type "llm"
```

### New-DifyModel

Add new models to the workspace. The credentials required depend on the provider and the model. Check the actual HTTP requests using browser developer tools for precise details.

```powershell
# Add predefined models (example for OpenAI)
New-DifyModel -Provider "openai" -From "predefined" `
  -Credential @{
    "openai_api_key" = "sk-proj-****************"
  }

# Add predefined models (example for Cohere)
New-DifyModel -Provider "cohere" -From "predefined" `
  -Credential @{
    "api_key" = "****************************************"
  }

# Add customizable models (example for OpenAI)
New-DifyModel -Provider "openai" -From "customizable" `
  -Type "llm" -Name "gpt-4o-mini" `
  -Credential @{
    "openai_api_key" = "sk-proj-****************"
  }

# Add customizable models (example for Cohere)
New-DifyModel -Provider "cohere" -From "customizable" `
  -Type "llm" -Name "command-r-plus" `
  -Credential @{
    "mode"    = "chat"
    "api_key" = "****************************************"
  }
```

### Get-DifySystemModel

Retrieve system model information for the workspace.

```powershell
# Get system model
Get-DifySystemModel

# Get system model by type
## Types: "llm", "text-embedding", "rerank", "speech2text", "tts"
Get-DifySystemModel -Type "..."
```

### Set-DifySystemModel

Change the system model in the workspace.

```powershell
# Change system model
Set-DifySystemModel -Type "llm" -Provider "openai" -Name "gpt-4o-mini"

# Change system model (specify directly from Get-DifySystemModel)
Get-DifySystemModel -Type "llm" -Provider "openai" -Name "gpt-4o-mini" | Set-DifySystemModel

# Change system model (use result from Get-DifySystemModel)
$SystemModelToBeChanged = Get-DifySystemModel -Type "llm" -Provider "openai" -Name "gpt-4o-mini"
Set-DifySystemModel -Model $SystemModelToBeChanged
```

## ✨ Tag Management

### Get-DifyTag

Retrieve tag information.

```powershell
# Get tags by type
## Types: "app", "knowledge"
Get-DifyTag -Type "app"

# Get tags by ID
Get-DifyTag -Type "app" -Id "..."

# Get tags by name
Get-DifyTag -Type "app" -Name "..."
```

### Get-DifyAppTag

Retrieve tag information for apps. This is equivalent to `Get-DifyTag -Type "app"`.

```powershell
# Get app tags
Get-DifyAppTag

# Get app tags by ID
Get-DifyAppTag -Id "..."

# Get app tags by name
Get-DifyAppTag -Name "..."
```

### Get-DifyKnowledgeTag

Retrieve tag information for knowledge. This is equivalent to `Get-DifyTag -Type "knowledge"`.

```powershell
# Get knowledge tags
Get-DifyKnowledgeTag

# Get knowledge tags by ID
Get-DifyKnowledgeTag -Id "..."

# Get knowledge tags by name
Get-DifyKnowledgeTag -Name "..."
```

## ✨ Information Retrieval

### Get-DifyVersion

Retrieve the version information for Dify.

```powershell
# Get version information
Get-DifyVersion
```

### Get-DifyProfile

Retrieve the authenticated account's profile information.

```powershell
# Get account profile
Get-DifyProfile
```

## ✨ Instance Initialization

### Initialize-Dify

Create an admin account (Community Edition only). After successful completion, it is equivalent to logging in with the admin account using `Connect-Dify`.

```powershell
# Create an admin account (enter the password manually after execution)
Initialize-Dify -Server "https://dify.example.com" -Email "dify@example.com"

# Create an admin account (use predefined password)
$DifyPassword = ConvertTo-SecureString -String "AwesomeDify123!" -AsPlainText -Force
Initialize-Dify -Server "https://dify.example.com" -Email "dify@example.com" -Password $DifyPassword

# Create an admin account (if you've specify INIT_PASSWORD for Dify and use predefined init password)
$DifyInitPassword = ConvertTo-SecureString -String "AwesomeDifyInitPassword123!" -AsPlainText -Force
$DifyPassword = ConvertTo-SecureString -String "AwesomeDify123!" -AsPlainText -Force
Initialize-Dify -Server "https://dify.example.com" -Email "dify@example.com" -InitPassword $DifyInitPassword -Password $DifyPassword
```

> [!NOTE]
> You can use environment variables to simplify cmdlet arguments.
>
> ```powershell
> $env:PSDIFY_URL = "https://dify.example.com"
> $env:PSDIFY_AUTH_METHOD = "Password"
> $env:PSDIFY_EMAIL = "dify@example.com"
> $env:PSDIFY_PASSWORD = "AwesomeDify123!"
> $env:PSDIFY_DISABLE_SSL_VERIFICATION = "true"  # For self-signed certificates
> $env:PSDIFY_INIT_PASSWORD = "AwesomeDifyInitPassword123!"  # If INIT_PASSWORD is set in Dify
> ```

## ✨ Miscellaneous

### Set-PSDifyConfiguration

Enable or disable SSL certificate verification for HTTPS connections.

```powershell
# Disable certificate verification
Set-PSDifyConfiguration -IgnoreSSLVerification $true

# Enable certificate verification
Set-PSDifyConfiguration -IgnoreSSLVerification $false
```

### Add-DifyFile

Upload files.

```powershell
# Upload files (specify file paths, supports wildcards and multiple paths)
Add-DifyFile -Path "Files/*"

# Upload files (specify from Get-Item or Get-ChildItem via pipe)
Get-Item -Path "Files/*" | Add-DifyFile

# Upload files (specify source information)
Get-Item -Path "Files/*" | Add-DifyFile -Source "..."
```

### Get-DifyDocumentIndexingStatus

Retrieve document indexing status.

```powershell
# Get indexing status (specify directly from Add-DifyDocument)
Add-DifyDocument -Knowledge $Knowledge -Path "Docs/*.md" | Get-DifyDocumentIndexingStatus

# Get indexing status (specify from Add-DifyDocument result)
$DocumentToCheckIndexingStatus = Add-DifyDocument -Knowledge $Knowledge -Path "Docs/*.md"
Get-DifyDocumentIndexingStatus -Document $DocumentToCheckIndexingStatus

# Get indexing status (specify knowledge and batch ID)
Get-DifyDocumentIndexingStatus -Knowledge $Knowledge -Batch "..."

# Get indexing status (wait for completion)
Get-DifyDocumentIndexingStatus -Knowledge $Knowledge -Batch "..." -Wait

# Get indexing status (change waiting time)
Get-DifyDocumentIndexingStatus -Knowledge $Knowledge -Batch "..." -Wait -Interval 10 -Timeout 600
```

### Invoke-DifyRestMethod

Invokes REST API methods.

```powershell
# Invoke REST API (GET)
$Query = @{
    "page"  = 1
    "limit" = 100
}
Invoke-DifyRestMethod -Method "GET" -Uri "https://dify.example.com/console/api/apps" -Query $Query -Token $env:PSDIFY_CONSOLE_TOKEN

# Invoke REST API (POST)
$Body =  @{
    "model_settings" = @(
        @{
            "model_type" = "llm"
            "provider"   = "openai"
            "model"      = "gpt-4o-mini"
        }
    )
} | ConvertTo-Json
Invoke-DifyRestMethod -Method "POST" -Uri "https://dify.example.com/console/api/workspaces/current/default-model" -Body $Body -Token $env:PSDIFY_CONSOLE_TOKEN

# Invoke REST API (using a session)
$DifySession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
Invoke-DifyRestMethod -Method "GET" -Uri "https://dify.example.com/console/api/setup" -Session $DifySession
```

## ✨ Chat Operations

### Send-DifyChatMessage

Send chat messages to the app. The following environment variables are required for operation.

- `$env:PSDIFY_APP_URL`
- `$env:PSDIFY_APP_TOKEN`

The content sent and the response are saved in the `Logs` folder.

```powershell
# Set environment variables
$env:PSDIFY_APP_URL = "https://dify.example.com"
$env:PSDIFY_APP_TOKEN = "app-****************"

# Send chat messages
Send-DifyChatMessage -Message "Hello, Dify!"

# Send chat messages (start a new session)
Send-DifyChatMessage -Message "Hello, Dify!" -NewSession
```
