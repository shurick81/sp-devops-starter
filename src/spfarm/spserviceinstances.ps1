$configName = "SPServiceInstances"
Write-Host "$(Get-Date) Defining DSC"
try
{
    Configuration $configName
    {
        param(
            [Parameter(Mandatory=$true)]
            [ValidateNotNullorEmpty()]
            [PSCredential]
            $SPInstallAccountCredential,
            [Parameter(Mandatory=$true)]
            [ValidateNotNullorEmpty()]
            [PSCredential]
            $SPServicesAccountCredential
        )
        Import-DscResource -ModuleName PSDesiredStateConfiguration
        Import-DSCResource -ModuleName SharePointDSC -ModuleVersion 3.0.0.0

        Node $AllNodes.NodeName
        {

            SPManagedAccount SharePointServicesPoolAccount
            {
                AccountName             = $SPServicesAccountCredential.UserName
                Account                 = $SPServicesAccountCredential
                PsDscRunAsCredential    = $SPInstallAccountCredential
            }

            SPServiceInstance AppManagementService
            {
                Name                    = "App Management Service"
                PsDscRunAsCredential    = $SPInstallAccountCredential
            }

            SPServiceInstance BusinessDataConnectivityService
            {
                Name                    = "Business Data Connectivity Service"
                PsDscRunAsCredential    = $SPInstallAccountCredential
            }

            SPServiceInstance Claims2WindowsTokenService
            {
                Name                    = "Claims to Windows Token Service"
                PsDscRunAsCredential    = $SPInstallAccountCredential
            }

            SPServiceInstance MachineTranslationService
            {
                Name                    = "Machine Translation Service"
                PsDscRunAsCredential    = $SPInstallAccountCredential
            }

            SPServiceInstance ManagedMetadataServiceInstance
            {
                Name                    = "Managed Metadata Web Service"
                PsDscRunAsCredential    = $SPInstallAccountCredential
            }

            SPServiceInstance SubscriptionSettingsService
            {
                Name                    = "Microsoft SharePoint Foundation Subscription Settings Service"
                PsDscRunAsCredential    = $SPInstallAccountCredential
            }

            SPServiceInstance RequestManagement
            {
                Name                    = "Request Management"
                PsDscRunAsCredential    = $SPInstallAccountCredential
            }

            SPServiceInstance SecureStoreService
            {
                Name                    = "Secure Store Service"
                PsDscRunAsCredential    = $SPInstallAccountCredential
            }

            SPServiceInstance UserProfileService
            {
                Name                    = "User Profile Service"
                PsDscRunAsCredential    = $SPInstallAccountCredential
            }

            SPServiceInstance AccessDatabaseService2010
            {
                Name                    = "Access Database Service 2010"
                PsDscRunAsCredential    = $SPInstallAccountCredential
            }

            SPServiceInstance AccessServices
            {
                Name                    = "Access Services"
                PsDscRunAsCredential    = $SPInstallAccountCredential
            }

            SPServiceInstance ExcelCalculationServices
            {
                Name                    = "Excel Calculation Services"
                PsDscRunAsCredential    = $SPInstallAccountCredential
            }

            SPServiceInstance SandboxedCodeService
            {
                Name                    = "Microsoft SharePoint Foundation Sandboxed Code Service"
                PsDscRunAsCredential    = $SPInstallAccountCredential
            }

            SPServiceInstance PerformancePointService
            {
                Name                    = "PerformancePoint Service"
                PsDscRunAsCredential    = $SPInstallAccountCredential
            }

            SPServiceInstance VisioGraphicsService
            {
                Name                    = "Visio Graphics Service"
                PsDscRunAsCredential    = $SPInstallAccountCredential
            }

            SPServiceInstance WordAutomationServiceInstance
            {
                Name                    = "Word Automation Services"
                PsDscRunAsCredential    = $SPInstallAccountCredential
            }

            SPServiceInstance WorkflowTimerServiceInstance
            {
                Name                    = "Microsoft SharePoint Foundation Workflow Timer Service"
                PsDscRunAsCredential    = $SPInstallAccountCredential
            }

            SPServiceInstance SearchHostControllerService
            {
                Name                    = "Search Host Controller Service"
                PsDscRunAsCredential    = $SPInstallAccountCredential
            }

            SPServiceInstance SearchQueryandSiteSettingsService
            {
                Name                    = "Search Query and Site Settings Service"
                PsDscRunAsCredential    = $SPInstallAccountCredential
            }

            SPServiceInstance SharePointServerSearch
            {
                Name                    = "SharePoint Server Search"
                PsDscRunAsCredential    = $SPInstallAccountCredential
            }

            SPDistributedCacheService EnableDistributedCache
            {
                Name                    = "AppFabricCachingService"
                CacheSizeInMB           = 2048
                ServiceAccount          = $SPServicesAccountCredential.UserName
                CreateFirewallRules     = $true
                PsDscRunAsCredential    = $SPInstallAccountCredential
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
$securedPassword = ConvertTo-SecureString "c0mp1Expa~~" -AsPlainText -Force
$SPInstallAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_spadm16", $securedPassword );
$SPServicesAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_spsrv16", $securedPassword );

$configurationData = @{ AllNodes = @(
    @{ NodeName = $env:COMPUTERNAME; PSDscAllowPlainTextPassword = $True; PsDscAllowDomainUser = $True }
) }
Write-Host "$(Get-Date) Compiling DSC"
try
{
    &$configName `
        -ConfigurationData $configurationData `
        -SPInstallAccountCredential $SPInstallAccountCredential `
        -SPServicesAccountCredential $SPServicesAccountCredential;
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
if ( $env:SPDEVOPSSTARTER_NODSCTEST -ne "TRUE" )
{
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
} else {
    Write-Host "$(Get-Date) Skipping tests"
}
Exit 0;
