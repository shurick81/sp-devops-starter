$configName = "SQLMedia"
Configuration $configName
{
    param(
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xPSDesiredStateConfiguration -Name xRemoteFile -ModuleVersion 8.2.0.0

    Node $AllNodes.NodeName
    {

        xRemoteFile SQLMediaArchive
        {
            Uri             = "http://$env:PACKER_HTTP_ADDR/SQLServer2014SP1.zip"
            DestinationPath = "C:\Install\SQLServer2014SP1.zip"
            MatchSource     = $false
        }

        Archive SQLMediaArchiveUnpacked
        {
            Ensure      = "Present"
            Path        = "C:\Install\SQLServer2014SP1.zip"
            Destination = "C:\Install\SQLInstall"
            DependsOn   = "[xRemoteFile]SQLMediaArchive"
        }
        
    }
}

$configurationData = @{ AllNodes = @(
    @{ NodeName = 'localhost'; PSDscAllowPlainTextPassword = $True; PsDscAllowDomainUser = $True }
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
