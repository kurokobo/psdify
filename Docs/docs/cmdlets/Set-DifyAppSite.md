---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Set-DifyAppSite

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Update WebApp (Site) settings or enable/disable WebApp access for an app.

## SYNTAX

```powershell
Set-DifyAppSite [[-App] <PSObject[]>] [-Enable] [-Disable] [-SyncFromApp] [[-Title] <String>]
 [[-Description] <String>] [[-Icon] <String>] [[-IconType] <String>] [[-IconBackground] <String>]
 [[-Language] <String>] [<CommonParameters>]
```

## DESCRIPTION

The `Set-DifyAppSite` cmdlet updates the WebApp (Site) settings for an app. It can enable or disable WebApp access, update configuration such as title, description, icon, and language, or sync settings from the app itself.

At least one parameter must be specified. `-SyncFromApp` cannot be combined with any other parameter. `-Enable` and `-Disable` cannot be combined with each other, but either can be combined with other settings parameters.

NOTE: This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## EXAMPLES

### Example 1

```powershell
Get-DifyApp -Name "My App" | Set-DifyAppSite -Enable
```

Enable WebApp access for the specified app.

### Example 2

```powershell
Get-DifyApp | Set-DifyAppSite -Disable
```

Disable WebApp access for all apps.

### Example 3

```powershell
Get-DifyApp -Name "My App" | Set-DifyAppSite -Title "My App" -Language "ja-JP"
```

Update the WebApp title and default language for the specified app.

### Example 4

```powershell
Get-DifyApp -Name "My App" | Set-DifyAppSite -Enable -Title "My App"
```

Enable WebApp access and update the title in a single operation.

### Example 5

```powershell
Get-DifyApp | Set-DifyAppSite -SyncFromApp
```

Sync all apps' WebApp title, description, and icon from the respective app settings.

## PARAMETERS

### -App

Specifies the app objects to update. This parameter accepts pipeline input from `Get-DifyApp`.

```yaml
Type: PSObject[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Description

Specifies the new description shown on the WebApp page.

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

### -Disable

Disables WebApp access for the app. Cannot be combined with `-Enable` or `-SyncFromApp`.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Enable

Enables WebApp access for the app. Cannot be combined with `-Disable` or `-SyncFromApp`.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Icon

Specifies the icon shown on the WebApp page. Accepts an emoji-mart short name (e.g., `"robot"`, `"smile"`) or a native emoji character (e.g., `"🤖"`).

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

### -IconBackground

Specifies the background color for the WebApp icon in hex format (e.g., `"#FFEAD5"`).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IconType

Specifies the icon type for the WebApp. Use `"emoji"` when specifying an emoji icon.

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

### -Language

Specifies the default language for the WebApp. For example, `"en-US"` or `"ja-JP"`.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SyncFromApp

When specified, updates the WebApp title, description, and icon to match the current app settings. Cannot be combined with any other parameter.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title

Specifies the title shown on the WebApp page.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Management.Automation.PSObject[]

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
