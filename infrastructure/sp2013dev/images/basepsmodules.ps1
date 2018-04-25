$configName = "BasePSModules"
Configuration $configName
{
    param(
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName PackageManagementProviderResource -ModuleVersion 1.0.3

    Node $AllNodes.NodeName
    {

        PSModule "PSModule_xPSDesiredStateConfiguration"
        {
            Ensure              = "Present"
            Name                = "xPSDesiredStateConfiguration"
            Repository          = "PSGallery"
            InstallationPolicy  = "Trusted"
            RequiredVersion     = "8.2.0.0"
        }

        PSModule "PSModule_xWindowsUpdate"
        {
            Ensure              = "Present"
            Name                = "xWindowsUpdate"
            Repository          = "PSGallery"
            InstallationPolicy  = "Trusted"
            RequiredVersion     = "2.7.0.0"
        }

    }
}

$configurationData = @{ AllNodes = @(
    @{ NodeName = $env:COMPUTERNAME; PSDscAllowPlainTextPassword = $True; PsDscAllowDomainUser = $True }
) }

&$configName `
    -ConfigurationData $configurationData;
Start-DscConfiguration $configName -Verbose -Wait -Force;