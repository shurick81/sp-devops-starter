$configName = "SQLMedia"
Configuration $configName
{
    param(
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xPSDesiredStateConfiguration -Name xRemoteFile -ModuleVersion 8.2.0.0

    Node $AllNodes.NodeName
    {

        xRemoteFile SQLMediaArchive
        {
            Uri             = "http://$env:PACKER_HTTP_ADDR/SQLServer2014SP1.zip"
            DestinationPath = "C:\Install\SQLServer2014SP1.zip"
        }

        Archive SQLMediaArchiveUnpacked
        {
            Ensure = "Present"
            Path = "C:\Install\SQLServer2014SP1.zip"
            Destination = "C:\Install\SQLInstall"
            DependsOn   = "[xRemoteFile]SQLMediaArchive"
        }
        
    }
}

$configurationData = @{ AllNodes = @(
    @{ NodeName = 'localhost'; PSDscAllowPlainTextPassword = $True; PsDscAllowDomainUser = $True }
) }

&$configName `
    -ConfigurationData $configurationData;
Start-DscConfiguration $configName -Verbose -Wait -Force;
