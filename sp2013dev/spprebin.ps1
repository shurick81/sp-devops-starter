$configName = "SPPreBin"
Configuration $configName
{
    param(
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node $AllNodes.NodeName
    {
        
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true;
        }

        @(
            "Application-Server",
            "AS-NET-Framework",
            "AS-TCP-Port-Sharing",
            "AS-Web-Support",
            "AS-WAS-Support",
            "AS-HTTP-Activation",
            "AS-Named-Pipes",
            "AS-TCP-Activation",
            "Web-Server",
            "Web-WebServer",
            "Web-Common-Http",
            "Web-Default-Doc",
            "Web-Dir-Browsing",
            "Web-Http-Errors",
            "Web-Static-Content",
            "Web-Http-Redirect",
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
            "Web-Client-Auth",
            "Web-Digest-Auth",
            "Web-Cert-Auth",
            "Web-IP-Security",
            "Web-Url-Auth",
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
            "Web-Scripting-Tools",
            "NET-Framework-Features",
            "NET-Framework-Core",
            "NET-Framework-45-ASPNET",
            "NET-WCF-HTTP-Activation45",
            "NET-WCF-Pipe-Activation45",
            "NET-WCF-TCP-Activation45",
            "Server-Media-Foundation",
            "Windows-Identity-Foundation",
            "PowerShell-V2",
            "WAS",
            "WAS-Process-Model",
            "WAS-NET-Environment",
            "WAS-Config-APIs",
            "XPS-Viewer"
        ) | % {

            WindowsFeature "SPPrerequisiteFeature$_"
            {
                Name = $_
                Ensure = "Present"
                Source = "D:\Sources\sxs"
            }

        }
    }
}

$configurationData = @{ AllNodes = @(
    @{ NodeName = $env:COMPUTERNAME; PSDscAllowPlainTextPassword = $True; PsDscAllowDomainUser = $True }
) }

&$configName `
    -ConfigurationData $configurationData;
Start-DscConfiguration $configName -Verbose -Wait -Force;
