$configName = "SPMedia"
Configuration $configName
{
    param(
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node $AllNodes.NodeName
    {

        File SPLocalMediaEnsure {
            SourcePath = "\\192.168.0.159\Volume_1\Install\SP2013wSP1"
            DestinationPath = "C:\Install\SPInstall"
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
