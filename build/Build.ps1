#requires -Modules ModuleBuilder
param(
    # For VSTS we use ENV:Build_SourcesDirectory, otherwise, we use the parent of the build folder:
    $SourcesDirectory = $(
        if ($Env:Build_SourcesDirectory) {
            $Env:Build_SourcesDirectory
        } else {
            Split-Path $PSScriptRoot
        }
    ),

    # For VSTS we use Env:Build_BinariesDirectory otherwise we use a versioned path adjacent to the build folder:
    $Destination = $(
        if ($Env:Build_BinariesDirectory) {
            $Env:Build_BinariesDirectory
        } else {
            Split-Path $PSScriptRoot
        }
    ),

    # The GitVersion.NuGetVersion (because PowerShellGet is using v1 SemVer)
    $NugetVersion = $(
        if (Get-Command gitversion -ErrorAction Ignore) {
            GitVersion.exe $SourcesDirectory -showvariable NuGetVersion
        }
    )
)

# Ensure the Destination path exists
if (-not (Test-Path $Destination -PathType Container)) {
    $null = New-Item -Path $Destination -ItemType Directory -Force
}

## This is our one-size-fits-all build script. It just builds all the build.psd1 files
Get-ChildItem -Path $SourcesDirectory -Recurse -Filter build.psd1 | ForEach-Object {
    $ModuleName = [IO.Path]::GetFileNameWithoutExtension((Import-LocalizedData -BaseDirectory $_.Directory.FullName -FileName $_.Name).Path)

    $Module = @{
        Path        = $_.FullName
        Destination = $Destination
    }

    if ((Split-Path $Module.Destination -Leaf) -ne $ModuleName) {
        $Module.Destination = Join-Path $Module.Destination $ModuleName
    }

    Build-Module @Module -VersionedOutputDirectory -SemVer $NugetVersion
}