---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Join-Url

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Joins URL segments with proper handling of slashes.

## SYNTAX

```powershell
Join-Url [-Segments] <String[]> [<CommonParameters>]
```

## DESCRIPTION

The `Join-Url` cmdlet combines multiple URL segments into a single URL path, properly handling the slashes between segments. This cmdlet is primarily used internally by other PSDify cmdlets to construct API endpoint URLs.

The cmdlet removes any leading or trailing slashes from each segment and then joins them with a single slash between each segment.

## EXAMPLES

### Example 1

```powershell
PS C:\> Join-Url -Segments @("https://example.com", "api", "v1", "resources")
```

Returns `https://example.com/api/v1/resources`

### Example 2

```powershell
PS C:\> Join-Url -Segments @("https://example.com/", "/api/", "/v1/", "/resources")
```

Returns `https://example.com/api/v1/resources` (removes redundant slashes)

## PARAMETERS

### -Segments

Specifies an array of URL segments to join. The cmdlet will handle the proper formatting of slashes between segments.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
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

## RELATED LINKS
