$configName = "DBPSModules"
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

        PSModule "PSModule_xPendingReboot"
        {
            Ensure              = "Present"
            Name                = "xPendingReboot"
            Repository          = "PSGallery"
            InstallationPolicy  = "Trusted"
            RequiredVersion     = "0.3.0.0"
        }

        PSModule "PSModule_SqlServerDsc"
        {
            Ensure              = "Present"
            Name                = "SqlServerDsc"
            Repository          = "PSGallery"
            InstallationPolicy  = "Trusted"
            RequiredVersion     = "11.1.0.0"
        }

    }
}

$configurationData = @{ AllNodes = @(
    @{ NodeName = $env:COMPUTERNAME; PSDscAllowPlainTextPassword = $True; PsDscAllowDomainUser = $True }
) }

&$configName `
    -ConfigurationData $configurationData;
Start-DscConfiguration $configName -Verbose -Wait -Force;