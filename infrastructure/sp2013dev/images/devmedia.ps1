$configName = "SQLMedia"
Configuration $configName
{
    param(
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xPSDesiredStateConfiguration -Name xRemoteFile -ModuleVersion 8.2.0.0

    Node $AllNodes.NodeName
    {

        xRemoteFile VSMediaArchive
        {
            Uri             = "http://$env:PACKER_HTTP_ADDR/VS2017.zip"
            DestinationPath = "C:\Install\VS2017.zip"
            MatchSource     = $false
        }

        Archive VSMediaArchiveUnpacked
        {
            Ensure      = "Present"
            Path        = "C:\Install\VS2017.zip"
            Destination = "C:\Install\VSInstall"
            DependsOn   = "[xRemoteFile]VSMediaArchive"
        }

        xRemoteFile SSMSMedia
        {
            Uri             = "https://download.microsoft.com/download/C/3/D/C3DBFF11-C72E-429A-A861-4C316524368F/SSMS-Setup-ENU.exe"
            DestinationPath = "C:\Install\SSMS-Setup-ENU.exe"
            MatchSource     = $false
        }

    }
}

$configurationData = @{ AllNodes = @(
    @{ NodeName = 'localhost'; PSDscAllowPlainTextPassword = $True; PsDscAllowDomainUser = $True }
) }
Write-Host "$(Get-Date) Compiling DSC"
&$configName `
    -ConfigurationData $configurationData;
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
        