$configName = "SPFarm"
Configuration $configName
{
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullorEmpty()]
        [PSCredential]
        $SPPassphraseCredential,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullorEmpty()]
        [PSCredential]
        $SPInstallAccountCredential,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullorEmpty()]
        [PSCredential]
        $SPFarmAccountCredential
    )
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName SqlServerDsc -ModuleVersion 11.1.0.0
    Import-DSCResource -ModuleName SharePointDSC -ModuleVersion 2.2.0.0

    $domainName = "contoso.local";

    Node $AllNodes.NodeName
    {

        SqlAlias SPDBAlias
        {
            Ensure      = 'Present'
            Name        = 'SPDB'
            ServerName  = 'DBWEBCODE01\SPIntra01'
        }

        SPFarm Farm
        {
            Ensure                    = "Present"
            DatabaseServer            = "SPDB"
            FarmConfigDatabaseName    = "SP_Intra01_Config"
            AdminContentDatabaseName  = "SP_Intra01_Content_CA"
            Passphrase                = $SPPassphraseCredential
            FarmAccount               = $SPFarmAccountCredential
            RunCentralAdmin           = $true
            CentralAdministrationPort = 15555
            PsDscRunAsCredential      = $SPInstallAccountCredential
            DependsOn                 = "[SqlAlias]SPDBAlias"
        }

    }
}

$configurationData = @{ AllNodes = @(
    @{ NodeName = 'localhost'; PSDscAllowPlainTextPassword = $True; PsDscAllowDomainUser = $True }
) }

$securedPassword = ConvertTo-SecureString "sUp3rcomp1eX" -AsPlainText -Force
$SPPassphraseCredential = New-Object System.Management.Automation.PSCredential( "fakeaccount", $securedPassword )
$securedPassword = ConvertTo-SecureString "c0mp1Expa~~" -AsPlainText -Force
$SPInstallAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_spadm16", $securedPassword );
$SPFarmAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_spfrm16", $securedPassword );

&$configName `
    -ConfigurationData $configurationData `
    -SPPassphraseCredential $SPPassphraseCredential `
    -SPInstallAccountCredential $SPInstallAccountCredential `
    -SPFarmAccountCredential $SPFarmAccountCredential;

#Set-DscLocalConfigurationManager $configName -Verbose -Force;
Start-DscConfiguration $configName -Verbose -Wait -Force;