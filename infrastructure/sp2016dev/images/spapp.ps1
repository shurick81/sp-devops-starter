$configName = "SPApp"
Configuration $configName
{
    param(
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xPSDesiredStateConfiguration -Name xRemoteFile -ModuleVersion 8.2.0.0

    $SPImageLocation = $systemParameters.SPImageLocation
    $SPInstallationMediaPath = $configParameters.SPInstallationMediaPath
    $SPVersion = $configParameters.SPVersion;

    Node $AllNodes.NodeName
    {

        $spImageUrl = "http://care.dlservice.microsoft.com/dl/download/0/0/4/004EE264-7043-45BF-99E3-3F74ECAE13E5/officeserver.img";
        $SPImageUrl -match '[^/\\&\?]+\.\w{3,4}(?=([\?&].*$|$))' | Out-Null
        $SPImageFileName = $matches[0]
        $SPImageDestinationPath = "C:\Install\SP2016RTMImage\$SPImageFileName"

        xRemoteFile SPServerImageFilePresent
        {
            Uri             = $SPImageUrl
            DestinationPath = $SPImageDestinationPath
        }

    }
}

$configurationData = @{ AllNodes = @(
    @{ NodeName = $env:COMPUTERNAME; PSDscAllowPlainTextPassword = $True; PsDscAllowDomainUser = $True }
) }

&$configName `
    -ConfigurationData $configurationData;
Start-DscConfiguration $configName -Verbose -Wait -Force;