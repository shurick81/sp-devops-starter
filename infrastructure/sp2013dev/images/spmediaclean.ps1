$configName = "SPMediaClean"
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

        File SPNoLocalMediaEnsure {
            DestinationPath = "C:\Install\SPInstall"
            Recurse = $true
            Type = "Directory"
            Ensure = "Absent"
            Force = $true
        }

        File SPNoLocalMediaArchiveEnsure {
            DestinationPath = "C:\Install\SPServer2013SP1.zip"
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