---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Get-DifyProfile

## SYNOPSIS

Retrieve the authenticated account's profile information.

## SYNTAX

```powershell
Get-DifyProfile [<CommonParameters>]
```

## DESCRIPTION

The `Get-DifyProfile` cmdlet retrieves the profile information of the currently authenticated account. It fetches details such as the account ID, name, email, interface language, timezone, last login information, and the account creation date.

## EXAMPLES

### Example 1

```powershell
Get-DifyProfile
```

Retrieve and display the profile information of the currently authenticated account.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

- Ensure that the `$env:PSDIFY_CONSOLE_TOKEN` environment variable is correctly set and contains a valid token prior to running this cmdlet.
- Errors will be thrown if the profile data cannot be retrieved.

## RELATED LINKS
