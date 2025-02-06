---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Get-DifyPluginInstallationStatus

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Retrieve the installation status of a plugin task in the Dify workspace.

## SYNTAX

```powershell
Get-DifyPluginInstallationStatus [[-TaskInfo] <PSObject>] [[-TaskId] <String>] [-Wait] [[-Interval] <Int32>]
 [[-Timeout] <Int32>] [<CommonParameters>]
```

## DESCRIPTION

The `Get-DifyPluginInstallationStatus` cmdlet retrieves the current status of a plugin installation task in a Dify workspace. The status includes information about the task, such as its ID, status, and associated plugins. You can optionally wait for the task to complete by using the `-Wait` parameter.

NOTE: This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## EXAMPLES

### Example 1

```powershell
$TaskInfo = Install-DifyPlugin -Id "plugin-id-123"
Get-DifyPluginInstallationStatus -TaskInfo $TaskInfo
```

Retrieve the installation status of a plugin task using task information returned from another cmdlet.

### Example 2

```powershell
Get-DifyPluginInstallationStatus -TaskId "1234567890" -Wait -Interval 10 -Timeout 600
```

Waits for the plugin task with the specified ID to complete, checking the status every 10 seconds and timing out after 600 seconds.

## PARAMETERS

### -Interval

Specifies the interval, in seconds, between status checks when using the `-Wait` parameter.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 5
Accept pipeline input: False
Accept wildcard characters: False
```

### -TaskId

Specifies the ID of the plugin task to retrieve the status for. Either `-TaskId` or `-TaskInfo` is required.

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

### -TaskInfo

Specifies the task information object to retrieve the status for. Either `-TaskId` or `-TaskInfo` is required.

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

### -Timeout

Specifies the maximum time, in seconds, to wait for the task to complete when using the `-Wait` parameter.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 300
Accept pipeline input: False
Accept wildcard characters: False
```

### -Wait

Indicates that the cmdlet should wait for the task to complete before returning.

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

### System.Management.Automation.PSObject

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
