$configName = "DevMediaClean"
Write-Host "$(Get-Date) Defining DSC"
try
{
    Configuration $configName
    {
        param(
        )

        Import-DscResource -ModuleName PSDesiredStateConfiguration

        $SPImageLocation = $systemParameters.SPImageLocation
        $SPInstallationMediaPath = $configParameters.SPInstallationMediaPath
        $SPVersion = $configParameters.SPVersion;

        Node $AllNodes.NodeName
        {

            File VSNoLocalMediaEnsure {
                DestinationPath = "C:\Install\VSInstall"
                Recurse         = $true
                Type            = "Directory"
                Ensure          = "Absent"
                Force           = $true
            }

            File VSNoLocalMediaArchiveEnsure {
                DestinationPath = "C:\Install\VS2017.zip"
                Ensure          = "Absent"
            }

            File VSNoSSMSMediaArchiveEnsure {
                DestinationPath = "C:\Install\SSMS-Setup-ENU.exe"
                Ensure          = "Absent"
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
