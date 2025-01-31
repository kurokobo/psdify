---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Set-PSDifyConfiguration

## SYNOPSIS

Enable or disable SSL certificate verification for HTTPS connections.

## SYNTAX

```powershell
Set-PSDifyConfiguration [[-IgnoreSSLVerification] <Boolean>]
 [<CommonParameters>]
```

## DESCRIPTION

The `Set-PSDifyConfiguration` cmdlet allows you to enable or disable SSL certificate verification for HTTPS connections. This is particularly useful when working with self-signed certificates or development environments where SSL verification may not be required.

## EXAMPLES

### Example 1

```powershell
Set-PSDifyConfiguration -IgnoreSSLVerification $true
```

Disable certificate verification.

### Example 2

```powershell
Set-PSDifyConfiguration -IgnoreSSLVerification $false
```

Enable certificate verification.

## PARAMETERS

### -IgnoreSSLVerification

Specifies whether SSL certificate verification should be ignored. If set to `$true`, SSL verification is disabled. If set to `$false`, SSL verification is enabled.

```yaml
Type: Boolean
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

This cmdlet updates the `$env:PSDIFY_DISABLE_SSL_VERIFICATION` environment variable based on the value of the `-IgnoreSSLVerification` parameter. The updated setting affects the behavior of HTTPS connections in subsequent PSDify cmdlets.

## RELATED LINKS
