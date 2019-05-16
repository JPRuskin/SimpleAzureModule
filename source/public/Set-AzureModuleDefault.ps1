function Set-AzureModuleDefault {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [version]$Version
    )
    end {
        @{
            Name    = $Name
            Version = $Version
        } | Export-Configuration
    }
}

Register-ArgumentCompleter -CommandName Set-AzureModuleDefault -ParameterName Name -ScriptBlock $script:NameArgumentCompleter
Register-ArgumentCompleter -CommandName Set-AzureModuleDefault -ParameterName Version -ScriptBlock $script:VersionArgumentCompleter