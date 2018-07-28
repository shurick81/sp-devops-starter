$configName = "OOSBin"
Write-Host "$(Get-Date) Defining DSC"
try
{
    Configuration $configName
    {
        param(
        )

        Import-DscResource -ModuleName PSDesiredStateConfiguration
        Import-DscResource -ModuleName OfficeOnlineServerDsc -ModuleVersion 1.2.0.0

        $requiredFeatures = @(
            "Web-Server",
            "Web-Mgmt-Tools",
            "Web-Mgmt-Console",
            "Web-WebServer",
            "Web-Common-Http",
            "Web-Default-Doc",
            "Web-Static-Content",
            "Web-Performance",
            "Web-Stat-Compression",
            "Web-Dyn-Compression",
            "Web-Security",
            "Web-Filtering",
            "Web-Windows-Auth",
            "Web-App-Dev",
            "Web-Net-Ext45",
            "Web-Asp-Net45",
            "Web-ISAPI-Ext",
            "Web-ISAPI-Filter",
            "Web-Includes",
            "NET-Framework-Features",
            "NET-Framework-45-Features",
            "NET-Framework-Core",
            "NET-Framework-45-Core",
            "NET-HTTP-Activation",
            "NET-Non-HTTP-Activ",
            "NET-WCF-HTTP-Activation45",
            "Windows-Identity-Foundation",
            "Server-Media-Foundation" )
        $OOSInstallationMediaPath = "C:\Install\OOSInstall";
        
        Node $AllNodes.NodeName
        {

            Registry UpdateFromWindowsUpdateCenterEnable
            {
                Ensure      = "Present"
                Key         = "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Servicing"
                ValueName   = "LocalSourcePath"
                ValueType   = "ExpandString"
            }
    
            Registry UpdateFromWindowsUpdateCenter
            {
                Ensure      = "Present"
                Key         = "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Servicing"
                ValueName   = "RepairContentServerSource"
                ValueType   = "DWORD"
                ValueData   = "2"
                DependsOn   = "[Registry]UpdateFromWindowsUpdateCenterEnable"
            }
    
            foreach ($feature in $requiredFeatures)
            {
    
                WindowsFeature "WindowsFeature-$feature"
                {
                    Ensure = 'Present'
                    Name   = $feature
                }
    
            }
            $prereqDependencies = $RequiredFeatures | ForEach-Object -Process {
                return "[WindowsFeature]WindowsFeature-$_"
            }
        
            OfficeOnlineServerInstall InstallBinaries
            {
                Ensure    = "Present"
                Path      = "$OOSInstallationMediaPath\2016\OOS\setup.exe"
                DependsOn = $prereqDependencies
            }
    
            OfficeOnlineServerInstallLanguagePack SwedishLanguagePack
            {
                Ensure = "Present"
                BinaryDir = "$OOSInstallationMediaPath\2016\LanguagePacks\sv-se"
                Language = "sv-se"
                DependsOn = "[OfficeOnlineServerInstall]InstallBinaries"
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
