[ScriptBlock]$script:VersionArgumentCompleter = {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $BoundParams)
    $BoundName =
    (Get-ChildItem $Script:Default.BasePath).Where({
        $_ -like "$($BoundParams.Name)`_*"
    }).Name | ForEach-Object {
        $_.Split('_')[1]
    }
}