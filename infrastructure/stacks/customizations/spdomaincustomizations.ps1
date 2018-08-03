$configName = "SPDomainCustomizations"
Write-Host "$(Get-Date) Defining DSC"
try
{
    Configuration $configName
    {
        param(
            [Parameter(Mandatory=$true)]
            [ValidateNotNullorEmpty()]
            [PSCredential]
            $DomainAdminCredential,
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
        Import-DscResource -ModuleName xActiveDirectory -ModuleVersion 2.19.0.0

        $domainName = "contoso.local";

        Node $AllNodes.NodeName
        {

            xADUser DomainAdminAccountUser
            {
                DomainName              = $domainName
                UserName                = $DomainAdminCredential.GetNetworkCredential().UserName
                Password                = $DomainAdminCredential
                PasswordNeverExpires    = $true
            }
            
            xADUser SQLServiceAccount
            {
                DomainName              = $domainName
                UserName                = $SQLServiceAccountCredential.GetNetworkCredential().UserName
                Password                = $SQLServiceAccountCredential
                PasswordNeverExpires    = $true
            }

            xADUser SQLAgentAccount
            {
                DomainName              = $domainName
                UserName                = $SQLAgentAccountCredential.GetNetworkCredential().UserName
                Password                = $SQLAgentAccountCredential
                PasswordNeverExpires    = $true
            }

            xADUser SPWebAppPoolAccountUser
            {
                DomainName              = $domainName
                UserName                = $SPWebAppPoolAccountCredential.GetNetworkCredential().UserName
                Password                = $SPWebAppPoolAccountCredential
                PasswordNeverExpires    = $true
            }

            xADUser SPServicesAccountUser
            {
                DomainName              = $domainName
                UserName                = $SPServicesAccountCredential.GetNetworkCredential().UserName
                Password                = $SPServicesAccountCredential
                PasswordNeverExpires    = $true
            }

            xADUser SPSearchServiceAccountUser
            {
                DomainName              = $domainName
                UserName                = $SPSearchServiceAccountCredential.GetNetworkCredential().UserName
                Password                = $SPSearchServiceAccountCredential
                PasswordNeverExpires    = $true
            }

            xADUser SPCrawlerAccountUser
            {
                DomainName              = $domainName
                UserName                = $SPCrawlerAccountCredential.GetNetworkCredential().UserName
                Password                = $SPCrawlerAccountCredential
                PasswordNeverExpires    = $true
            }

            xADUser SPOCSuperUserADUser
            {
                DomainName              = $domainName
                UserName                = "_spocuser16"
                Password                = $SPOCAccountCredential
                PasswordNeverExpires    = $true
            }

            xADUser SPOCSuperReaderUser
            {
                DomainName              = $domainName
                UserName                = "_spocrdr16"
                Password                = $SPOCAccountCredential
                PasswordNeverExpires    = $true
            }

            xADUser SPTestUser
            {
                DomainName              = $domainName
                UserName                = $SPTestAccountCredential.GetNetworkCredential().UserName
                Password                = $SPTestAccountCredential
                PasswordNeverExpires    = $true
            }

            xADUser SPSecondTestUser
            {
                DomainName              = $domainName
                UserName                = $SPSecondTestAccountCredential.GetNetworkCredential().UserName
                Password                = $SPSecondTestAccountCredential
                PasswordNeverExpires    = $true
            }
            
            xADGroup DomainAdminGroup
            {
                GroupName           = "Domain Admins"
                MembersToInclude    = $DomainAdminCredential.GetNetworkCredential().UserName
                DependsOn           = "[xADUser]DomainAdminAccountUser"
            }

            xADGroup EnterpriseAdminGroup
            {
                GroupName           = "Enterprise Admins"
                MembersToInclude    = $DomainAdminCredential.GetNetworkCredential().UserName
                DependsOn           = "[xADUser]DomainAdminAccountUser"
            }

        }
    }
}
catch
{
    Write-Host "$(Get-Date) Exception in defining DCS:"
    $_.Exception.Message
    Exit 1;
}
$configurationData = @{ AllNodes = @(
    @{ NodeName = $env:COMPUTERNAME; PSDscAllowPlainTextPassword = $True; PsDscAllowDomainUser = $True }
) }

$securedPassword = ConvertTo-SecureString "c0mp1Expa~~" -AsPlainText -Force
$DomainAdminCredential = New-Object System.Management.Automation.PSCredential( "contoso\dauser1", $securedPassword );
$SQLServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_sqlsvc16", $securedPassword );
$SQLAgentAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_sqlagent16", $securedPassword );
$SPWebAppPoolAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_spwebapppool16", $securedPassword );
$SPServicesAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_spsrv16", $securedPassword );
$SPSearchServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_spsrchsrv16", $securedPassword );
$SPCrawlerAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_spcrawler16", $securedPassword );
$SPOCAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_spocuser16", $securedPassword );
$SPTestAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_sptestuser161", $securedPassword );
$SPSecondTestAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_sptestuser162", $securedPassword );
Write-Host "$(Get-Date) Compiling DSC"
try
{
    &$configName `
        -ConfigurationData $configurationData `
        -DomainAdminCredential $DomainAdminCredential `
        -SQLServiceAccountCredential $SQLServiceAccountCredential `
        -SQLAgentAccountCredential $SQLAgentAccountCredential `
        -SPWebAppPoolAccountCredential $SPWebAppPoolAccountCredential `
        -SPServicesAccountCredential $SPServicesAccountCredential `
        -SPSearchServiceAccountCredential $SPSearchServiceAccountCredential `
        -SPCrawlerAccountCredential $SPCrawlerAccountCredential `
        -SPOCAccountCredential $SPOCAccountCredential `
        -SPTestAccountCredential $SPTestAccountCredential `
        -SPSecondTestAccountCredential $SPSecondTestAccountCredential;
}
catch
{
    Write-Host "$(Get-Date) Exception in compiling DCS:";
    $_.Exception.Message
    Exit 1;
}
Write-Host "$(Get-Date) Starting DSC"
try
{
    Start-DscConfiguration $configName -Verbose -Wait -Force;
}
catch
{
    Write-Host "$(Get-Date) Exception in starting DCS:"
    $_.Exception.Message
    Exit 1;
}
Write-Host "$(Get-Date) Testing DSC"
try {
    $result = Test-DscConfiguration $configName -Verbose;
    $inDesiredState = $result.InDesiredState;
    $failed = $false;
    $inDesiredState | % {
        if ( !$_ ) {
            Write-Host "$(Get-Date) Test failed"
            Exit 1;
        }
    }
}
catch {
    Write-Host "$(Get-Date) Exception in testing DCS:"
    $_.Exception.Message
    Exit 1;
}
Exit 0;
