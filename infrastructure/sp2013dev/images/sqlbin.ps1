$configName = "SQLBin"
Configuration $configName
{

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xPendingReboot -ModuleVersion 0.3.0.0
    Import-DscResource -ModuleName SqlServerDsc -ModuleVersion 11.1.0.0

    Node $AllNodes.NodeName
    {

        WindowsFeature WindowsDefenderRemoved
        {
            Name    = "Windows-Defender"
            Ensure  = "Absent"
        }

        WindowsFeature WindowsDefenderGUIRemoved
        {
            Name    = "Windows-Defender-GUI"
            Ensure  = "Absent"
        }

        WindowsFeature NetFramework35Core
        {
            Name                    = "NET-Framework-Core"
        }

        xPendingReboot RebootBeforeSQLInstalling
        { 
            Name        = 'BeforeSQLInstalling'
            DependsOn   = "[WindowsFeature]NetFramework35Core"
        }
        
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
            SQLCollation            = "Finnish_Swedish_CI_AS_KS_WS"
            BrowserSvcStartupType   = "Automatic"   
            DependsOn               = "[WindowsFeature]NetFramework35Core"
        }

        SqlServerMemory SQLServerMaxMemoryIs2GB
        {
            Ensure          = "Present"
            DynamicAlloc    = $false
            MinMemory       = 1024
            MaxMemory       = 2048
            ServerName      = "sqltest.company.local"
            InstanceName    = "SPIntra01"
        }
        
    }
}

$configurationData = @{ AllNodes = @(
    @{ NodeName = 'localhost'; PSDscAllowPlainTextPassword = $True; PsDscAllowDomainUser = $True }
) }

&$configName `
    -ConfigurationData $configurationData;
Start-DscConfiguration $configName -Verbose -Wait -Force;