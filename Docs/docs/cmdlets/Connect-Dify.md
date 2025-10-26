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

Authenticate with Dify using password or email-based login, enabling operations with other PSDify cmdlets.

## SYNTAX

```powershell
Connect-Dify [[-Server] <String>] [[-AuthMethod] <String>] [[-Email] <String>] [[-Token] <String>]
 [[-Code] <String>] [[-Password] <SecureString>] [-Force]
 [<CommonParameters>]
```

## DESCRIPTION

The `Connect-Dify` cmdlet allows you to authenticate with a Dify server using various methods such as password-based login or email-based code authentication. After successful authentication, environment variables required for subsequent operations are set.

NOTE: This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## EXAMPLES

### Example 1

```powershell
Connect-Dify -AuthMethod "Code" -Email "dify@example.com"
```

Email authentication, mainly for the Dify Cloud Edition. Enter the code manually which will be sent to your email address after execution.

SSO-authenticated accounts can also log in via email authentication using the associated email address.

You can use following environment variables to simplify cmdlet arguments: `$env:PSDIFY_URL = "https://cloud.dify.ai"`, `$env:PSDIFY_AUTH_METHOD = "Code"`, `$env:PSDIFY_EMAIL = "dify@example.com"`.

### Example 2

```powershell
Connect-Dify -Server "https://dify.example.com" -Email "dify@example.com"
```

Password authentication, mainly for the Dify Community Edition. Enter the password manually after execution.

If using a self-signed certificate for HTTPS in the Community Edition, disable certificate verification by `Set-PSDifyConfiguration -IgnoreSSLVerification $true` or set `$env:PSDIFY_DISABLE_SSL_VERIFICATION = "true"` before invoking `Connect-Dify`.

You can use following environment variables to simplify cmdlet arguments: `$env:PSDIFY_URL = "https://dify.example.com"`, `$env:PSDIFY_AUTH_METHOD = "Password"`, `$env:PSDIFY_EMAIL = "dify@example.com`, `$env:PSDIFY_PASSWORD = "AwesomeDify123!"`.

### Example 3

```powershell
$DifyPassword = ConvertTo-SecureString -String "AwesomeDify123!" -AsPlainText -Force
Connect-Dify -Server "https://dify.example.com" -Email "dify@example.com" -Password $DifyPassword
```

Password authentication with predefined password.

## PARAMETERS

### -AuthMethod

Specifies the authentication method to use. Valid values are:

- `Password`: Authenticate using an email and password.
- `Code`: Authenticate using an email and a code sent via email.
- `Token`: Authenticate directly using a console access token.

This also can be set using the environment variable `$env:PSDIFY_AUTH_METHOD`. The default value is `Password`.

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

### -Email

Specifies the email address to use for authentication. This is required for both password-based and email-based code authentication methods.

This also can be set using the environment variable `$env:PSDIFY_EMAIL`.

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

This also can be set using the environment variable `$env:PSDIFY_PASSWORD`.

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

This also can be set using the environment variable `$env:PSDIFY_URL`.

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

Specifies the access token to use for token-based authentication.

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
