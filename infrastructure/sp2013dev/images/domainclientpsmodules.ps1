$configName = "DomainClientPSModules"
Configuration $configName
{
    param(
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName PackageManagementProviderResource -ModuleVersion 1.0.3

    Node $AllNodes.NodeName
    {

        PSModule "PSModule_xNetworking"
        {
            Ensure              = "Present"
            Name                = "xNetworking"
            Repository          = "PSGallery"
            InstallationPolicy  = "Trusted"
            RequiredVersion     = "5.6.0.0"
        }

        PSModule "PSModule_xComputerManagement"
        {
            Ensure              = "Present"
            Name                = "xComputerManagement"
            Repository          = "PSGallery"
            InstallationPolicy  = "Trusted"
            RequiredVersion     = "3.2.0.0"
        }

    }
}

$configurationData = @{ AllNodes = @(
    @{ NodeName = $env:COMPUTERNAME; PSDscAllowPlainTextPassword = $True; PsDscAllowDomainUser = $True }
) }

&$configName `
    -ConfigurationData $configurationData;
Start-DscConfiguration $configName -Verbose -Wait -Force;