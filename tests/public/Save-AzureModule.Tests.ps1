#requires -Module SimpleAzureModule
Describe "Save-AzureModule" {
    Context "Parameter Validation" {
        $Command = Get-Command -Module SimpleAzureModule -Name Save-AzureModule

        It "Requires a string, 'Name'" {
            $Command | Should -HaveParameter 'Name' -Type [string] -Mandatory
        }

        It "Accepts a version, 'RequiredVersion'" {
            $Command | Should -HaveParameter 'RequiredVersion' -Type [version]
        }
    }

    InModuleScope SimpleAzureModule {
        $script:Default.BasePath = Join-Path $TestDrive "Modules"
    }

    Mock Save-Module -ModuleName SimpleAzureModule -MockWith {}

    Context "Module Not Present" {
        Save-AzureModule -Name AzureRm -RequiredVersion 5.7.0

        It "Creates the meta-module directory" {
            Test-Path $TestDrive\Modules\AzureRm_5.7.0 | Should -Be $true
        }

        It "Saves the module to the new directory" {
            Assert-MockCalled Save-Module -ModuleName SimpleAzureModule -Times 1 -ParameterFilter {$Name -eq 'AzureRm' -and $RequiredVersion -eq '5.7.0' -and $Path -eq "$TestDrive\Modules\AzureRm_5.7.0"}
        }
    }

    Context "Module Present" {
        # Save-Module doesn't behave sensibly when saving metamodules, it seems
        $null = mkdir $TestDrive\Modules\AzureRm_5.9.0 -Force

        Mock New-Item -ModuleName SimpleAzureModule -MockWith {New-Item @PSBoundParameters}
        Save-AzureModule -Name AzureRm -RequiredVersion 5.9.0

        It "Doesn't recreate the meta-module directory" {
            Test-Path $TestDrive\Modules\AzureRm_5.9.0 | Should -Be $true
            Assert-MockCalled New-Item -ModuleName SimpleAzureModule -Times 0
        }

        # I am unsure if it is better to have it always re-save, or if I should trust that if a directory exists it is correctly created
        # Currently the Add-AzureModule trusts that a directory existing is proof of the module being present, so directly calling Save-AzureModule can handle refreshing
        It "Saves the module to the new directory" {
            Assert-MockCalled Save-Module -ModuleName SimpleAzureModule -Times 1 -ParameterFilter {$Name -eq 'AzureRm' -and $RequiredVersion -eq '5.9.0' -and $Path -eq "$TestDrive\Modules\$Name`_$RequiredVersion"}
        }
    }
}