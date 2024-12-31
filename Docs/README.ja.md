# PSDify のコマンドレット一覧

PSDify には次のコマンドレットが含まれます。

精緻なヘルプは用意していないので、コマンドレットの使い方は、このページの使用例を参照してください。

| カテゴリ | コマンドレット | 説明 |
| --- | --- | --- |
| 認証 | [Connect-Dify](#connect-dify) | Dify にパスワード認証またはメール認証によるログイン処理を要求し、PSDify の他のコマンドレットによる操作が行えるようにします。 |
| 認証 | [Disconnect-Dify](#disconnect-dify) | Dify にログアウト処理を要求します。 |
| アプリの管理 | [Get-DifyApp](#get-difyapp) | アプリの情報を取得します。 |
| アプリの管理 | [Remove-DifyApp](#remove-difyapp) | アプリを削除します。 |
| アプリの管理 | [Import-DifyApp](#import-difyapp) | アプリをローカルの DSL ファイルからインポートします。 |
| アプリの管理 | [Export-DifyApp](#export-difyapp) | アプリを DSL ファイルとしてエクスポートします。 |
| アプリの管理 | [Get-DifyDSLContent](#get-difydslcontent--set-difydslcontent) | DSL ファイルの内容を文字列として取得します。 |
| アプリの管理 | [Set-DifyDSLContent](#get-difydslcontent--set-difydslcontent) | 文字列を DSL ファイルとして書き込みます。 |
| アプリの管理 | [Get-DifyAppAPIKey](#get-difyappapikey) | アプリの API キーを取得します。 |
| アプリの管理 | [New-DifyAppAPIKey](#new-difyappapikey) | アプリの API キーを作成します。 |
| アプリの管理 | [Remove-DifyAppAPIKey](#remove-difyappapikey) | アプリの API キーを削除します。 |
| ナレッジの管理 | [Get-DifyKnowledge](#get-difyknowledge) | ナレッジの情報を取得します。 |
| ナレッジの管理 | [New-DifyKnowledge](#new-difyknowledge) | 空のナレッジを作成します。 |
| ナレッジの管理 | [Remove-DifyKnowledge](#remove-difyknowledge) | ナレッジを削除します。 |
| ナレッジの管理 | [Get-DifyDocument](#get-difydocument) | ナレッジ内のドキュメントの情報を取得します。 |
| ナレッジの管理 | [Add-DifyDocument](#add-difydocument) | ナレッジにドキュメントをアップロードします。 |
| メンバの管理 | [Get-DifyMember](#get-difymember) | ワークスペースのメンバの情報を取得します。 |
| メンバの管理 | [New-DifyMember](#new-difymember) | ワークスペースに新しいメンバを追加（招待）します。 |
| メンバの管理 | [Remove-DifyMember](#remove-difymember) | ワークスペースからメンバを削除します。 |
| メンバの管理 | [Set-DifyMemberRole](#set-difymemberrole) | ワークスペースのメンバのロールを変更します。 |
| モデルの管理 | [Get-DifyModel](#get-difymodel) | ワークスペースのモデルの情報を取得します。 |
| モデルの管理 | [New-DifyModel](#new-difymodel) | ワークスペースに新しいモデルを追加します。 |
| モデルの管理 | [Get-DifySystemModel](#get-difysystemmodel) | ワークスペースのシステムモデルの情報を取得します。 |
| モデルの管理 | [Set-DifySystemModel](#set-difysystemmodel) | ワークスペースのシステムモデルを変更します。 |
| タグの管理 | [Get-DifyTag](#get-difytag) | タグの情報を取得します。 |
| タグの管理 | [Get-DifyAppTag](#get-difyapptag) | アプリ用のタグの情報を取得します。 |
| タグの管理 | [Get-DifyKnowledgeTag](#get-difyknowledgetag) | ナレッジ用のタグの情報を取得します。 |
| 情報取得 | [Get-DifyVersion](#get-difyversion) | Dify のバージョン情報を取得します。 |
| 情報取得 | [Get-DifyProfile](#get-difyprofile) | 認証したアカウントの情報を取得します。 |
| インスタンスの初期設定 | [Wait-Dify](#wait-dify) | Dify の起動完了を待ちます。 |
| インスタンスの初期設定 | [Initialize-Dify](#initialize-dify) | 管理者アカウントを作成します（コミュニティ版のみ）。 |
| その他 | [Set-PSDifyConfiguration](#set-psdifyconfiguration) | HTTPS 接続時の証明書の検証を無効化できます。 |
| その他 | [Add-DifyFile](#add-difyfile) | ファイルをアップロードします。 |
| その他 | [Get-DifyDocumentIndexingStatus](#get-difydocumentindexingstatus) | ドキュメントのインデキシング状況を取得します。 |
| その他 | [Invoke-DifyRestMethod](#invoke-difyrestmethod) | REST API を呼び出します。 |
| チャットの操作 | [Send-DifyChatMessage](#send-difychatmessage) | アプリにチャットメッセージを送信します。 |

## ✨ 認証

### Connect-Dify

Dify にパスワード認証またはメール認証によるログイン処理を要求し、PSDify の他のコマンドレットによる操作が行えるようにします。

> [!NOTE]
> 認証が成功すると、次の環境変数が自動で追加されます。
>
> ```powershell
> $env:PSDIFY_CONSOLE_TOKEN = "..."
> $env:PSDIFY_CONSOLE_REFRESH_TOKEN = "..."
> ```
>
> この環境変数が既に存在していて、かつその値（トークン）が有効な場合は、`-Force` オプションが指定されていない限り、再認証は行われません。

#### メールによる認証（クラウド版向け）

SSO により認証したアカウントでも、紐づけられたメールアドレスを使ってメール認証が行えます。

```powershell
# メールによる認証（実行後、メールで届いたコードを手動で入力する）
Connect-Dify -AuthMethod "Code" -Email "dify@example.com"
```

> [!NOTE]
> 引数は、環境変数を使うと省略できます。
>
> ```powershell
> $env:PSDIFY_URL = "https://cloud.dify.ai"
> $env:PSDIFY_AUTH_METHOD = "Code"
> $env:PSDIFY_EMAIL = "dify@example.com"
> ```

#### パスワードによる認証（コミュニティ版向け）

> [!NOTE]
> コミュニティ版で HTTPS 化に自己署名証明書を使っている場合は、`Connect-Dify` の実行前に証明書の検証を無効にする必要があります。
>
> ```powershell
> # 証明書の検証を無効にする
> Set-PSDifyConfiguration -IgnoreSSLVerification $true
> ```

```powershell
# パスワードによる認証（実行後、パスワードを手動で入力する）
Connect-Dify -Server "https://dify.example.com" -Email "dify@example.com"

# パスワードによる認証（パスワードを事前に指定する）
$DifyPassword = ConvertTo-SecureString -String "AwesomeDify123!" -AsPlainText -Force
Connect-Dify -Server "https://dify.example.com" -Email "dify@example.com" -Password $DifyPassword
```

> [!NOTE]
> 引数は、環境変数を使うと省略できます。
>
> ```powershell
> $env:PSDIFY_URL = "https://dify.example.com"
> $env:PSDIFY_AUTH_METHOD = "Password"
> $env:PSDIFY_EMAIL = "dify@example.com"
> $env:PSDIFY_PASSWORD = "AwesomeDify123!"
> $env:PSDIFY_DISABLE_SSL_VERIFICATION = "true"  # 自己署名証明書を使っている場合
> ```

### Disconnect-Dify

Dify にログアウト処理を要求します。

```powershell
# ログアウト（発行済みトークンの無効化）
Disconnect-Dify

# 強制ログアウト（ログアウト処理の成否にかかわらずローカルの環境変数を削除）
Disconnect-Dify -Force
```

## ✨ アプリの管理

### Get-DifyApp

アプリの情報を取得します。

```powershell
# アプリの取得（全て）
Get-DifyApp

# アプリの取得（ID で指定）
Get-DifyApp -Id "..."

# アプリの取得（名前で指定、完全一致）
Get-DifyApp -Name "..."

# アプリの取得（名前で指定、部分一致）
Get-DifyApp -Search "..."

# アプリの取得（モードで指定）
## モード： "chat", "workflow", "agent-chat", "channel", "all"
Get-DifyApp -Mode "chat"

# アプリの取得（タグで指定、複数指定可）
Get-DifyApp -Tags "...", "..."

# アプリの取得（組み合わせ例）
Get-DifyApp -Name "..." -Mode "chat"
```

### Remove-DifyApp

アプリを削除します。

```powershell
# アプリの削除（Get-DifyApp から直接パイプで指定）
Get-DifyApp -Name "..." | Remove-DifyApp

# アプリの削除（Get-DifyApp で取得した結果で指定）
$AppsToBeRemoved = Get-DifyApp -Name "..."
Remove-DifyApp -App $AppsToBeRemoved
```

### Import-DifyApp

アプリをローカルの DSL ファイルからインポートします。

```powershell
# アプリのインポート（ファイルパスで指定、ワイルドカード可、複数指定可）
Import-DifyApp -Path "DSLs/*.yml"
Import-DifyApp -Path "DSLs/demo1.yml", "DSLs/demo2.yml"

# アプリのインポート（Get-Item や Get-ChildItem からパイプで指定）
Get-Item -Path "DSLs/*.yml" | Import-DifyApp

# アプリのインポート（Get-ChildItem で取得した結果で指定）
$DSLFiles = Get-ChildItem -Path "DSLs/*.yml"
Import-DifyApp -Item $DSLFiles

# アプリのインポート（DSL ファイルの中身を直接パイプで指定）
Get-DifyDSLContent -Path "DSLs/demo.yml" | Import-DifyApp -Content
```

### Export-DifyApp

アプリを DSL ファイルとしてエクスポートします。デフォルトでは `DSLs` ディレクトリに保存されます。

```powershell
# アプリのエクスポート（Get-DifyApp から直接パイプで指定）
Get-DifyApp | Export-DifyApp

# アプリのエクポート（Get-DifyApp で取得した結果で指定）
$AppsToBeExported = Get-DifyApp
Export-DifyApp -App $AppsToBeExported

# アプリのエクスポート（保存先のディレクトリを変更）
Get-DifyApp | Export-DifyApp -Path "./path/to/your/directory"

# アプリのエクスポート（シークレットを含める）
Get-DifyApp | Export-DifyApp -IncludeSecret
```

### Get-DifyDSLContent / Set-DifyDSLContent

DSL ファイルの内容を文字列として取得したり、文字列を DSL ファイルとして書き込んだりします。DSL ファイルを一貫して BOM なしの UTF-8 で扱うために用意しています。

既存の DSL ファイルの一部を書き換えて別のファイルとして保存する場合や、`Import-DifyApp -Content` にそのままパイプしてインポートする場合に利用できます。

```powershell
# DSL ファイルの内容の取得
$RawContent = Get-DifyDSLContent -Path "DSLs/old.yml"

# DSL ファイル中の古いナレッジの ID を新しいナレッジ ID に書き換えて別の DSL ファイルとして保存
$RawContent -replace "8b960203-299d-4345-b953-3308663dd790", "574d9556-189a-4d35-b296-09231b859667" | Set-DifyDSLContent -Path "DSLs/new.yml"

# DSL ファイル中の古いナレッジの ID を新しいナレッジ ID に書き換えて新しいアプリとしてインポート
$RawContent -replace "8b960203-299d-4345-b953-3308663dd790", "574d9556-189a-4d35-b296-09231b859667" | Import-DifyApp -Content
```

### Get-DifyAppAPIKey

アプリの API キーを取得します。

```powershell
# API キーの取得（Get-DifyApp から直接パイプで指定）
Get-DifyApp -Name "..." | Get-DifyAppAPIKey

# API キーの取得（Get-DifyApp で取得した結果で指定）
$AppsToGetAPIKey = Get-DifyApp -Name "..."
Get-DifyAppAPIKey -App $AppsToGetAPIKey
```

### New-DifyAppAPIKey

アプリの API キーを作成します。

```powershell
# API キーの作成（Get-DifyApp から直接パイプで指定）
Get-DifyApp -Name "..." | New-DifyAppAPIKey

# API キーの作成（Get-DifyApp で取得した結果で指定）
$AppsToCreateAPIKey = Get-DifyApp -Name "..."
```

### Remove-DifyAppAPIKey

アプリの API キーを削除します。

```powershell
# API キーの削除（Get-DifyAppAPIKey から直接パイプで指定）
Get-DifyApp -Name "..." | Get-DifyAppAPIKey | Remove-DifyAppAPIKey

# API キーの削除（Get-DifyAppAPIKey で取得した結果で指定）
$APIKeysToBeRemoved = Get-DifyApp -Name "..." | Get-DifyAppAPIKey
Remove-DifyAppAPIKey -APIKey $APIKeysToBeRemoved
```

## ✨ ナレッジの管理

### Get-DifyKnowledge

ナレッジの情報を取得します。

```powershell
# ナレッジの取得（全て）
Get-DifyKnowledge

# ナレッジの取得（ID で指定）
Get-DifyKnowledge -Id "..."

# ナレッジの取得（名前で指定、完全一致）
Get-DifyKnowledge -Name "..."

# ナレッジの取得（名前で指定、部分一致）
Get-DifyKnowledge -Search "..."

# ナレッジの取得（タグで指定、複数指定可）
Get-DifyKnowledge -Tags "...", "..."
```

### New-DifyKnowledge

空のナレッジを作成します。

```powershell
# ナレッジの作成
New-DifyKnowledge -Name "My New Knowledge"

# ナレッジの作成（説明文を追加）
New-DifyKnowledge -Name "My New Knowledge" -Description "This is a new knowledge."
```

### Remove-DifyKnowledge

ナレッジを削除します。

```powershell
# ナレッジの削除（Get-DifyKnowledge から直接パイプで指定）
Get-DifyKnowledge -Name "..." | Remove-DifyKnowledge

# ナレッジの削除（Get-DifyKnowledge で取得した結果で指定）
$KnowledgesToBeRemoved = Get-DifyKnowledge -Name "..."
Remove-DifyKnowledge -Knowledge $KnowledgesToBeRemoved
```

### Get-DifyDocument

ナレッジ内のドキュメントの情報を取得します。

```powershell
# ドキュメントの取得（全て、Get-Knowledge から直接パイプで指定）
Get-DifyKnowledge -Name "..." | Get-DifyDocument

# ドキュメントの取得（全て、Get-DifyKnowledge で取得した結果で指定）
$Knowledge = Get-DifyKnowledge -Name "..."
Get-DifyDocument -Knowledge $Knowledge

# ドキュメントの取得（ID で指定）
Get-DifyKnowledge -Name "..." | Get-DifyDocument -Id "..."

# ドキュメントの取得（名前で指定、完全一致）
Get-DifyKnowledge -Name "..." | Get-DifyDocument -Name "..."

# ドキュメントの取得（名前で指定、部分一致）
Get-DifyKnowledge -Name "..." | Get-DifyDocument -Search "..."
```

### Add-DifyDocument

ナレッジにドキュメントをアップロードします。デフォルトで、自動、高品質、システムモデル、ベクトル検索の設定が適用されます。

現時点では細かい設定変更には対応していません。

```powershell
# 前提： アップロードするナレッジを取得
$Knowledge = Get-DifyKnowledge -Name "My New Knowledge"

# ドキュメントのアップロード（ファイルパスで指定、ワイルドカード可、複数指定可）
Add-DifyDocument -Knowledge $Knowledge -Path "Docs/*.md"

# ドキュメントのアップロード（Get-Item や Get-ChildItem からパイプで指定）
Get-Item -Path "Docs/*.md" | Add-DifyDocument -Knowledge $Knowledge

# ドキュメントのアップロード（チャンク設定を指定）
## チャンク設定： "automatic", "custom"
Add-DifyDocument -Knowledge $Knowledge -Path "Docs/*.md" -ChunkMode "custom"

# ドキュメントのアップロード（任意のモデルを利用）
$EmbeddingModel = Get-DifyModel -Provider "openai" -Name "text-embedding-3-small"
Add-DifyDocument -Knowledge $Knowledge -Path "Docs/*.md" -IndexMode "high_quality" -Model $EmbeddingModel

# ドキュメントのアップロード（エコノミーモードを利用）
Add-DifyDocument -Knowledge $Knowledge -Path "Docs/*.md" -IndexMode "economy"

# インデキシングの完了を待つ
Add-DifyDocument -Knowledge $Knowledge -Path "Docs/*.md" -Wait

# 待つ時間を変更
Add-DifyDocument -Knowledge $Knowledge -Path "Docs/*.md" -Wait -Interval 10 -Timeout 600
```

### Remove-DifyDocument

ドキュメントを削除します。

```powershell
# ドキュメントの削除（Get-DifyDocument から直接パイプで指定）
Get-DifyKnowledge -Name "..." | Get-DifyDocument | Remove-DifyDocument

# ドキュメントの削除（Get-DifyDocument で取得した結果で指定）
$DocumentsToBeRemoved = Get-DifyKnowledge -Name "..." | Get-DifyDocument
Remove-DifyDocument -Document $DocumentsToBeRemoved
```

## ✨ メンバの管理

### Get-DifyMember

ワークスペースのメンバの情報を取得します。

```powershell
# メンバの取得（全て）
Get-DifyMember

# メンバの取得（ID で指定）
Get-DifyMember -Id "..."

# メンバの取得（名前で指定）
Get-DifyMember -Name "..."

# メンバの取得（メールアドレスで指定）
Get-DifyMember -Email "..."
```

### New-DifyMember

ワークスペースに新しいメンバを追加（招待）します。

```powershell
# メンバの招待
## ロール： "admin", "editor", "normal"
New-DifyMember -Email "dify@example.com" -Role "normal" -Language "en-US"
```

### Remove-DifyMember

ワークスペースからメンバを削除します。

```powershell
# メンバの削除（Get-DifyMember から直接パイプで指定）
Get-DifyMember -Name "..." | Remove-DifyMember

# メンバの削除（Get-DifyMember で取得した結果で指定）
$MembersToBeRemoved = Get-DifyMember -Name "..."
Remove-DifyMember -Member $MembersToBeRemoved
```

### Set-DifyMemberRole

ワークスペースのメンバのロールを変更します。

```powershell
# メンバのロールの変更（Get-DifyMember から直接パイプで指定）
Get-DifyMember -Name "..." | Set-DifyMemberRole -Role "editor"

# メンバのロールの変更（Get-DifyMember で取得した結果で指定）
$MembersToBeChanged = Get-DifyMember -Name "..."
Set-DifyMemberRole -Member $MembersToBeChanged -Role "editor"
```

## ✨ モデルの管理

### Get-DifyModel

ワークスペースのモデルの情報を取得します。

```powershell
# モデルの取得（全て）
Get-DifyModel

# モデルの取得（プロバイダで指定）
Get-DifyModel -Provider "..."

# モデルの取得（モデルの種類で指定）
## モデルの種類： "predefined", "customizable"
Get-DifyModel -From "..."

# モデルの取得（モデルの名前で指定）
Get-DifyModel -Name "..."

# モデルの取得（モデルのタイプで指定）
## モデルタイプ： "llm", "text-embedding", "speech2text", "moderation", "tts", "rerank"
Get-DifyModel -Type "..."

# モデルの取得（組み合わせ例）
Get-DifyModel -Provider "..." -Type "llm"
```

### New-DifyModel

ワークスペースに新しいモデルを追加します。`Credential` で渡す必要のある情報はプロバイダやモデルに依存するため、ブラウザの開発者ツールなどで実際の HTTP リクエストを確認してください。

```powershell
# モデルの追加（事前定義モデルの追加、OpenAI の例）
New-DifyModel -Provider "openai" -From "predefined" `
  -Credential @{
    "openai_api_key" = "sk-proj-****************"
  }

# モデルの追加（事前定義モデルの追加、Cohere の例）
New-DifyModel -Provider "cohere" -From "predefined" `
  -Credential @{
    "api_key" = "****************************************"
  }

# モデルの追加（カスタムモデルの追加、OpenAI の例）
New-DifyModel -Provider "openai" -From "customizable" `
  -Type "llm" -Name "gpt-4o-mini" `
  -Credential @{
    "openai_api_key" = "sk-proj-****************"
  }

# モデルの追加（カスタムモデルの追加、Cohere の例）
New-DifyModel -Provider "cohere" -From "customizable" `
  -Type "llm" -Name "command-r-plus" `
  -Credential @{
    "mode"    = "chat"
    "api_key" = "****************************************"
  }
```

### Remove-DifyModel

ワークスペースからモデルを削除します。

```powershell
# モデルの削除（Get-DifyModel から直接パイプで指定）
Get-DifyModel -Name "..." | Remove-DifyModel

# モデルの削除（Get-DifyModel で取得した結果で指定）
$ModelsToBeRemoved = Get-DifyModel -Name "..."
Remove-DifyModel -Model $ModelsToBeRemoved
```

### Get-DifySystemModel

ワークスペースのシステムモデルの情報を取得します。

```powershell
# システムモデルの取得
Get-DifySystemModel

# システムモデルの取得（モデルのタイプで指定）
## タイプ： "llm", "text-embedding", "rerank", "speech2text", "tts"
Get-DifySystemModel -Type "..."
```

### Set-DifySystemModel

ワークスペースのシステムモデルを変更します。

```powershell
# システムモデルの変更
Set-DifySystemModel -Type "llm" -Provider "openai" -Name "gpt-4o-mini"

# システムモデルの変更（Get-DifySystemModel から直接パイプで指定）
Get-DifySystemModel -Type "llm" -Provider "openai" -Name "gpt-4o-mini" | Set-DifySystemModel

# システムモデルの変更（Get-DifySystemModel で取得した結果で指定）
$SystemModelToBeChanged = Get-DifySystemModel -Type "llm" -Provider "openai" -Name "gpt-4o-mini"
Set-DifySystemModel -Model $SystemModelToBeChanged
```

## ✨ タグの管理

### Get-DifyTag

タグの情報を取得します。

```powershell
# タグの取得（タイプで指定）
## タイプ： "app", "knowledge"
Get-DifyTag -Type "app"

# タグの取得（ID で指定）
Get-DifyTag -Type "app" -Id "..."

# タグの取得（名前で指定）
Get-DifyTag -Type "app" -Name "..."
```

### Get-DifyAppTag

アプリ用のタグの情報を取得します。`Get-DifyTag -Type "app"` と同じです。

```powershell
# アプリ用のタグの取得
Get-DifyAppTag

# アプリ用のタグの取得（ID で指定）
Get-DifyAppTag -Id "..."

# アプリ用のタグの取得（名前で指定）
Get-DifyAppTag -Name "..."
```

### Get-DifyKnowledgeTag

ナレッジ用のタグの情報を取得します。`Get-DifyTag -Type "knowledge"` と同じです。

```powershell
# ナレッジ用のタグの取得
Get-DifyKnowledgeTag

# ナレッジ用のタグの取得（ID で指定）
Get-DifyKnowledgeTag -Id "..."

# ナレッジ用のタグの取得（名前で指定）
Get-DifyKnowledgeTag -Name "..."
```

## ✨ 情報取得

### Get-DifyVersion

Dify のバージョン情報を取得します。

```powershell
# バージョン情報の取得
Get-DifyVersion
```

### Get-DifyProfile

認証したアカウントの情報を取得します。

```powershell
# アカウント情報の取得
Get-DifyProfile
```

## ✨ インスタンスの初期設定

### Wait-Dify

Dify の起動完了を待ちます。`docker compose up -d` を実行したあとに使うと便利です。

```powershell
# Dify の起動完了を待つ
Wait-Dify -Server "https://dify.example.com"

# Dify の起動完了を待つ（確認間隔やタイムアウトを指定）
Wait-Dify -Server "https://dify.example.com" -Interval 5 -Timeout 300
```

### Initialize-Dify

管理者アカウントを作成します（コミュニティ版のみ）。正常に完了すると、管理者アカウントで `Connect-Dify` を実行した状態と同じになります。

```powershell
# 管理者アカウントの作成（実行後、管理者アカウントのパスワードを手動で入力する）
Initialize-Dify -Server "https://dify.example.com" -Email "dify@example.com"

# 管理者アカウントの作成（パスワードを事前に指定する）
$DifyPassword = ConvertTo-SecureString -String "AwesomeDify123!" -AsPlainText -Force
Initialize-Dify -Server "https://dify.example.com" -Email "dify@example.com" -Password $DifyPassword

# 管理者アカウントの作成（Dify に INIT_PASSWORD を指定していて、パスワードを事前に指定する場合）
$DifyInitPassword = ConvertTo-SecureString -String "AwesomeDifyInitPassword123!" -AsPlainText -Force
$DifyPassword = ConvertTo-SecureString -String "AwesomeDify123!" -AsPlainText -Force
Initialize-Dify -Server "https://dify.example.com" -Email "dify@example.com" -InitPassword $DifyInitPassword -Password $DifyPassword
```

> [!NOTE]
> 引数は、環境変数を使うと省略できます。
>
> ```powershell
> $env:PSDIFY_URL = "https://dify.example.com"
> $env:PSDIFY_AUTH_METHOD = "Password"
> $env:PSDIFY_EMAIL = "dify@example.com"
> $env:PSDIFY_PASSWORD = "AwesomeDify123!"
> $env:PSDIFY_DISABLE_SSL_VERIFICATION = "true"  # 自己署名証明書を使っている場合
> $env:PSDIFY_INIT_PASSWORD = "AwesomeDifyInitPassword123!"  # Dify に INIT_PASSWORD を指定している場合
> ```

## ✨ その他

### Set-PSDifyConfiguration

HTTPS 接続時の証明書の検証を有効化または無効化できます。

```powershell
# 証明書の検証を無効にする
Set-PSDifyConfiguration -IgnoreSSLVerification $true

# 証明書の検証を有効にする
Set-PSDifyConfiguration -IgnoreSSLVerification $false
```

### Add-DifyFile

ファイルをアップロードします。

```powershell
# ファイルのアップロード（ファイルパスで指定、ワイルドカード可、複数指定可）
Add-DifyFile -Path "Files/*"

# ファイルのアップロード（Get-Item や Get-ChildItem からパイプで指定）
Get-Item -Path "Files/*" | Add-DifyFile

# ファイルのアップロード（ソースを明示）
Get-Item -Path "Files/*" | Add-DifyFile -Source "..."
```

### Get-DifyDocumentIndexingStatus

ドキュメントのインデキシング状況を取得します。

```powershell
# インデキシング状況の取得（Add-DifyDocument から直接パイプで指定）
Add-DifyDocument -Knowledge $Knowledge -Path "Docs/*.md" | Get-DifyDocumentIndexingStatus

# インデキシング状況の取得（Add-DifyDocument で取得した結果で指定）
$DocumentToCheckIndexingStatus = Add-DifyDocument -Knowledge $Knowledge -Path "Docs/*.md"
Get-DifyDocumentIndexingStatus -Document $DocumentToCheckIndexingStatus

# インデキシング状況の取得（ナレッジとバッチ ID で指定）
Get-DifyDocumentIndexingStatus -Knowledge $Knowledge -Batch "..."

# インデキシング状況の取得（完了を待つ）
Get-DifyDocumentIndexingStatus -Knowledge $Knowledge -Batch "..." -Wait

# インデキシング状況の取得（待つ時間を変更）
Get-DifyDocumentIndexingStatus -Knowledge $Knowledge -Batch "..." -Wait -Interval 10 -Timeout 600
```

### Invoke-DifyRestMethod

REST API を呼び出します。

```powershell
# REST API の呼び出し（GET）
$Query = @{
    "page"  = 1
    "limit" = 100
}
Invoke-DifyRestMethod -Method "GET" -Uri "https://dify.example.com/console/api/apps" -Query $Query -Token $env:PSDIFY_CONSOLE_TOKEN

# REST API の呼び出し（POST）
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

# REST API の呼び出し（セッションを使う場合）
$DifySession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
Invoke-DifyRestMethod -Method "GET" -Uri "https://dify.example.com/console/api/setup" -Session $DifySession
```

## ✨ チャットの操作

### Send-DifyChatMessage

アプリにチャットメッセージを送信します。動作には次の環境変数が必要です。

- `$env:PSDIFY_APP_URL`
- `$env:PSDIFY_APP_TOKEN`

送信した内容と応答は `Logs` フォルダに保存されます。

```powershell
# 環境変数の設定
$env:PSDIFY_APP_URL = "https://dify.example.com"
$env:PSDIFY_APP_TOKEN = "app-****************"

# チャットメッセージの送信
Send-DifyChatMessage -Message "Hello, Dify!"

# チャットメッセージの送信（新しいセッションを開始）
Send-DifyChatMessage -Message "Hello, Dify!" -NewSession
```
