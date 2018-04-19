$configName = "DomainBin"
Configuration $configName
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node $AllNodes.NodeName
    {

        WindowsFeatureSet DomainFeatures
        {
            Name                    = @( "DNS", "RSAT-DNS-Server", "AD-Domain-Services", "RSAT-ADDS" )
            Ensure                  = 'Present'
            IncludeAllSubFeature    = $true
        } 

    }
}

$configurationData = @{ AllNodes = @(
    @{ NodeName = 'localhost'; PSDscAllowPlainTextPassword = $True; PsDscAllowDomainUser = $True }
) }

&$configName -ConfigurationData $configurationData;
Start-DscConfiguration $configName -Verbose -Wait -Force;
Write-Host "Sleeping 180"
Sleep 180;