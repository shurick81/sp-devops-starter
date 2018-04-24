$configName = "DevMediaClean"
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

        File VSNoLocalMediaEnsure {
            DestinationPath = "C:\Install\VSInstall"
            Recurse = $true
            Type = "Directory"
            Ensure = "Absent"
            Force = $true
        }

        File VSNoLocalMediaArchiveEnsure {
            DestinationPath = "C:\Install\VS2017.zip"
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