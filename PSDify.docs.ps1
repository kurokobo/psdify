Import-Module -Name .\PSDify.psd1 -Force
$OutputFolder = "Docs/docs/cmdlets"

function Remove-Notes {
    param(
        [Parameter(Mandatory)]
        [string]
        $Path
    )
    $Content = Get-Content -Path $Path -Raw

    $Content = $Content -replace '!!! warning\r\n\r\n    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.\r\n\r\n', ''
    $Content | Out-File -Encoding utf8 -FilePath $Path
}
Get-ChildItem -Path $OutputFolder -Filter "*.md" | ForEach-Object {
    Remove-Notes -Path $_.FullName
}

# Create new markdown help files
# $parameters = @{
#     Module                = "PSDify"
#     OutputFolder          = $OutputFolder
#     AlphabeticParamsOrder = $true
#     ExcludeDontShow       = $true
#     Encoding              = [System.Text.Encoding]::UTF8
# }
# New-MarkdownHelp @parameters

# Update markdown help files
$Parameters = @{
    Path                  = $OutputFolder
    AlphabeticParamsOrder = $true
    UpdateInputOutput     = $true
    ExcludeDontShow       = $true
    Encoding              = [System.Text.Encoding]::UTF8
    Force                 = $true
}
Update-MarkdownHelpModule @Parameters

# Remove "-ProgressAction": https://github.com/PowerShell/platyPS/issues/595#issuecomment-1850775410
function Remove-CommonParameterFromMarkdown {
    param(
        [Parameter(Mandatory)]
        [string[]]
        $Path,

        [Parameter(Mandatory = $false)]
        [string[]]
        $ParameterName = @('ProgressAction')
    )
    $ErrorActionPreference = 'Stop'
    foreach ($p in $Path) {
        $content = (Get-Content -Path $p -Raw).TrimEnd()
        $updateFile = $false
        foreach ($param in $ParameterName) {
            if (-not ($Param.StartsWith('-'))) {
                $param = "-$($param)"
            }
            # Remove the parameter block
            $pattern = "(?m)^### $param\r?\n[\S\s]*?(?=#{2,3}?)"
            $newContent = $content -replace $pattern, ''
            # Remove the parameter from the syntax block
            $pattern = " \[$param\s?.*?]"
            $newContent = $newContent -replace $pattern, ''
            if ($null -ne (Compare-Object -ReferenceObject $content -DifferenceObject $newContent)) {
                Write-Verbose "Added $param to $p"
                # Update file content
                $content = $newContent
                $updateFile = $true
            }
        }
        # Save file if content has changed
        if ($updateFile) {
            $newContent | Out-File -Encoding utf8 -FilePath $p
            Write-Verbose "Updated file: $p"
        }
    }
    return
}
function Add-MissingCommonParameterToMarkdown {
    param(
        [Parameter(Mandatory)]
        [string[]]
        $Path,

        [Parameter(Mandatory = $false)]
        [string[]]
        $ParameterName = @('ProgressAction')
    )
    $ErrorActionPreference = 'Stop'
    foreach ($p in $Path) {
        $content = (Get-Content -Path $p -Raw).TrimEnd()
        $updateFile = $false
        foreach ($NewParameter in $ParameterName) {
            if (-not ($NewParameter.StartsWith('-'))) {
                $NewParameter = "-$($NewParameter)"
            }
            $pattern = '(?m)^This cmdlet supports the common parameters:(.+?)\.'
            $replacement = {
                $Params = $_.Groups[1].Captures[0].ToString() -split ' '
                $CommonParameters = @()
                foreach ($CommonParameter in $Params) {
                    if ($CommonParameter.StartsWith('-')) {
                        if ($CommonParameter.EndsWith(',')) {
                            $CleanParam = $CommonParameter.Substring(0, $CommonParameter.Length -1)
                        } elseif ($p.EndsWith('.')) {
                            $CleanParam = $CommonParameter.Substring(0, $CommonParameter.Length -1)
                        } else{
                            $CleanParam = $CommonParameter
                        }
                        $CommonParameters += $CleanParam
                    }
                }
                if ($NewParameter -notin $CommonParameters) {
                    $CommonParameters += $NewParameter
                }
                $CommonParameters = ($CommonParameters | Sort-Object)
                $CommonParameters[-1] = "and $($CommonParameters[-1])."
                return "This cmdlet supports the common parameters: " + (($CommonParameters) -join ', ')
            }
            $newContent = $content -replace $pattern, $replacement
            if ($null -ne (Compare-Object -ReferenceObject $content -DifferenceObject $newContent)) {
                Write-Verbose "Added $NewParameter to $p"
                $updateFile = $true
                $content = $newContent
            }
        }
        # Save file if content has changed
        if ($updateFile) {
            $newContent | Out-File -Encoding utf8 -FilePath $p
            Write-Verbose "Updated file: $p"
        }
    }
    return
}
function Repair-PlatyPSMarkdown {
    param(
        [Parameter(Mandatory)]
        [string[]]
        $Path,

        [Parameter()]
        [string[]]
        $ParameterName = @('ProgressAction')
    )
    $ErrorActionPreference = 'Stop'
    $Parameters = @{
        Path = $Path
        ParameterName = $ParameterName
    }
    $null = Remove-CommonParameterFromMarkdown @Parameters
    $null = Add-MissingCommonParameterToMarkdown @Parameters
    return
}
Get-ChildItem -Path $OutputFolder -Filter "*.md" | ForEach-Object {
    Repair-PlatyPSMarkdown -Path $_.FullName
}

# Create new external help file
New-ExternalHelp -Path $OutputFolder -OutputPath . -Force

# Repair lint errors
function Repair-MinorImprovements {
    param(
        [Parameter(Mandatory)]
        [string]
        $Path
    )
    $Content = Get-Content -Path $Path -Raw

    # Correct lint errors
    $Content = $Content -replace '(## SYNTAX\r\n\r\n```)', '$1powershell'
    $LineBreaksBefore = @('## OUTPUTS', '## NOTES')
    foreach ($Before in $LineBreaksBefore) {
        $Content = $Content -replace "$($Before)", "`r`n$($Before)"
    }
    $LineBreaksAfter = @('### CommonParameters')
    foreach ($After in $LineBreaksAfter) {
        $Content = $Content -replace "$($After)", "$($After)`r`n"
    }
    $Content = $Content -replace '## RELATED LINKS([\r\n])+', "## RELATED LINKS"

    # Add notes
    $Content = $Content -replace '## SYNOPSIS', "!!! warning`r`n`r`n    This help was primarily created by a generative AI. It may contain partially inaccurate expressions.`r`n`r`n## SYNOPSIS"
    $Content | Out-File -Encoding utf8 -FilePath $Path
}
Get-ChildItem -Path $OutputFolder -Filter "*.md" | ForEach-Object {
    Repair-MinorImprovements -Path $_.FullName
}

# Update index.md for MkDocs
$IndexFile = "Docs/docs/index.md"
$ReadmeFile = "README.md"
$Content = Get-Content -Path $ReadmeFile
$Content = $Content -replace '> \[!WARNING\]', '!!! warning'
$Content = $Content -replace '> \[!NOTE\]', '!!! note'
$Content = $Content -replace '^>$', ''
$Content = $Content -replace '> ', '    '
$Content | Out-File -Encoding utf8 -FilePath $IndexFile
