$Directories = @("Private", "Public")

foreach ($Directory in $Directories) {
    $ScriptPath = Join-Path -Path $PSScriptRoot -ChildPath $Directory
    Get-ChildItem -Path $ScriptPath -Filter "*.ps1" -File | ForEach-Object {
        Import-Module -Name $_.FullName -Force
        if ($Directory -eq "Public") {
            Export-ModuleMember -Function $_.BaseName -Alias *
        }
    }
}
