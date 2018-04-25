$configName = "DevPSModules"
Configuration $configName
{
    param(
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName PackageManagementProviderResource -ModuleVersion 1.0.3

    Node $AllNodes.NodeName
    {

        PSModule "PSModule_cChoco"
        {
            Ensure              = "Present"
            Name                = "cChoco"
            Repository          = "PSGallery"
            InstallationPolicy  = "Trusted"
            RequiredVersion     = "2.3.1.0"
        }

        PSModule "PSModule_xSystemSecurity"
        {
            Ensure              = "Present"
            Name                = "xSystemSecurity"
            Repository          = "PSGallery"
            InstallationPolicy  = "Trusted"
            RequiredVersion     = "1.2.0.0"
        }

    }
}

$configurationData = @{ AllNodes = @(
    @{ NodeName = $env:COMPUTERNAME; PSDscAllowPlainTextPassword = $True; PsDscAllowDomainUser = $True }
) }

&$configName `
    -ConfigurationData $configurationData;
Start-DscConfiguration $configName -Verbose -Wait -Force;