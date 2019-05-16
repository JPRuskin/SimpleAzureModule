function Save-AzureModule {
    [CmdletBinding()]
    param(
        [ValidateSet("AzureRm", "Az")]
        [Parameter(Mandatory)]
        [string]$Name,

        [Alias('Version')]
        [version]$RequiredVersion
    )
    process {
        $ModulePath = Join-Path $Script:Default.BasePath "$Name`_$RequiredVersion"
        if (-not (Test-Path -Path $ModulePath -PathType Container)) {
            $null = New-Item -Path $ModulePath -ItemType Directory
        }

        Save-Module @PSBoundParameters -Path $ModulePath
    }
}