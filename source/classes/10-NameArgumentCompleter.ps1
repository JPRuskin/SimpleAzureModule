[ScriptBlock]$script:NameArgumentCompleter = {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $BoundParams)
    (Get-ChildItem -Path $Script:Default.BasePath).Where({
        $_ -like "*$WordToComplete*_*"
    }).Name | ForEach-Object {
        $PSItem.Split('_')[0]
    } | Sort-Object -Unique
}