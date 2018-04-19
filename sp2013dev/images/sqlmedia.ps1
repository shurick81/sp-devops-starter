$configName = "SQLMedia"
Configuration $configName
{
    param(
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node $AllNodes.NodeName
    {

        File SQLLocalMediaEnsure {
            SourcePath = "\\192.168.0.159\Volume_1\Install\SQLServer2014SP1"
            DestinationPath = "C:\Install\SQLInstall"
            Recurse = $true
            Type = "Directory"
        }

    }
}

$configurationData = @{ AllNodes = @(
    @{ NodeName = 'localhost'; PSDscAllowPlainTextPassword = $True; PsDscAllowDomainUser = $True }
) }

&$configName `
    -ConfigurationData $configurationData;
Start-DscConfiguration $configName -Verbose -Wait -Force;
