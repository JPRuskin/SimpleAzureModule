#requires -Module SimpleAzureModule
$PreTestPSModulePath = $env:PSModulePath
Describe "Add-AzureModule" {
    InModuleScope SimpleAzureModule {
        $script:Default.BasePath = Join-Path $TestDrive "Modules"
    }

    function GetModulePath {$env:PSModulePath -split ';'}

    Mock Save-AzureModule -ModuleName SimpleAzureModule -MockWith {
        $null = New-Item -Path (Join-Path $script:Default.BasePath "$Name`_$Version") -ItemType Directory -Force
    }

    $global:TestArguments = @{
        Name    = "Az"
        Version = "1.0.0"
    }
    $ExpectedPath = Join-Path $TestDrive "\Modules\$($TestArguments.Name)_$($TestArguments.Version)"

    Context "Parameter Validation" {
        $Command = Get-Command -Module SimpleAzureModule -Name Add-AzureModule

        It "Accepts a string, 'Name'" {
            $Command | Should -HaveParameter 'Name' -Type [string]
        }

        It "Accepts a version, 'Version'" {
            $Command | Should -HaveParameter 'Version' -Type [version]
        }

        It "Accepts a string, 'Path'" {
            $Command | Should -HaveParameter 'Path' -Type [string]
        }
    }

    Context "Module Not Present" {
        Add-AzureModule @TestArguments

        It "Saves the specified module to the BasePath" {
            Assert-MockCalled Save-AzureModule -ModuleName SimpleAzureModule -ParameterFilter {$Name -eq $TestArguments.Name -and $RequiredVersion -eq $TestArguments.Version} -Times 1
        }

        It "Adds the ModulePath to PSModulePath" {
            GetModulePath | Should -Contain $ExpectedPath
        }

        It "Has no other path from BasePath on PSModulePath" {
            (GetModulePath) -like "$TestDrive\Modules\*" | Should -Be $ExpectedPath
        }
    }

    Context "Module Present" {
        Mock Test-Path -ModuleName SimpleAzureModule -MockWith {$true} -ParameterFilter {$Path -eq $ExpectedPath}

        Add-AzureModule @TestArguments

        It "Does not save the module to the BasePath" {
            Assert-MockCalled Save-AzureModule -ModuleName SimpleAzureModule -Times 0
        }

        It "Adds the ModulePath to the PSModulePath" {
            GetModulePath | Should -Contain $ExpectedPath
        }

        It "Has no other path from BasePath on PSModulePath" {
            (GetModulePath) -like "$TestDrive\Modules\*" | Should -Be $ExpectedPath
        }
    }

    Context "Multiple Adds in Single Session" {
        Mock Test-Path -ModuleName SimpleAzureModule -MockWith {$true}

        It "Adds the first ModulePath" {
            Add-AzureModule -Name AzureRm -Version 2.0.0
            GetModulePath | Should -Contain "$TestDrive\Modules\AzureRm_2.0.0"
        }

        It "Replaces the path with new ModulePath" {
            Add-AzureModule -Name Az -Version 1.5.0
            GetModulePath | Should -Not -Contain "$TestDrive\Modules\AzureRm_2.0.0"
            GetModulePath | Should -Contain "$TestDrive\Modules\Az_1.5.0"
        }
    }
}

$env:PSModulePath = $PreTestPSModulePath