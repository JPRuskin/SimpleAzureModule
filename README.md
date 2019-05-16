# SimpleAzureModule

A simple module to handle adding one of the various versions of the AzureRM or Az meta-modules to `PSModulePath`, in a similar way to the build agents in Azure DevOps.

By default, it stores the entire module bundle in `C:\Modules\$Name_$Version`, and then adds that path to `PSModulePath`. Ideally, the system shouldn't have other copies of the AzureRM or Az modules installed.

## Usage
You can use this module to populate the base directory with various versions of AzureRm and Az currently in use in different projects:

```PowerShell
Save-AzureModule Az 1.5.0
Save-AzureModule AzureRm 5.7.1
Save-AzureModule AzureRm 6.7.0
```

You can then quickly and simply modify `PSModulePath` to only contain one version of the Azure PowerShell modules:

```PowerShell
Add-AzureModule Az 1.5.0
```

You can add this line to your profile to add a given version to `PSModulePath` on session start.

## Building SimpleAzureModule
To build this module, run the build script:

```PowerShell
.\build\build.ps1
```

## Testing SimpleAzureModule
To test this module, build the module and run something similar to the following code:

```PowerShell
Build-Module @Module -PassThru | Import-Module -Force
Invoke-Pester .\tests
```
