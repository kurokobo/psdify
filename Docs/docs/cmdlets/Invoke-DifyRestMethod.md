---
external help file: PSDify-help.xml
Module Name: PSDify
online version:
schema: 2.0.0
---

# Invoke-DifyRestMethod

!!! warning

    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## SYNOPSIS

Invokes REST API methods for Dify.

## SYNTAX

```powershell
Invoke-DifyRestMethod [[-Uri] <String>] [[-Method] <String>] [[-ContentType] <String>] [[-Body] <String>]
 [[-Query] <Hashtable>] [[-Token] <String>] [[-Session] <WebRequestSession>] [[-InFile] <String>]
 [-SessionOrToken <Object>] [<CommonParameters>]
```

## DESCRIPTION

`Invoke-DifyRestMethod` enables users to interact with the Dify REST API by constructing and sending HTTP requests. It supports GET, POST, PUT, PATCH, and DELETE methods. Users can specify URIs, headers, query parameters, and request bodies, as well as manage authentication via tokens or sessions.

NOTE: This help was primarily created by a generative AI. It may contain partially inaccurate expressions.

## EXAMPLES

### Example 1

```powershell
$Query = @{
    "page"  = 1
    "limit" = 100
}
Invoke-DifyRestMethod -Method "GET" -Uri "https://dify.example.com/console/api/apps" -Query $Query -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
```

Invoke REST API (GET).

### Example 2

```powershell
$Body =  @{
    "model_settings" = @(
        @{
            "model_type" = "llm"
            "provider"   = "openai"
            "model"      = "gpt-4o-mini"
        }
    )
} | ConvertTo-Json
Invoke-DifyRestMethod -Method "POST" -Uri "https://dify.example.com/console/api/workspaces/current/default-model" -Body $Body -SessionOrToken $script:PSDIFY_CONSOLE_AUTH
```

Invoke REST API (POST).

### Example 3

```powershell
$DifySession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
Invoke-DifyRestMethod -Method "GET" -Uri "https://dify.example.com/console/api/setup" -Session $DifySession
```

Invoke REST API using a session.

## PARAMETERS

### -Body

Specifies the body content of the HTTP request. Typically used for POST, PUT, or PATCH methods.

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

### -ContentType

Defines the content type of the request. The default is "application/json".

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

### -InFile

Specifies the path to a file to be used as input for the request body.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Method

Specifies the HTTP method to use, such as GET, POST, PUT, PATCH, or DELETE. The default is GET.

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

### -Query

Defines query parameters to append to the URI as a hashtable.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Session

Specifies a web request session to use for the HTTP request. This has the priority over the SessionOrToken parameter.

```yaml
Type: WebRequestSession
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SessionOrToken

Specifies either a WebRequestSession object or a bearer token string for authentication.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Token

Specifies the bearer token for authentication. This has the priority over the SessionOrToken parameter.

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

### -Uri

Specifies the full URI for the API request.

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

## RELATED LINKS
