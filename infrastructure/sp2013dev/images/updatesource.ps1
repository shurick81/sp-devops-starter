$configName = "UpdateSource"
Configuration $configName
{
    param(
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node localhost {

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

    }
}

$configurationData = @{ AllNodes = @(
    @{ NodeName = $env:COMPUTERNAME; PSDscAllowPlainTextPassword = $True; PsDscAllowDomainUser = $True }
) }

&$configName `
    -ConfigurationData $configurationData;
Start-DscConfiguration $configName -Verbose -Wait -Force;