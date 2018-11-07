$configName = "DevBin"
Write-Host "$(Get-Date) Defining DSC"
try
{
    Configuration $configName
    {
        param(
        )

        Import-DscResource -ModuleName PSDesiredStateConfiguration
        Import-DSCResource -ModuleName cChoco -ModuleVersion 2.3.1.0
        Import-DscResource -ModuleName xPSDesiredStateConfiguration -Name xRemoteFile -ModuleVersion 8.4.0.0

        Node $AllNodes.NodeName
        {

            cChocoInstaller ChocoInstalled
            {
                InstallDir              = "c:\choco"
            }

            cChocoPackageInstaller VSCodeInstalled
            {
                Name                    = "visualstudiocode"
                DependsOn               = "[cChocoInstaller]ChocoInstalled"
            }

            cChocoPackageInstaller GitInstalled
            {
                Name                    = "git"
                DependsOn               = "[cChocoInstaller]ChocoInstalled"
            }

            cChocoPackageInstaller installnodejs
            {
                Name                    = "nodejs"
                DependsOn               = "[cChocoInstaller]ChocoInstalled"
            }
        
            WindowsFeatureSet DomainFeatures
            {
                Name                    = @( "RSAT-DNS-Server", "RSAT-ADDS", "RSAT-ADCS" )
                Ensure                  = 'Present'
            }

            xRemoteFile SP2016CLientSDK
            {
                Uri             = "https://download.microsoft.com/download/F/A/3/FA3B7088-624A-49A6-826E-5EF2CE9095DA/sharepointclientcomponents_16-4351-1000_x64_en-us.msi"
                DestinationPath = "C:\Install\SQLClientSDK\sharepointclientcomponents_16-4351-1000_x64_en-us.msi"
                MatchSource     = $false
            }

            Package SP2016CLientSDK
            {
                Ensure      = "Present"
                Name        = "SharePoint Client Components"
                Path        = "C:\Install\SQLClientSDK\sharepointclientcomponents_16-4351-1000_x64_en-us.msi"
                Arguments   = "/i /norestart"
                ProductId   = "95160003-1163-0409-1000-0000000FF1CE"
                DependsOn   = "[xRemoteFile]SP2016CLientSDK"
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
