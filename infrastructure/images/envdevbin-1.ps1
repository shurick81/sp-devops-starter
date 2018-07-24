$configName = "DevBin"
Write-Host "$(Get-Date) Defining DSC"
try
{
    Configuration $configName
    {
        param(
        )

        Import-DscResource -ModuleName PSDesiredStateConfiguration
        Import-DSCResource -Module xSystemSecurity -Name xIEEsc -ModuleVersion 1.2.0.0
        Import-DSCResource -ModuleName cChoco -ModuleVersion 2.3.1.0

        Node $AllNodes.NodeName
        {

            xIEEsc DisableIEEsc
            {
                IsEnabled   = $false;
                UserRole    = "Administrators"
            }

            cChocoInstaller ChocoInstalled
            {
                InstallDir              = "c:\choco"
            }

            cChocoPackageInstaller VSCodeInstalled
            {
                Name                    = "visualstudiocode"
                DependsOn               = "[cChocoInstaller]ChocoInstalled"
            }

            cChocoPackageInstaller GitInstalled
            {
                Name                    = "git"
                DependsOn               = "[cChocoInstaller]ChocoInstalled"
            }

            cChocoPackageInstaller PackerInstalled
            {
                Name                    = "packer"
                DependsOn               = "[cChocoInstaller]ChocoInstalled"
            }

            cChocoPackageInstaller VagrantInstalled
            {
                Name                    = "vagrant"
                DependsOn               = "[cChocoInstaller]ChocoInstalled"
            }

        }
    }
}
catch
{
    Write-Host "$(Get-Date) Exception in defining DCS:"
    $_.Exception.Message
    Exit 1;
}
$configurationData = @{ AllNodes = @(
    @{ NodeName = $env:COMPUTERNAME; PSDscAllowPlainTextPassword = $True; PsDscAllowDomainUser = $True }
) }
Write-Host "$(Get-Date) Compiling DSC"
try
{
    &$configName `
        -ConfigurationData $configurationData;
}
catch
{
    Write-Host "$(Get-Date) Exception in compiling DCS:";
    $_.Exception.Message
    Exit 1;
}
Write-Host "$(Get-Date) Starting DSC"
try
{
    Start-DscConfiguration $configName -Verbose -Wait -Force;
}
catch
{
    Write-Host "$(Get-Date) Exception in starting DCS:"
    $_.Exception.Message
    Exit 1;
}
if ( $env:SPDEVOPSSTARTER_NODSCTEST -ne "TRUE" )
{
    Write-Host "$(Get-Date) Testing DSC"
    try {
        $result = Test-DscConfiguration $configName -Verbose;
        $inDesiredState = $result.InDesiredState;
        $failed = $false;
        $inDesiredState | % {
            if ( !$_ ) {
                Write-Host "$(Get-Date) Test failed"
                Exit 1;
            }
        }
    }
    catch {
        Write-Host "$(Get-Date) Exception in testing DCS:"
        $_.Exception.Message
        Exit 1;
    }
} else {
    Write-Host "$(Get-Date) Skipping tests"
}
Exit 0;
