$configName = "WebPSModules"
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

        PSModule "PSModule_xNetworking"
        {
            Ensure              = "Present"
            Name                = "xNetworking"
            Repository          = "PSGallery"
            InstallationPolicy  = "Trusted"
            RequiredVersion     = "5.3.0.0"
        }

        PSModule "PSModule_SqlServerDsc"
        {
            Ensure              = "Present"
            Name                = "SqlServerDsc"
            Repository          = "PSGallery"
            InstallationPolicy  = "Trusted"
            RequiredVersion     = "11.1.0.0"
        }

        PSModule "PSModule_xWebAdministration"
        {
            Ensure              = "Present"
            Name                = "xWebAdministration"
            Repository          = "PSGallery"
            InstallationPolicy  = "Trusted"
            RequiredVersion     = "1.19.0.0"
        }

        PSModule "PSModule_SharePointDSC"
        {
            Ensure              = "Present"
            Name                = "SharePointDSC"
            Repository          = "PSGallery"
            InstallationPolicy  = "Trusted"
            RequiredVersion     = "2.2.0.0"
        }

        PSModule "PSModule_xSystemSecurity"
        {
            Ensure              = "Present"
            Name                = "xSystemSecurity"
            Repository          = "PSGallery"
            InstallationPolicy  = "Trusted"
            RequiredVersion     = "1.2.0.0"
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