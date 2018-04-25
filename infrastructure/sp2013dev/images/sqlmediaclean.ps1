$configName = "SQLMediaClean"
Configuration $configName
{
    param(
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration

    $SPImageLocation = $systemParameters.SPImageLocation
    $SPInstallationMediaPath = $configParameters.SPInstallationMediaPath
    $SPVersion = $configParameters.SPVersion;

    Node $AllNodes.NodeName
    {

        File SQLNoLocalMediaEnsure {
            DestinationPath = "C:\Install\SQLInstall"
            Recurse = $true
            Type = "Directory"
            Ensure = "Absent"
            Force = $true
        }

        File SQLNoLocalMediaArchiveEnsure {
            DestinationPath = "C:\Install\SQLServer2014SP1.zip"
            Ensure = "Absent"
        }

    }
}

$configurationData = @{ AllNodes = @(
    @{ NodeName = $env:COMPUTERNAME; PSDscAllowPlainTextPassword = $True; PsDscAllowDomainUser = $True }
) }

&$configName `
    -ConfigurationData $configurationData;
Start-DscConfiguration $configName -Verbose -Wait -Force;