---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Connect-Dify

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Authenticate with Dify using password, pre-obtained access token, or email-based login enabling operations with other PSDify cmdlets.

## SYNTAX

```powershell
Connect-Dify [[-Server] <String>] [[-AuthMethod] <String>] [[-Email] <String>] [[-Token] <String>]
 [[-Code] <String>] [[-Password] <SecureString>] [-AccessToken <SecureString>] [-CSRFToken <SecureString>]
 [-Force] [<CommonParameters>]
```

## DESCRIPTION

The `Connect-Dify` cmdlet allows you to authenticate with a Dify server using various methods such as password-based login, access token authentication, or email-based code authentication. After successful authentication, some variables required for subsequent operations are set.

NOTE: This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## EXAMPLES

### Example 1

```powershell
Connect-Dify -Server "https://dify.example.com" -Email "dify@example.com"
```

Password authentication, mainly for the Dify Community Edition. Enter the password manually after execution.

If using a self-signed certificate for HTTPS in the Community Edition, disable certificate verification by `Set-PSDifyConfiguration -IgnoreSSLVerification $true` or set `$env:PSDIFY_DISABLE_SSL_VERIFICATION = "true"` before invoking `Connect-Dify`.

You can use following environment variables to simplify cmdlet arguments: `$env:PSDIFY_URL = "https://dify.example.com"`, `$env:PSDIFY_AUTH_METHOD = "Password"`, `$env:PSDIFY_EMAIL = "dify@example.com"`, `$env:PSDIFY_PASSWORD = "AwesomeDify123!"`.

### Example 2

```powershell
$DifyPassword = ConvertTo-SecureString -String "AwesomeDify123!" -AsPlainText -Force
Connect-Dify -Server "https://dify.example.com" -Email "dify@example.com" -Password $DifyPassword
```

Password authentication with predefined password.

### Example 3

```powershell
$AccessToken = ConvertTo-SecureString -String "eyJhbGci..." -AsPlainText -Force
$CSRFToken = ConvertTo-SecureString -String "eyJhbGci..." -AsPlainText -Force
Connect-Dify -Server "https://cloud.dify.ai" -AuthMethod "AccessToken" -AccessToken $AccessToken -CSRFToken $CSRFToken
```

Access token authentication using a pre-obtained access token and CSRF token. This method is available for Dify 1.9.2 or later.

This method is particularly useful in environments where password-based authentication is not available, such as:

- Dify Cloud Edition (`cloud.dify.ai`), where email code authentication is blocked by Cloudflare Turnstile and cannot be used outside of a browser.
- Dify Enterprise Edition with SSO (Single Sign-On) enabled, where direct password login is not supported.

The companion Chrome/Edge extension "PSDify Helper" can copy the complete login command to your clipboard with a single right-click after logging in to Dify in your browser. For details, refer to the "Browser Extension" page in the PSDify documentation.

Alternatively, you can obtain the `access_token` and `csrf_token` manually from your browser's cookies after logging in, and pass them to this cmdlet.

You can use following environment variables to simplify cmdlet arguments: `$env:PSDIFY_URL = "https://cloud.dify.ai"`, `$env:PSDIFY_AUTH_METHOD = "AccessToken"`, `$env:PSDIFY_ACCESS_TOKEN = "eyJhbGci..."`, `$env:PSDIFY_CSRF_TOKEN = "eyJhbGci..."`.

### Example 4

```powershell
Connect-Dify -AuthMethod "Code" -Email "dify@example.com"
```

Email authentication using a one-time code, mainly for self-hosted Dify instances where email code login is enabled.

NOTE: This method is not available on Dify Cloud (`cloud.dify.ai`). Dify Cloud requires Cloudflare Turnstile verification when requesting an email code, which cannot be completed outside of a browser. Use `-AuthMethod AccessToken` for Dify Cloud instead.
The PSDify Helper browser extension makes this easy with a single right-click. See the "Browser Extension" page in the PSDify documentation for details.

SSO-authenticated accounts on self-hosted instances can also log in via email authentication using the associated email address.

You can use following environment variables to simplify cmdlet arguments: `$env:PSDIFY_URL = "https://dify.example.com"`, `$env:PSDIFY_AUTH_METHOD = "Code"`, `$env:PSDIFY_EMAIL = "dify@example.com"`.

## PARAMETERS

### -AccessToken

Specifies the access token for access token authentication. This parameter accepts a secure string.

This also can be set using the environment variable `$env:PSDIFY_ACCESS_TOKEN`. If both are provided, the argument takes priority.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AuthMethod

Specifies the authentication method to use. Valid values are:

- `Password`: Authenticate using an email and password.
- `Code`: Authenticate using an email and a code sent via email. Not available on Dify Cloud (`cloud.dify.ai`) due to Cloudflare Turnstile verification requirements.
- `AccessToken`: Authenticate using a pre-obtained access token and CSRF token. Requires Dify 1.9.2 or later.

This also can be set using the environment variable `$env:PSDIFY_AUTH_METHOD`. If both are provided, the argument takes priority. The default value is `Password`.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Code

Specifies the one-time code sent to the email address for email-based code authentication.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CSRFToken

Specifies the CSRF token for access token authentication. This parameter accepts a secure string.

This also can be set using the environment variable `$env:PSDIFY_CSRF_TOKEN`. If both are provided, the argument takes priority.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Email

Specifies the email address to use for authentication. This is required for both password-based and email-based code authentication methods.

This also can be set using the environment variable `$env:PSDIFY_EMAIL`. If both are provided, the argument takes priority.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force

Forces re-authentication even if valid tokens are already set in the environment variables.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password

Specifies the password to use for password-based authentication. This parameter accepts a secure string.

This also can be set using the environment variable `$env:PSDIFY_PASSWORD`. If both are provided, the argument takes priority.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Server

Specifies the server URL to connect to. If not specified, the default value is `https://cloud.dify.ai`.

This also can be set using the environment variable `$env:PSDIFY_URL`. If both are provided, the argument takes priority.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Token

Specifies the validation token to use for code-based authentication.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

After a successful authentication, the following variables, along with others, are set:

- `$script:PSDIFY_CONSOLE_AUTH`
- `$env:PSDIFY_URL`
- `$env:PSDIFY_VERSION`

If these variables are already set and valid, re-authentication is not performed unless the `-Force` parameter is specified.

## RELATED LINKS
