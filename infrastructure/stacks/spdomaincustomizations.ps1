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
            $ShortDomainAdminCredential,
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
        Import-DscResource -ModuleName xActiveDirectory -ModuleVersion 2.19.0.0

        $domainName = "contoso.local";

        Node $AllNodes.NodeName
        {

            xWaitForADDomain WaitForDomain
            {
                DomainName              = $domainName
                DomainUserCredential    = $ShortDomainAdminCredential
                RetryCount              = 100
                RetryIntervalSec        = 10
            }

            xADUser SPInstallAccountUser
            {
                DomainName              = $domainName
                UserName                = $SPInstallAccountCredential.GetNetworkCredential().UserName
                Password                = $SPInstallAccountCredential
                PasswordNeverExpires    = $true
                DependsOn               = "[xWaitForADDomain]WaitForDomain"
            }
            
            xADUser SPFarmAccountUser
            {
                DomainName              = $domainName
                UserName                = $SPFarmAccountCredential.GetNetworkCredential().UserName
                Password                = $SPFarmAccountCredential
                PasswordNeverExpires    = $true
                DependsOn               = "[xWaitForADDomain]WaitForDomain"
            }

            xADGroup SPAdminGroup
            {
                GroupName           = "OG SharePoint2016 Server Admin Prod"
                MembersToInclude    = $SPInstallAccountCredential.GetNetworkCredential().UserName
                DependsOn           = "[xADUser]SPInstallAccountUser"
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

$securedPassword = ConvertTo-SecureString "Fractalsol" -AsPlainText -Force
$ShortDomainAdminCredential = New-Object System.Management.Automation.PSCredential( "administrator", $securedPassword )
$securedPassword = ConvertTo-SecureString "c0mp1Expa~~" -AsPlainText -Force
$SPInstallAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_spadm16", $securedPassword );
$SPFarmAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_spfrm16", $securedPassword );
Write-Host "$(Get-Date) Compiling DSC"
try
{
    &$configName `
        -ConfigurationData $configurationData `
        -ShortDomainAdminCredential $ShortDomainAdminCredential `
        -SPInstallAccountCredential $SPInstallAccountCredential `
        -SPFarmAccountCredential $SPFarmAccountCredential;
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
