$configName = "SPFarm"
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
            $SPServicesAccountCredential,
            [Parameter(Mandatory=$true)]
            [ValidateNotNullorEmpty()]
            [PSCredential]
            $SPWebAppPoolAccountCredential
        )
        Import-DscResource -ModuleName PSDesiredStateConfiguration
        Import-DSCResource -ModuleName SharePointDSC -ModuleVersion 2.4.0.0

        Node $AllNodes.NodeName
        {

            SPManagedAccount SharePointServicesPoolAccount
            {
                AccountName             = $SPServicesAccountCredential.UserName
                Account                 = $SPServicesAccountCredential
                PsDscRunAsCredential    = $SPInstallAccountCredential
            }

            SPServiceAppPool SharePointServicesAppPool
            {
                Name                    = "SharePoint Services App Pool"
                ServiceAccount          = $SPServicesAccountCredential.UserName
                PsDscRunAsCredential    = $SPInstallAccountCredential
                DependsOn               = "[SPManagedAccount]SharePointServicesPoolAccount"
            }

            SPManagedMetaDataServiceApp ManagedMetadataServiceApp
            {
                DatabaseName            = "SP_Intra_Metadata";
                ApplicationPool         = "SharePoint Services App Pool";
                ProxyName               = "Managed Metadata Service Application";
                Name                    = "Managed Metadata Service Application";
                Ensure                  = "Present";
                TermStoreAdministrators = @( $SPInstallAccountCredential.UserName, "contoso\OG SharePoint2016 Server Admin Prod" );
                PsDscRunAsCredential    = $SPInstallAccountCredential
                DependsOn               = "[SPServiceAppPool]SharePointServicesAppPool"
            }

            SPManagedMetaDataServiceAppDefault ManagedMetadataServiceAppDefault
            {
                IsSingleInstance                = "Yes"
                DefaultSiteCollectionProxyName  = "Managed Metadata Service Application"
                DefaultKeywordProxyName         = "Managed Metadata Service Application"
                PsDscRunAsCredential            = $SPInstallAccountCredential
            }
            
            SPManagedAccount ApplicationWebPoolAccount
            {
                AccountName             = $SPWebAppPoolAccountCredential.UserName
                Account                 = $SPWebAppPoolAccountCredential
                PsDscRunAsCredential    = $SPInstallAccountCredential
            }

            SPWebApplication DefaultWebApp
            {
                Name                    = "Default App"
                ApplicationPool         = "All Web Applications"
                ApplicationPoolAccount  = $SPWebAppPoolAccountCredential.UserName
                Url                     = "http://$NodeName"
                Port                    = 80
                DatabaseName            = "SP_Intra_Content_WA00"
                PsDscRunAsCredential    = $SPInstallAccountCredential
                DependsOn               = "[SPManagedAccount]ApplicationWebPoolAccount"
            }
        
            SPSite DefaultPathSite
            {
                Url                     = "http://$NodeName"
                OwnerAlias              = $SPInstallAccountCredential.UserName
                Name                    = "Default Team Site"
                Template                = "STS#0"
                PsDscRunAsCredential    = $SPInstallAccountCredential
                DependsOn               = "[SPWebApplication]DefaultWebApp"
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
$SPWebAppPoolAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_spwebapppool16", $securedPassword );

$configurationData = @{ AllNodes = @(
    @{ NodeName = $env:COMPUTERNAME; PSDscAllowPlainTextPassword = $True; PsDscAllowDomainUser = $True }
) }
Write-Host "$(Get-Date) Compiling DSC"
try
{
    &$configName `
        -ConfigurationData $configurationData `
        -SPInstallAccountCredential $SPInstallAccountCredential `
        -SPServicesAccountCredential $SPServicesAccountCredential `
        -SPWebAppPoolAccountCredential $SPWebAppPoolAccountCredential;
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
