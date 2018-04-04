$configName = "SPBin"
Configuration $configName
{
    param(
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DSCResource -ModuleName SharePointDSC -ModuleVersion 2.2.0.0

    Node $AllNodes.NodeName
    {

        SPInstallPrereqs SPPrereqsInstalled
        {
            InstallerPath   = "F:\Prerequisiteinstaller.exe"
            OnlineMode      = $true
        }

        SPInstall SharePointBinariesInstalled 
        { 
            Ensure      = "Present"
            BinaryDir   = "F:"
            ProductKey  = "NQTMW-K63MQ-39G6H-B2CH9-FRDWJ"
            DependsOn   = "[SPInstallPrereqs]SPPrereqsInstalled"
        }

    }
}

$configurationData = @{ AllNodes = @(
    @{ NodeName = $env:COMPUTERNAME; PSDscAllowPlainTextPassword = $True; PsDscAllowDomainUser = $True }
) }

&$configName `
    -ConfigurationData $configurationData;
Start-DscConfiguration $configName -Verbose -Wait -Force;