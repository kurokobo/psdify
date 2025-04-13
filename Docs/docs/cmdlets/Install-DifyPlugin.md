---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Install-DifyPlugin

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Install plugins from the Dify Marketplace into the current workspace.

## SYNTAX

### Marketplace (Default)

```powershell
Install-DifyPlugin [-Item <PSObject[]>] [-Id <String[]>] [-UniqueIdentifier <String[]>] [-Wait]
 [-Interval <Int32>] [-Timeout <Int32>] [<CommonParameters>]
```

### LocalFile

```powershell
Install-DifyPlugin -LocalFile <Object> [-Wait] [-Interval <Int32>] [-Timeout <Int32>]
 [<CommonParameters>]
```

### RemoteFile

```powershell
Install-DifyPlugin -RemoteFile <String> [-Wait] [-Interval <Int32>] [-Timeout <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION

The `Install-DifyPlugin` cmdlet installs plugins from the Dify Marketplace into the current workspace. You can specify plugins to install by their ID, unique identifier, or via pipeline input.

If the `-Wait` parameter is specified, the cmdlet waits for the installation task to complete and returns the installed plugins. Otherwise, it returns a task object with installation status information.

NOTE: This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## EXAMPLES

### Example 1

```powershell
Install-DifyPlugin -Id "plugin-id-123" -Wait
```

Install a plugin with the specified ID and wait for the installation to complete.

### Example 2

```powershell
Install-DifyPlugin -UniqueIdentifier "unique-plugin-456" -Interval 10 -Timeout 600 -Wait
```

Install a plugin using its unique identifier, wait for the installation to complete, and specify custom interval and timeout settings.

### Example 3

```powershell
$Plugins = Find-DifyPlugin -Search "example"
Install-DifyPlugin -Item $Plugins -Wait
```

Search for plugins using `Find-DifyPlugin` and install the resulting plugins.

### Example 4

```powershell
Install-DifyPlugin -LocalFile ".\path\to\plugin.difypkg" -Wait
```

Install a plugin from a local file. `Find-DifyPlugin` can be used to download plugins with `-Download` switch.

### Example 5

```powershell
Install-DifyPlugin -RemoteFile "https://example.com/path/to/plugin.difypkg" -Wait
```

Install a plugin from a remote URL. The file will be downloaded to a temporary location and then installed.

## PARAMETERS

### -Id

Specifies the IDs of the plugins to install.

```yaml
Type: String[]
Parameter Sets: Marketplace
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Interval

Specifies the interval, in seconds, between status checks when `-Wait` is used.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 5
Accept pipeline input: False
Accept wildcard characters: False
```

### -Item

Specifies the plugin objects to install. This parameter can accept pipeline input.

```yaml
Type: PSObject[]
Parameter Sets: Marketplace
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -LocalFile

Specifies a local plugin package file (.difypkg) to install. This parameter accepts either a FileInfo object (from Get-Item) or a string path to the plugin package file. This allows you to install plugins that you've previously downloaded using Find-DifyPlugin with the -Download switch.

```yaml
Type: Object
Parameter Sets: LocalFile
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RemoteFile

Specifies a URL to a remote plugin package file (.difypkg) to install. The file will be downloaded to a temporary location and then installed. This allows you to install plugins directly from a web server or file hosting service without having to download them manually first.

```yaml
Type: String
Parameter Sets: RemoteFile
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Timeout

Specifies the timeout, in seconds, for the installation task when `-Wait` is used.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 300
Accept pipeline input: False
Accept wildcard characters: False
```

### -UniqueIdentifier

Specifies the unique identifiers of the plugins to install.

```yaml
Type: String[]
Parameter Sets: Marketplace
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Wait

Indicates that the cmdlet waits for the installation task to complete before returning.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Management.Automation.PSObject[]

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
