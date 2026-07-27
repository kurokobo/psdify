---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Set-DifyApp

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Update basic settings of an app.

## SYNTAX

```powershell
Set-DifyApp [[-App] <PSObject[]>] [-SyncFromSite] [[-Name] <String>] [[-Description] <String>]
 [[-Icon] <String>] [[-IconType] <String>] [[-IconBackground] <String>]
 [<CommonParameters>]
```

## DESCRIPTION

The `Set-DifyApp` cmdlet updates basic settings of an app, such as its name, description, and icon. It accepts app objects from the pipeline, typically from `Get-DifyApp`.

When `-SyncFromSite` is specified, the app's name, description, and icon are updated to match the current WebApp (Site) settings. This switch cannot be combined with other parameters.

If icon-related parameters (`-Icon`, `-IconType`, `-IconBackground`) are omitted, the existing values are preserved.

NOTE: This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## EXAMPLES

### Example 1

```powershell
Get-DifyApp -Name "My App" | Set-DifyApp -Name "New Name"
```

Rename an app.

### Example 2

```powershell
Get-DifyApp -Name "My App" | Set-DifyApp -Description "New description"
```

Update the description of an app.

### Example 3

```powershell
Get-DifyApp -Name "My App" | Set-DifyApp -Icon "robot" -IconType "emoji"
```

Update the icon of an app. The `-Icon` parameter accepts an emoji-mart short name (e.g., `"robot"`) or a native emoji character (e.g., `"🤖"`).

### Example 4

```powershell
Get-DifyApp | Set-DifyApp -SyncFromSite
```

Sync all apps' name, description, and icon from their respective WebApp (Site) settings.

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

Specifies the new description for the app. If omitted, the existing description is preserved.

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

### -Icon

Specifies the icon for the app. Accepts an emoji-mart short name (e.g., `"robot"`, `"smile"`) or a native emoji character (e.g., `"🤖"`). If omitted, the existing icon is preserved.

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

Specifies the background color for the app icon in hex format (e.g., `"#FFEAD5"`). If omitted, the existing background color is preserved.

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

Specifies the icon type. Use `"emoji"` when specifying an emoji icon. If omitted, the existing icon type is preserved.

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

### -Name

Specifies the new name for the app. If omitted, the existing name is preserved.

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

### -SyncFromSite

When specified, updates the app's name, description, and icon to match the current WebApp (Site) settings. Cannot be combined with `-Name`, `-Description`, `-Icon`, `-IconType`, or `-IconBackground`.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Management.Automation.PSObject[]

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
