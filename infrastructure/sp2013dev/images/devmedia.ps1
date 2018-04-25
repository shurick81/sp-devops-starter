$configName = "SQLMedia"
Configuration $configName
{
    param(
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xPSDesiredStateConfiguration -Name xRemoteFile -ModuleVersion 8.2.0.0

    Node $AllNodes.NodeName
    {

        xRemoteFile VSMediaArchive
        {
            Uri             = "http://$env:PACKER_HTTP_ADDR/VS2017.zip"
            DestinationPath = "C:\Install\VS2017.zip"
        }

        Archive VSMediaArchiveUnpacked
        {
            Ensure = "Present"
            Path = "C:\Install\VS2017.zip"
            Destination = "C:\Install\VSInstall"
            DependsOn   = "[xRemoteFile]VSMediaArchive"
        }

    }
}

$configurationData = @{ AllNodes = @(
    @{ NodeName = 'localhost'; PSDscAllowPlainTextPassword = $True; PsDscAllowDomainUser = $True }
) }

&$configName `
    -ConfigurationData $configurationData;
Start-DscConfiguration $configName -Verbose -Wait -Force;
