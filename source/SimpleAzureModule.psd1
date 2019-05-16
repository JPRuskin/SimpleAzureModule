@{
    ModuleVersion     = '0.1.0'

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules   = @(
        'Configuration'
    )

    # Exports. Populated by Optimize-Module during the build step.
    # For best performance, do not use wildcards and do not delete these entry!
    # Use an empty array if there is nothing to export.
    FunctionsToExport = @()
    CmdletsToExport   = @()
    AliasesToExport   = @()

    # Third party metadata
    PrivateData       = @{
        # PowerShell Gallery data
        PSData = @{
            Prerelease   = 'beta'
            ReleaseNotes = ''
            Tags         = 'Build', 'Development'
            ProjectUri   = 'https://github.com/jpruskin/SimpleAzureModule'
        }
    }

    # ID used to uniquely identify this module
    GUID              = '787c2516-8f8a-4cdf-ba57-e36418cd4328'
    Description       = 'Module to add a saved module from C:\Modules, as the AzureDevOps build machines seem to.'
    Author            = 'jpruskin'

    # The main script or binary module that is automatically loaded as part of this module
    RootModule        = 'SimpleAzureModule.psm1'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.1'
}