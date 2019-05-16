#requires -Module SimpleAzureModule
Describe "Set-AzureModuleDefault" {
    Context "Parameter Validation" {
        $Command = Get-Command -Module SimpleAzureModule -Name Set-AzureModuleDefault

        It "Requires a string, 'Name'" {
            $Command | Should -HaveParameter 'Name' -Type [string] -Mandatory
        }

        It "Requires a version, 'Version'" {
            $Command | Should -HaveParameter 'Version' -Type [version] -Mandatory
        }
    }

    Context "Setting Defaults" {
        Mock Export-Configuration -ModuleName SimpleAzureModule -MockWith { }

        Set-AzureModuleDefault -Name AzureRm -Version 5.7.0

        It "Exports Configuration containing the correct values" {
            Assert-MockCalled Export-Configuration -ModuleName SimpleAzureModule -ParameterFilter {$InputObject.Name -eq "AzureRm" -and $InputObject.Version -eq '5.7.0'}
        }
    }
}