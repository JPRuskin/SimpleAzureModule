function Add-AzureModule {
    [CmdletBinding(DefaultParameterSetName = "Calculated")]
    param(
        [Parameter(ParameterSetName = "Calculated", Position = 0)]
        [string]$Name = $Script:Default.Name,

        [Parameter(ParameterSetName = "Calculated", Position = 1)]
        [version]$Version = $Script:Default.Version,

        [Parameter(ParameterSetName = "Provided", Position = 0)]
        [ValidateScript( { Test-Path $_ -PathType Container })]
        [string]$Path = "$($Script:Default.BasePath)\$Name`_$Version"
    )
    end {
        if (-not (Test-Path $Path)) {
            Save-AzureModule -Name $Name -RequiredVersion $Version
        }

        $ModulePath = $env:PSModulePath.Split(';')
        $env:PSModulePath = @() + $Path + $ModulePath.Where( { $_ -notlike "$($Script:Default.BasePath)\*" }) -join ';'
    }
}

Register-ArgumentCompleter -CommandName Add-AzureModule -ParameterName Name -ScriptBlock $script:NameArgumentCompleter
Register-ArgumentCompleter -CommandName Add-AzureModule -ParameterName Version -ScriptBlock $script:VersionArgumentCompleter