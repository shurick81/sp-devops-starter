$configName = "SQLMedia"
Write-Host "$(Get-Date) Defining DSC"
try
{
    Configuration $configName
    {
        param(
        )
    
        Import-DscResource -ModuleName PSDesiredStateConfiguration
        Import-DscResource -ModuleName StorageDsc -ModuleVersion 4.0.0.0
    
        Node $AllNodes.NodeName
        {

            $SQLImageUrl = "https://download.microsoft.com/download/F/E/9/FE9397FA-BFAB-4ADD-8B97-91234BC774B2/SQLServer2016-x64-ENU.iso";
            $SQLImageUrl -match '[^/\\&\?]+\.\w{3,4}(?=([\?&].*$|$))' | Out-Null
            $SQLImageFileName = $matches[0]
            $SQLImageDestinationPath = "C:\Install\SQL2016RTMImage\$SQLImageFileName"

            MountImage SQLServerImageNotMounted
            {
                ImagePath   = $SQLImageDestinationPath
                Ensure      = 'Absent'
            }

            File SQLServerImageAbsent {
                Ensure          = "Absent"
                DestinationPath = $SQLImageDestinationPath
                Force           = $true
                DependsOn       = "[MountImage]SQLServerImageNotMounted"
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
Exit 0;
