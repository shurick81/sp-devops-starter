$configName = "SPMedia"
Configuration $configName
{
    param(
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xPSDesiredStateConfiguration -Name xRemoteFile -ModuleVersion 8.2.0.0

    Node $AllNodes.NodeName
    {

        xRemoteFile SPMediaArchive
        {
            Uri             = "http://$env:PACKER_HTTP_ADDR/SPServer2013SP1.zip"
            DestinationPath = "C:\Install\SPServer2013SP1.zip"
        }

        Archive SPMediaArchiveUnpacked
        {
            Ensure = "Present"
            Path = "C:\Install\SPServer2013SP1.zip"
            Destination = "C:\Install\SPInstall"
            DependsOn   = "[xRemoteFile]SPMediaArchive"
        }

    }
}

$configurationData = @{ AllNodes = @(
    @{ NodeName = 'localhost'; PSDscAllowPlainTextPassword = $True; PsDscAllowDomainUser = $True }
) }

&$configName `
    -ConfigurationData $configurationData;
Start-DscConfiguration $configName -Verbose -Wait -Force;
