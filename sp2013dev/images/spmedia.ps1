$configName = "SPMedia"
Configuration $configName
{
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullorEmpty()]
        [PSCredential]
        $MediaShareCredential
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node $AllNodes.NodeName
    {

        File SPLocalMediaEnsure {
            SourcePath = "\\STORAGE2\Volume_1\Install\SP2013wSP1Sw"
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
