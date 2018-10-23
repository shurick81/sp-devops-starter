$configName = "SQLConfig"
Write-Host "$(Get-Date) Defining DSC"
try
{
    Configuration $configName
    {

        Import-DscResource -ModuleName PSDesiredStateConfiguration
        Import-DscResource -ModuleName xNetworking -ModuleVersion 5.6.0.0
        Import-DscResource -ModuleName SqlServerDsc -ModuleVersion 11.1.0.0

        Node $AllNodes.NodeName
        {
            
            xFireWall AllowSQLService
            {
                Name        = "AllowSQLService"
                DisplayName = "Allow SQL Service"
                Ensure      = "Present"
                Enabled     = "True"
                Profile     = "Domain"
                Direction   = "InBound"
                Program     = 'C:\Program Files\Microsoft SQL Server\MSSQL12.SPINTRA01\MSSQL\Binn\sqlservr.exe'
                Protocol    = "TCP"
                Description = "Firewall rule to allow SQL communication"
            }
            
            xFireWall AllowSQLBrowser
            {
                Name        = "AllowSQLBrowser"
                DisplayName = "Allow SQL Browser"
                Ensure      = "Present"
                Enabled     = "True"
                Profile     = "Domain"
                Direction   = "InBound"
                LocalPort   = 1434
                Protocol    = "UDP"
                Description = "Firewall rule to allow SQL communication"
            }
            
            SqlServerMemory SQLServerMaxMemoryIs2GB
            {
                ServerName      = $NodeName
                DynamicAlloc    = $false
                MinMemory       = 1024
                MaxMemory       = 2048
                InstanceName    = "SPIntra01"
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
Write-Host "$(Get-Date) Compiling DSC"
try
{
    &$configName `
        -ConfigurationData $configurationData;
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
