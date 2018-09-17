$configName = "SQLBin"
Write-Host "$(Get-Date) Defining DSC"
try
{
    Configuration $configName
    {

        Import-DscResource -ModuleName PSDesiredStateConfiguration
        Import-DscResource -ModuleName SqlServerDsc -ModuleVersion 11.1.0.0

        Node $AllNodes.NodeName
        {
            
            SQLSetup SQLSetup
            {
                InstanceName            = "SPIntra01"
                SourcePath              = "C:\Install\SQLInstall"
                Features                = "SQLENGINE,FULLTEXT"
                InstallSharedDir        = "C:\Program Files\Microsoft SQL Server\SPIntra01"
                SQLSysAdminAccounts     = "BUILTIN\Administrators"
                UpdateEnabled           = "False"
                UpdateSource            = "MU"
                SQMReporting            = "False"
                ErrorReporting          = "True"
                BrowserSvcStartupType   = "Automatic"
            }

            SqlServerMemory SQLServerMaxMemoryIs2GB
            {
                ServerName      = $NodeName
                DynamicAlloc    = $false
                MinMemory       = 1024
                MaxMemory       = 2048
                InstanceName    = "SPIntra01"
                DependsOn       = "[SQLSetup]SQLSetup"
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
