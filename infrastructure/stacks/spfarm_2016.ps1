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
        Import-DSCResource -ModuleName SharePointDSC -ModuleVersion 3.0.0.0

        Node $AllNodes.NodeName
        {

            SqlAlias SPDBAlias
            {
                Ensure              = 'Present'
                Name                = 'SPDB'
                ServerName          = 'DBWEB01\SPIntra01'
                UseDynamicTcpPort   = $true
            }

            SPFarm Farm
            {
                IsSingleInstance            = "Yes"
                Ensure                      = "Present"
                DatabaseServer              = "SPDB"
                FarmConfigDatabaseName      = "SP_Intra01_Config"
                AdminContentDatabaseName    = "SP_Intra01_Content_CA"
                Passphrase                  = $SPPassphraseCredential
                FarmAccount                 = $SPFarmAccountCredential
                RunCentralAdmin             = $true
                CentralAdministrationPort   = 15555
                ServerRole                  = "SingleServerFarm"
                PsDscRunAsCredential        = $SPInstallAccountCredential
                DependsOn                   = "[SqlAlias]SPDBAlias"
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
$securedPassword = ConvertTo-SecureString "sUp3rcomp1eX" -AsPlainText -Force
$SPPassphraseCredential = New-Object System.Management.Automation.PSCredential( "fakeaccount", $securedPassword )
$securedPassword = ConvertTo-SecureString "c0mp1Expa~~" -AsPlainText -Force
$SPInstallAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_spadm16", $securedPassword );
$SPFarmAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_spfrm16", $securedPassword );

$configurationData = @{ AllNodes = @(
    @{ NodeName = $env:COMPUTERNAME; PSDscAllowPlainTextPassword = $True; PsDscAllowDomainUser = $True }
) }
Write-Host "$(Get-Date) Compiling DSC"
try
{
    &$configName `
        -ConfigurationData $configurationData `
        -SPPassphraseCredential $SPPassphraseCredential `
        -SPInstallAccountCredential $SPInstallAccountCredential `
        -SPFarmAccountCredential $SPFarmAccountCredential;
}
catch
{
    Write-Host "$(Get-Date) Exception in compiling DCS:";
    $_.Exception.Message
    Exit 1;
}
$provider = $null
$computerSystem = Get-WmiObject -Class Win32_ComputerSystem;
$computerSystem;
if ( $computerSystem.Model -eq "VirtualBox" ) {
    Write-Host "Model is VirtualBox";
    $provider = "virtualbox";
}
if ( ( $computerSystem.Manufacturer -eq "Microsoft" ) -or ( $computerSystem.Manufacturer -eq "Microsoft Corporation" ) ) {
    Write-Host "Manufacturer is Microsoft";
    $provider = "hyperv";
    Get-DnsClient | % { if ( ( $_.ConnectionSpecificSuffix -like "*.cloudapp.net" ) -or ( $_.ConnectionSpecificSuffix -like "*.microsoft.com" ) ) {
        Write-Host "Found azure interface";
        $provider = "azure";
    } }
}
Write-Host "$(Get-Date) Starting DSC"
try
{
    if ( $provider -eq "azure" )
    {
        Start-DscConfiguration $configName -Verbose -Force;
        Sleep 20;
        0..720 | % {
            $res = Get-DscLocalConfigurationManager;
            Write-Host $res.LCMState;
            if ( ( $res.LCMState -ne "Idle" ) -and ( $res.LCMState -ne "PendingConfiguration" ) ) {
                Sleep 10;
            }
        }
        if ( ( $res.LCMState -ne "Idle" ) -and ( $res.LCMState -ne "PendingConfiguration" ) ) {
            Write-Host "Timouted waiting for LCMState"
            Exit 1;
        }
    } else {
        Start-DscConfiguration $configName -Verbose -Wait -Force;
    }
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
