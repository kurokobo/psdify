# PSDify: A PowerShell Module for Administrative Operations for Dify

[🇺🇸 **English**](./README.md) [🇯🇵 **日本語**](./README.ja.md)

> [!WARNING]
>
> - 🚨 This is an **unofficial** project. LangGenius does not provide any support for this module.
> - 🚨 It uses **undocumented APIs** of Dify, which means it **may break with future updates** to Dify.
> - 🚨 The **Enterprise Edition** of Dify (multi-workspace environments) is **not supported**.
> - 🚨 Currently, the focus is on "**making it work**." This means **error handling and documentation are incomplete**, and it does not strictly follow PowerShell best practices.

## Overview

PSDify is a PowerShell module designed to enable administrative operations for [Dify](https://github.com/langgenius/dify) from the command line.

Here are some examples of what you can do with PSDify:

- ✨ **Export and import apps**
- ✨ **Manage members: retrieve, invite, remove, and change roles**
- ✨ **Add models and update system models**
- ✨ **Initialize instances for the Community Edition**

## Tested Environments

- Windows PowerShell (PowerShell 5.1)
- PowerShell 7.4

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
