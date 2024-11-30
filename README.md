<!-- omit in toc -->
# PSDify: A PowerShell Module for Workspace Management for Dify

[🇺🇸 **English**](./README.md) [🇯🇵 **日本語**](./README.ja.md)

> [!WARNING]
>
> - 🚨 This is an **unofficial** project. LangGenius does not provide any support for this module.
> - 🚨 It uses **undocumented APIs** of Dify, which means it **may break with future updates** to Dify.
> - 🚨 The **Enterprise Edition** of Dify (multi-workspace environments) is **not supported**.
> - 🚨 Currently, the focus is on "**making it work**." This means **error handling and documentation are incomplete**, and it does not strictly follow PowerShell best practices.

<!-- omit in toc -->
## Table of Contents

- [Overview](#overview)
- [Tested Environments](#tested-environments)
- [Quick Start](#quick-start)
  - [Installation](#installation)
  - [Connecting to Dify](#connecting-to-dify)
  - [Managing Apps](#managing-apps)
  - [Managing Knowledge](#managing-knowledge)
  - [Managing Members](#managing-members)
  - [Managing Models](#managing-models)
  - [Initializing a Community Edition Instance](#initializing-a-community-edition-instance)

## Overview

PSDify is a PowerShell module designed to enable workspace management for [Dify](https://github.com/langgenius/dify) from the command line.

Here are some examples of what you can do with PSDify:

- ✨ **Export and import apps**
- ✨ **Create knowledge and upload files**
- ✨ **Manage members: retrieve, invite, remove, and change roles**
- ✨ **Add models and update system models**
- ✨ **Initialize instances for the Community Edition**

For a full list of available cmdlets, refer to the [📚Documentation](./Docs/README.md).

## Tested Environments

| Version | Dify<br>(Community) | Dify<br>(Cloud) |
| :---: | :---: | :---: |
| 0.12.1 | ✅ PSDify 0.1.0 | ✅ PSDify 0.1.0 |
| 0.11.2 | ✅ PSDify 0.0.1 | ✅ PSDify 0.0.1 |

> [!NOTE]
> This module has been tested with Windows PowerShell (PowerShell 5.1) and PowerShell 7.4.
> The Enterprise Edition of Dify (multi-workspace environments) is not supported.

## Quick Start

For a full list of available cmdlets, refer to the [📚Documentation](./Docs/README.md).

### Installation

```powershell
Install-Module -Name PSDify
```

### Connecting to Dify

```powershell
# Authenticate with a password (for Community Edition)
Connect-Dify -AuthMethod "Password" -Server "https://dify.example.com" -Email "dify@example.com"

# Authenticate with a code (for Cloud Edition)
Connect-Dify -AuthMethod "Code" -Server "https://dify.example.com" -Email "dify@example.com"
```

### Managing Apps

```powershell
# Retrieve apps
Get-DifyApp

# Export apps (as .\DSLs\*.yml)
Get-DifyApp | Export-DifyApp

# Import apps
Get-Item -Path "DSLs/*.yml" | Import-DifyApp
```

### Managing Knowledge

```powershell
# Retrieve knowledge
Get-DifyKnowledge

# Create knowledge
New-DifyKnowledge -Name "My New Knowledge"

# Upload files to knowledge
$Knowledge = Get-DifyKnowledge -Name "My New Knowledge"
Get-Item -Path "Docs/*.md" | Add-DifyDocument -Knowledge $Knowledge

# Wait for indexing to complete after uploading
Get-Item -Path "Docs/*.md" | Add-DifyDocument -Knowledge $Knowledge -Wait
```

### Managing Members

```powershell
# Retrieve members
Get-DifyMember

# Invite a new member
New-DifyMember -Email "user@example.com" -Role "normal"

# Change a member's role
Get-DifyMember -Email "user@example.com" | Set-DifyMemberRole -Role "editor"
```

### Managing Models

```powershell
# Retrieve models
Get-DifyModel

# Add a predefined model
New-DifyModel -Provider "openai" -From "predefined" `
  -Credential @{
    "openai_api_key" = "sk-proj-****************"
  }

# Add a customizable model
New-DifyModel -Provider "openai" -From "customizable" `
  -Type "llm" -Name "gpt-4o-mini" `
  -Credential @{
    "openai_api_key" = "sk-proj-****************"
  }

# Update the system model
Set-DifySystemModel -Type "llm" -Provider "openai" -Name "gpt-4o-mini"
```

### Initializing a Community Edition Instance

```powershell
Initialize-Dify -Server "https://dify.example.com" -Email "dify@example.com" -Name "Dify"
```
