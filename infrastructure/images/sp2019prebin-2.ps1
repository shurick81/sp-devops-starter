$configName = "SPPreBin"
Write-Host "$(Get-Date) Defining DSC"
try
{
    Configuration $configName
    {
        param(
        )

        Import-DscResource -ModuleName PSDesiredStateConfiguration

        $featureNames = @(
            "Web-WebServer",
            "Web-Common-Http",
            "Web-Default-Doc",
            "Web-Dir-Browsing",
            "Web-Http-Errors",
            "Web-Static-Content",
            "Web-Health",
            "Web-Http-Logging",
            "Web-Log-Libraries",
            "Web-Request-Monitor",
            "Web-Http-Tracing",
            "Web-Performance",
            "Web-Stat-Compression",
            "Web-Dyn-Compression",
            "Web-Security",
            "Web-Filtering",
            "Web-Basic-Auth",
            "Web-Digest-Auth",
            "Web-Windows-Auth",
            "Web-App-Dev",
            "Web-Net-Ext",
            "Web-Net-Ext45",
            "Web-Asp-Net",
            "Web-Asp-Net45",
            "Web-ISAPI-Ext",
            "Web-ISAPI-Filter",
            "Web-Mgmt-Tools",
            "Web-Mgmt-Console",
            "Web-Mgmt-Compat",
            "Web-Metabase",
            "Web-Lgcy-Scripting",
            "Web-WMI",
            "NET-Framework-Features"
        )

        Node $AllNodes.NodeName
        {
            
            if ( $env:SPDEVOPSSTARTER_LOCALSOURCE -eq 1 )
            {

                WindowsFeatureSet SPFeatures
                {
                    Name                    = $featureNames
                    Ensure                  = 'Present'
                    Source                  = "D:\sources\sxs"
                    IncludeAllSubFeature    = $true
                }

            } else {

                WindowsFeatureSet SPFeatures
                {
                    Name                    = $featureNames
                    Ensure                  = 'Present'
                    IncludeAllSubFeature    = $true
                }

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
    ) 
}
Write-Host "$(Get-Date) Compiling DSC"
try {
    &$configName `
        -ConfigurationData $configurationData;
}
catch {
    Write-Host "$(Get-Date) Exception in compiling DCS:";
    $_.Exception.Message
    Exit 1;
}
Write-Host "$(Get-Date) Starting DSC"
try {
    Start-DscConfiguration $configName -Verbose -Wait -Force;
}
catch {
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
