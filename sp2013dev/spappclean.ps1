$configName = "SPAppClean"
Configuration $configName
{
    param(
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xPSDesiredStateConfiguration -Name xRemoteFile -ModuleVersion 8.0.0.0
    Import-DscResource -ModuleName StorageDsc -ModuleVersion 4.0.0.0

    $SPImageLocation = $systemParameters.SPImageLocation
    $SPInstallationMediaPath = $configParameters.SPInstallationMediaPath
    $SPVersion = $configParameters.SPVersion;

    Node $AllNodes.NodeName
    {

        $SPImageDestinationPath = "C:/Install/SP2013SP1Image/en_sharepoint_server_2013_with_sp1_x64_dvd_3823428.iso"

        MountImage SPServerImageNotMounted
        {
            ImagePath   = $SPImageDestinationPath
            Ensure      = 'Absent'
        }

        File SPServerImageAbsent {
            Ensure          = "Absent"
            DestinationPath = $SPImageDestinationPath
            Force           = $true
            DependsOn       = "[MountImage]SPServerImageNotMounted"
        }

    }
}

$configurationData = @{ AllNodes = @(
    @{ NodeName = $env:COMPUTERNAME; PSDscAllowPlainTextPassword = $True; PsDscAllowDomainUser = $True }
) }

&$configName `
    -ConfigurationData $configurationData;
Start-DscConfiguration $configName -Verbose -Wait -Force;