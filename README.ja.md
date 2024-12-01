<!-- omit in toc -->
# PSDify: Dify のワークスペース管理用 PowerShell モジュール

[🇺🇸 **English**](./README.md) [🇯🇵 **日本語**](./README.ja.md)

> [!WARNING]
>
> - 🚨 これは **非公式** のプロジェクトです。LangGenius はいかなるサポートも提供しません。
> - 🚨 Dify の **ドキュメント化されていない API** を利用しています。Dify の **仕様変更により動作しなくなる可能性** があります。
> - 🚨 Dify の **エンタープライズ版**（マルチワークスペース環境）は **サポートしていません**。
> - 🚨 現時点では、"**とにかく動く**" ことを優先しているため、**エラーハンドリングやドキュメンテーションは不十分** です。また、PowerShell のベストプラクティスには必ずしも従っていません。

![image](https://github.com/user-attachments/assets/fd7a22ea-4ed6-46c3-a2dc-4027c2650f5e)

<!-- omit in toc -->
## 目次

- [概要](#概要)
- [テスト済み環境](#テスト済み環境)
- [クイックスタート](#クイックスタート)
  - [インストール](#インストール)
  - [認証](#認証)
  - [アプリの管理](#アプリの管理)
  - [ナレッジの管理](#ナレッジの管理)
  - [メンバの管理](#メンバの管理)
  - [モデルの管理](#モデルの管理)
  - [コミュニティ版のインスタンスの初期設定](#コミュニティ版のインスタンスの初期設定)

## 概要

[Dify](https://github.com/langgenius/dify) のワークスペース管理をコマンドラインから行えるようにすることを目指した PowerShell モジュールです。

例として、次のような操作を行えます。

- ✨ **アプリのエクスポートとインポート**
- ✨ **ナレッジの作成とファイルのアップロード**
- ✨ **メンバの取得、招待、削除、ロール変更**
- ✨ **モデルの追加、システムモデルの変更**
- ✨ **コミュニティ版のインスタンスの初期設定**
- ✨ **アプリへのチャットの送信**

完全な一覧は [📚ドキュメント](./Docs/README.ja.md) を参照してください。

## テスト済み環境

| バージョン | Dify<br>(Community) | Dify<br>(Cloud) |
| :---: | :---: | :---: |
| 0.12.1 | ✅ PSDify 0.1.0 | ✅ PSDify 0.1.0 |
| 0.11.2 | ✅ PSDify 0.0.1 | ✅ PSDify 0.0.1 |

> [!NOTE]
> Windows PowerShell (PowerShell 5.1) と PowerShell 7.4 で動作を確認しています。
> Dify Enterprise Edition（マルチワークスペース環境）はサポートしていません。

## クイックスタート

利用できるコマンドレットの完全な一覧と、より詳しい使い方は [📚ドキュメント](./Docs/README.ja.md) を参照してください。

### インストール

```powershell
Install-Module -Name PSDify
```

### 認証

```powershell
# メールによる認証（クラウド版向け）
Connect-Dify -AuthMethod "Code" -Email "dify@example.com"

# パスワードによる認証（コミュニティ版向け）
Connect-Dify -Server "https://dify.example.com" -Email "dify@example.com"
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

### ナレッジの管理

```powershell
# ナレッジの取得
Get-DifyKnowledge

# ナレッジの作成
New-DifyKnowledge -Name "My New Knowledge"

# ナレッジへのファイルのアップロード
$Knowledge = Get-DifyKnowledge -Name "My New Knowledge"
Get-Item -Path "Docs/*.md" | Add-DifyDocument -Knowledge $Knowledge

# アップロード後、インデキシングの完了を待つ
Get-Item -Path "Docs/*.md" | Add-DifyDocument -Knowledge $Knowledge -Wait
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
