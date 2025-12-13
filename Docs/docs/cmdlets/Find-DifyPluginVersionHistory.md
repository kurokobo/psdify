---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Find-DifyPluginVersionHistory

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Retrieve version history for a specific plugin from the Dify Marketplace.

## SYNTAX

```powershell
Find-DifyPluginVersionHistory [[-Plugin] <PSObject>] [[-Id] <String>] [[-Version] <String>] [-Download]
 [<CommonParameters>]
```

## DESCRIPTION

The `Find-DifyPluginVersionHistory` cmdlet retrieves the version history of a specific plugin from the Dify Marketplace. You can retrieve all versions or a specific version of a plugin. This cmdlet uses the public Dify Marketplace and does not require a Dify server connection.

NOTE: This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## EXAMPLES

### Example 1

```powershell
Find-DifyPluginVersionHistory -Id "langgenius/openai"
```

Retrieve all version history for a specific plugin by its ID.

### Example 2

```powershell
Find-DifyPlugin -Id "langgenius/openai" | Find-DifyPluginVersionHistory
```

Retrieve all version history for a specific plugin by passing a plugin object through the pipeline.

### Example 3

```powershell
Find-DifyPluginVersionHistory -Id "langgenius/openai" -Version "0.0.1"
```

Retrieve a specific version of a plugin.

### Example 4

```powershell
Find-DifyPluginVersionHistory -Id "langgenius/openai" -Version "0.0.1" -Download
```

Download a specific version of a plugin package (.difypkg file) to the current directory.

## PARAMETERS

### -Download

Indicates that the cmdlet should download the specified version of the plugin to the current directory. When specified, the cmdlet returns FileInfo objects for the downloaded plugin package (.difypkg file) instead of version history information objects. This parameter requires the -Version parameter to be specified.

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

### -Id

Specifies the ID of the plugin to retrieve version history for. Either -Plugin or -Id parameter is required.

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

### -Plugin

Specifies a plugin object to retrieve version history for. This parameter accepts pipeline input from cmdlets like `Find-DifyPlugin`. Either -Plugin or -Id parameter is required.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Version

Specifies the version of the plugin to retrieve. If not specified, all versions in the history are returned.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Management.Automation.PSObject

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
