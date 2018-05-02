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

    Node $AllNodes.NodeName
    {

        xIEEsc DisableIEEsc
        {
            IsEnabled   = $false;
            UserRole    = "Administrators"
        }

        Script VSInstallerRunning
        {
            SetScript = {
                Start-Process -FilePath C:\Install\VSInstall\vs_enterprise.exe -ArgumentList '--quiet --wait --add Microsoft.VisualStudio.Workload.Office --includeRecommended' -Wait; 
            }
            TestScript = {
                $products = Get-WmiObject -Class Win32_Product | ? { $_.Name -eq "Microsoft Visual Studio Setup Configuration" }
                $products;
                if ( $products ) {
                    Write-Host "Products found";
                    return $true;
                } else {
                    Write-Host "Products not found";
                    return $false;
                }
            }
            GetScript = {
                $installedApplications = Get-WmiObject -Class Win32_Product | ? { $_.name -eq "Microsoft Visual Studio Setup Configuration" }
                return $installedApplications
            }
        }

        Package SSMS
        {
            Ensure      = "Present"
            Name        = "SMS-Setup-ENU"
            Path        = "C:\Install\SSMS-Setup-ENU.exe"
            Arguments   = "/install /passive /norestart"
            ProductId   = "6ce0f2ad-2643-496c-9b48-d0587d3e10a9"
        }

    }
}

$configurationData = @{ AllNodes = @(
    @{ NodeName = $env:COMPUTERNAME; PSDscAllowPlainTextPassword = $True; PsDscAllowDomainUser = $True }
) }
$securedPassword = ConvertTo-SecureString "Fractalsol" -AsPlainText -Force
$UserCredential = New-Object System.Management.Automation.PSCredential( "administrator", $securedPassword )
Write-Host "$(Get-Date) Compiling DSC"
try
{
    &$configName `
        -ConfigurationData $configurationData `
        -UserCredential $UserCredential;
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
Exit 0;
    