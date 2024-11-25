<!-- omit in toc -->
# PSDify: Dify の管理系操作用 PowerShell モジュール

[🇺🇸 **English**](./README.md) [🇯🇵 **日本語**](./README.ja.md)

> [!WARNING]
>
> - 🚨 これは **非公式** のプロジェクトです。LangGenius はいかなるサポートも提供しません。
> - 🚨 Dify の **ドキュメント化されていない API** を利用しています。Dify の **仕様変更により動作しなくなる可能性** があります。
> - 🚨 Dify の **エンタープライズ版**（マルチワークスペース環境）は **サポートしていません**。
> - 🚨 現時点では、"**とにかく動く**" ことを優先しているため、**エラーハンドリングやドキュメンテーションは不十分** です。また、PowerShell のベストプラクティスには必ずしも従っていません。

<!-- omit in toc -->
## 目次

- [概要](#概要)
- [テスト済み環境](#テスト済み環境)
- [クイックスタート](#クイックスタート)
  - [インストール](#インストール)
  - [Dify への接続](#dify-への接続)
  - [アプリの管理](#アプリの管理)
  - [メンバの管理](#メンバの管理)
  - [モデルの管理](#モデルの管理)
  - [コミュニティ版のインスタンスの初期設定](#コミュニティ版のインスタンスの初期設定)

## 概要

[Dify](https://github.com/langgenius/dify) の、主に管理系操作をコマンドラインから行えるようにすることを目指した PowerShell モジュールです。

例として、次のような操作を行えます。

- ✨ **アプリのエクスポートとインポート**
- ✨ **メンバの取得、招待、削除、ロール変更**
- ✨ **モデルの追加、システムモデルの変更**
- ✨ **コミュニティ版のインスタンスの初期設定**

## テスト済み環境

- Windows PowerShell (PowerShell 5.1)
- PowerShell 7.4

## クイックスタート

利用できるコマンドレットの完全な一覧は [📚ドキュメント](./Docs/README.ja.md) を参照してください。

### インストール

```powershell
Install-Module -Name PSDify
```

### Dify への接続

```powershell
# パスワードによる認証（コミュニティ版向け）
Connect-Dify -AuthMethod "Password" -Server "https://dify.example.com" -Email "dify@example.com"

# メールによる認証（クラウド版向け）
Connect-Dify -AuthMethod "Code" -Server "https://dify.example.com" -Email "dify@example.com"
```

### アプリの管理

```powershell
# アプリの取得
Get-DifyApp

# アプリのエクスポート
Get-DifyApp | Export-DifyApp

# アプリのインポート
Get-Item -Path "DSLs/*.yml" | Import-DifyApp
```

### メンバの管理

```powershell
# メンバの取得
Get-DifyMember

# メンバの招待
New-DifyMember -Email "user@example.com" -Role "normal"

# メンバのロール変更
Get-DifyMember -Email "user@example.com" | Set-DifyMemberRole -Role "editor"
```

### モデルの管理

```powershell
# モデルの取得
Get-DifyModel

# モデルの追加（事前定義モデル）
New-DifyModel -Provider "openai" -From "predefined" `
  -Credential @{
    "openai_api_key" = "sk-proj-****************"
  }

# モデルの追加（カスタムモデル）
New-DifyModel -Provider "openai" -From "customizable" `
  -Type "llm" -Name "gpt-4o-mini" `
  -Credential @{
    "openai_api_key" = "sk-proj-****************"
  }

# システムモデルの変更
Set-DifySystemModel -Type "llm" -Provider "openai" -Name "gpt-4o-mini"
```

### コミュニティ版のインスタンスの初期設定

```powershell
Initialize-Dify -Server "https://dify.example.com" -Email "dify@example.com" -Name "Dify"
```
