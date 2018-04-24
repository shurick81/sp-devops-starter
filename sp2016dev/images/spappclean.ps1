$configName = "SPAppClean"
Configuration $configName
{
    param(
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName StorageDsc -ModuleVersion 4.0.0.0

    $SPImageLocation = $systemParameters.SPImageLocation
    $SPInstallationMediaPath = $configParameters.SPInstallationMediaPath
    $SPVersion = $configParameters.SPVersion;

    Node $AllNodes.NodeName
    {

        $SPImageDestinationPath = "C:\Install\SP2016RTMImage\officeserver.img"

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