$configName = "DevBin"
Configuration $configName
{
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullorEmpty()]
        [PSCredential]
        $UserCredential
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DSCResource -Module xSystemSecurity -Name xIEEsc -ModuleVersion 1.2.0.0
    Import-DSCResource -ModuleName cChoco -ModuleVersion 2.3.1.0

    Node $AllNodes.NodeName
    {

        xIEEsc DisableIEEsc
        {
            IsEnabled   = $false
            UserRole    = "Administrators"
        }

        Script VSInstallerRunning
        {
            SetScript = {
                Start-Process -FilePath C:\Install\VSInstall\vs_enterprise.exe -ArgumentList '--layout C:\Install\VSInstall --quiet --wait --add Microsoft.VisualStudio.Workload.Office --includeRecommended' -Wait; 
            }
            TestScript = {
                Get-WmiObject -Class Win32_Product | ? { $_.name -eq "Microsoft Visual Studio Setup Configuration" } | % { return $true }
                return $false
            }
            GetScript = {
                $installedApplications = Get-WmiObject -Class Win32_Product | ? { $_.name -eq "Microsoft Visual Studio Setup Configuration" }
                return $installedApplications
            }
        }

        cChocoInstaller ChocoInstalled
        {
            InstallDir              = "c:\choco"
            PsDscRunAsCredential    = $UserCredential
        }

        cChocoPackageInstaller VSCodeInstalled
        {
            Name                    = "visualstudiocode"
            DependsOn               = "[cChocoInstaller]ChocoInstalled"
            PsDscRunAsCredential    = $UserCredential
        }

        cChocoPackageInstaller GitInstalled
        {
            Name                    = "git"
            DependsOn               = "[cChocoInstaller]ChocoInstalled"
            PsDscRunAsCredential    = $UserCredential
        }

    }
}

$configurationData = @{ AllNodes = @(
    @{ NodeName = $env:COMPUTERNAME; PSDscAllowPlainTextPassword = $True; PsDscAllowDomainUser = $True }
) }

$securedPassword = ConvertTo-SecureString "Fractalsol" -AsPlainText -Force
$UserCredential = New-Object System.Management.Automation.PSCredential( "administrator", $securedPassword )

&$configName `
    -ConfigurationData $configurationData `
    -UserCredential $UserCredential;
Start-DscConfiguration $configName -Verbose -Wait -Force;
