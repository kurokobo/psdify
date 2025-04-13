---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Initialize-Dify

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Initialize the Dify instance by creating an admin account (Community Edition only).

## SYNTAX

```powershell
Initialize-Dify [[-Server] <String>] [[-Email] <String>] [[-Name] <String>] [[-InitPassword] <SecureString>]
 [[-Password] <SecureString>] [<CommonParameters>]
```

## DESCRIPTION

The `Initialize-Dify` cmdlet is used to initialize the Dify instance by creating an admin account. This is applicable for the Community Edition of Dify. The cmdlet validates the initial setup password (if required), creates an admin account using the specified email and password, and logs in as the admin after successful initialization.

NOTE: This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## EXAMPLES

### Example 1

```powershell
Initialize-Dify -Server "https://dify.example.com" -Email "dify@example.com"
```

Create an admin account by entering the password manually after execution.

### Example 2

```powershell
$DifyPassword = ConvertTo-SecureString -String "AwesomeDify123!" -AsPlainText -Force
Initialize-Dify -Server "https://dify.example.com" -Email "dify@example.com" -Password $DifyPassword
```

Create an admin account using a predefined password.

### Example 3

```powershell
$DifyInitPassword = ConvertTo-SecureString -String "AwesomeDifyInitPassword123!" -AsPlainText -Force
$DifyPassword = ConvertTo-SecureString -String "AwesomeDify123!" -AsPlainText -Force
Initialize-Dify -Server "https://dify.example.com" -Email "dify@example.com" -InitPassword $DifyInitPassword -Password $DifyPassword
```

Create an admin account using a predefined init password (if `INIT_PASSWORD` is specified for Dify).

## PARAMETERS

### -Email

Specifies the email address to be used for creating the admin account.

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

### -InitPassword

Specifies the initial setup password required to initialize the Dify instance. Typically used only for the Community Edition.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name

Specifies the name of the admin user. If not provided, the name will default to the part of the email before the "@" symbol.

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

### -Password

Specifies the password to be used for the admin account. If not provided, you will be prompted to enter it manually.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Server

Specifies the server URL of the Dify instance to be initialized. Defaults to <https://cloud.dify.ai> if not specified.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

- This cmdlet is only applicable for the Community Edition of Dify.
- Ensure that the `Server` parameter points to the correct Dify instance URL.
- You can use environment variables (`$env:PSDIFY_URL`, `$env:PSDIFY_EMAIL`, etc.) to simplify cmdlet arguments.

## RELATED LINKS
