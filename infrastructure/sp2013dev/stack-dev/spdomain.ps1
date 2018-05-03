$configName = "SPDomain"
Configuration $configName
{
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullorEmpty()]
        [PSCredential]
        $ShortDomainAdminCredential,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullorEmpty()]
        [PSCredential]
        $DomainSafeModeAdministratorPasswordCredential,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullorEmpty()]
        [PSCredential]
        $DomainAdminCredential,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullorEmpty()]
        [PSCredential]
        $SPInstallAccountCredential,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullorEmpty()]
        [PSCredential]
        $SQLServiceAccountCredential,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullorEmpty()]
        [PSCredential]
        $SQLAgentAccountCredential,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullorEmpty()]
        [PSCredential]
        $SPFarmAccountCredential,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullorEmpty()]
        [PSCredential]
        $SPWebAppPoolAccountCredential,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullorEmpty()]
        [PSCredential]
        $SPServicesAccountCredential,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullorEmpty()]
        [PSCredential]
        $SPSearchServiceAccountCredential,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullorEmpty()]
        [PSCredential]
        $SPCrawlerAccountCredential,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullorEmpty()]
        [PSCredential]
        $SPOCAccountCredential,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullorEmpty()]
        [PSCredential]
        $SPTestAccountCredential,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullorEmpty()]
        [PSCredential]
        $SPSecondTestAccountCredential
    )
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xActiveDirectory -ModuleVersion 2.16.0.0

    $domainName = "contoso.local";

    Node $AllNodes.NodeName
    {

        xADDomain ADDomain
        {
            DomainName                      = $domainName
            SafemodeAdministratorPassword   = $domainSafeModeAdministratorPasswordCredential
            DomainAdministratorCredential   = $shortDomainAdminCredential
        }

        xWaitForADDomain WaitForDomain
        {
            DomainName              = $domainName
            DomainUserCredential    = $ShortDomainAdminCredential
            RetryCount              = 100
            RetryIntervalSec        = 10
            DependsOn               = "[xADDomain]ADDomain"
        }

        xADUser DomainAdminAccountUser
        {
            DomainName              = $DomainName
            UserName                = $DomainAdminCredential.GetNetworkCredential().UserName
            Password                = $DomainAdminCredential
            PasswordNeverExpires    = $true
            DependsOn               = "[xWaitForADDomain]WaitForDomain"
        }
        
        xADUser SPInstallAccountUser
        {
            DomainName              = $DomainName
            UserName                = $SPInstallAccountCredential.GetNetworkCredential().UserName
            Password                = $SPInstallAccountCredential
            PasswordNeverExpires    = $true
            DependsOn               = "[xWaitForADDomain]WaitForDomain"
        }
        
        xADUser SQLServiceAccount
        {
            DomainName              = $DomainName
            UserName                = $SQLServiceAccountCredential.GetNetworkCredential().UserName
            Password                = $SQLServiceAccountCredential
            PasswordNeverExpires    = $true
            DependsOn               = "[xWaitForADDomain]WaitForDomain"
        }

        xADUser SQLAgentAccount
        {
            DomainName              = $DomainName
            UserName                = $SQLAgentAccountCredential.GetNetworkCredential().UserName
            Password                = $SQLAgentAccountCredential
            PasswordNeverExpires    = $true
            DependsOn               = "[xWaitForADDomain]WaitForDomain"
        }

        xADUser SPFarmAccountUser
        {
            DomainName              = $DomainName
            UserName                = $SPFarmAccountCredential.GetNetworkCredential().UserName
            Password                = $SPFarmAccountCredential
            PasswordNeverExpires    = $true
            DependsOn               = "[xWaitForADDomain]WaitForDomain"
        }

        xADUser SPWebAppPoolAccountUser
        {
            DomainName              = $DomainName
            UserName                = $SPWebAppPoolAccountCredential.GetNetworkCredential().UserName
            Password                = $SPWebAppPoolAccountCredential
            PasswordNeverExpires    = $true
            DependsOn               = "[xWaitForADDomain]WaitForDomain"
        }

        xADUser SPServicesAccountUser
        {
            DomainName              = $DomainName
            UserName                = $SPServicesAccountCredential.GetNetworkCredential().UserName
            Password                = $SPServicesAccountCredential
            PasswordNeverExpires    = $true
            DependsOn               = "[xWaitForADDomain]WaitForDomain"
        }

        xADUser SPSearchServiceAccountUser
        {
            DomainName              = $DomainName
            UserName                = $SPSearchServiceAccountCredential.GetNetworkCredential().UserName
            Password                = $SPSearchServiceAccountCredential
            PasswordNeverExpires    = $true
            DependsOn               = "[xWaitForADDomain]WaitForDomain"
        }

        xADUser SPCrawlerAccountUser
        {
            DomainName              = $DomainName
            UserName                = $SPCrawlerAccountCredential.GetNetworkCredential().UserName
            Password                = $SPCrawlerAccountCredential
            PasswordNeverExpires    = $true
            DependsOn               = "[xWaitForADDomain]WaitForDomain"
        }

        xADUser SPOCSuperUserADUser
        {
            DomainName              = $DomainName
            UserName                = "_spocuser16"
            Password                = $SPOCAccountCredential
            PasswordNeverExpires    = $true
            DependsOn               = "[xWaitForADDomain]WaitForDomain"
        }

        xADUser SPOCSuperReaderUser
        {
            DomainName              = $DomainName
            UserName                = "_spocrdr16"
            Password                = $SPOCAccountCredential
            PasswordNeverExpires    = $true
            DependsOn               = "[xWaitForADDomain]WaitForDomain"
        }

        xADUser SPTestUser
        {
            DomainName              = $DomainName
            UserName                = $SPTestAccountCredential.GetNetworkCredential().UserName
            Password                = $SPTestAccountCredential
            PasswordNeverExpires    = $true
            DependsOn               = "[xWaitForADDomain]WaitForDomain"
        }

        xADUser SPSecondTestUser
        {
            DomainName              = $DomainName
            UserName                = $SPSecondTestAccountCredential.GetNetworkCredential().UserName
            Password                = $SPSecondTestAccountCredential
            PasswordNeverExpires    = $true
            DependsOn               = "[xWaitForADDomain]WaitForDomain"
        }
        
        xADGroup DomainAdminGroup
        {
            GroupName           = "Domain Admins"
            MembersToInclude    = $DomainAdminCredential.GetNetworkCredential().UserName
            DependsOn           = "[xADUser]DomainAdminAccountUser"
        }

        xADGroup SPAdminGroup
        {
            GroupName           = "OG SharePoint2016 Server Admin Prod"
            MembersToInclude    = $SPInstallAccountCredential.GetNetworkCredential().UserName
            DependsOn           = "[xADUser]SPInstallAccountUser"
        }

    }
}

$configurationData = @{ AllNodes = @(
    @{ NodeName = 'localhost'; PSDscAllowPlainTextPassword = $True; PsDscAllowDomainUser = $True }
) }

$securedPassword = ConvertTo-SecureString "Fractalsol" -AsPlainText -Force
$ShortDomainAdminCredential = New-Object System.Management.Automation.PSCredential( "administrator", $securedPassword )
$securedPassword = ConvertTo-SecureString "sUp3rcomp1eX" -AsPlainText -Force
$DomainSafeModeAdministratorPasswordCredential = New-Object System.Management.Automation.PSCredential( "fakeaccount", $securedPassword )
$securedPassword = ConvertTo-SecureString "c0mp1Expa~~" -AsPlainText -Force
$DomainAdminCredential = New-Object System.Management.Automation.PSCredential( "contoso\dauser1", $securedPassword );
$SPInstallAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_spadm16", $securedPassword );
$SQLServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_sqlsvc16", $securedPassword );
$SQLAgentAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_sqlagent16", $securedPassword );
$SPFarmAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_spfrm16", $securedPassword );
$SPWebAppPoolAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_spwebapppool16", $securedPassword );
$SPServicesAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_spsrv16", $securedPassword );
$SPSearchServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_spsrchsrv16", $securedPassword );
$SPCrawlerAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_spcrawler16", $securedPassword );
$SPOCAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_spocuser16", $securedPassword );
$SPTestAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_sptestuser161", $securedPassword );
$SPSecondTestAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_sptestuser162", $securedPassword );


&$configName `
    -ConfigurationData $configurationData `
    -ShortDomainAdminCredential $ShortDomainAdminCredential `
    -DomainSafeModeAdministratorPasswordCredential $DomainSafeModeAdministratorPasswordCredential `
    -DomainAdminCredential $DomainAdminCredential `
    -SPInstallAccountCredential $SPInstallAccountCredential `
    -SQLServiceAccountCredential $SQLServiceAccountCredential `
    -SQLAgentAccountCredential $SQLAgentAccountCredential `
    -SPFarmAccountCredential $SPFarmAccountCredential `
    -SPWebAppPoolAccountCredential $SPWebAppPoolAccountCredential `
    -SPServicesAccountCredential $SPServicesAccountCredential `
    -SPSearchServiceAccountCredential $SPSearchServiceAccountCredential `
    -SPCrawlerAccountCredential $SPCrawlerAccountCredential `
    -SPOCAccountCredential $SPOCAccountCredential `
    -SPTestAccountCredential $SPTestAccountCredential `
    -SPSecondTestAccountCredential $SPSecondTestAccountCredential;

#Set-DscLocalConfigurationManager $configName -Verbose -Force;
Start-DscConfiguration $configName -Verbose -Wait -Force;