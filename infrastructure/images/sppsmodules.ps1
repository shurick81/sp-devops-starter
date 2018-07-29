$configName = "WebPSModules"
Write-Host "$(Get-Date) Defining DSC"
try
{
    Configuration $configName
    {
        param(
        )

        Import-DscResource -ModuleName PSDesiredStateConfiguration
        Import-DscResource -ModuleName PackageManagementProviderResource -ModuleVersion 1.0.3

        Node $AllNodes.NodeName
        {

            PSModule "PSModule_xPendingReboot"
            {
                Ensure              = "Present"
                Name                = "xPendingReboot"
                Repository          = "PSGallery"
                InstallationPolicy  = "Trusted"
                RequiredVersion     = "0.3.0.0"
            }

            PSModule "PSModule_StorageDsc"
            {
                Ensure              = "Present"
                Name                = "StorageDsc"
                Repository          = "PSGallery"
                InstallationPolicy  = "Trusted"
                RequiredVersion     = "4.0.0.0"
            }
    
            PSModule "PSModule_xNetworking"
            {
                Ensure              = "Present"
                Name                = "xNetworking"
                Repository          = "PSGallery"
                InstallationPolicy  = "Trusted"
                RequiredVersion     = "5.6.0.0"
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
                RequiredVersion     = "2.4.0.0"
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

            PSModule "PSModule_xCredSSP"
            {
                Ensure              = "Present"
                Name                = "xCredSSP"
                Repository          = "PSGallery"
                InstallationPolicy  = "Trusted"
                RequiredVersion     = "1.3.0.0"
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
