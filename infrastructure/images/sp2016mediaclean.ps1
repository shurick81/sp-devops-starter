$configName = "SPMedia"
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

            $SPImageDestinationPath = "C:\Install\SP2016RTMImage\officeserver.img"

            MountImage SPServerImageNotMounted
            {
                ImagePath   = $SPImageDestinationPath
                Ensure      = 'Absent'
            }

            File SPServerImageAbsent {
                Ensure          = "Absent"
                DestinationPath = $SPImageDestinationPath
                Force           = $true
                DependsOn       = "[MountImage]SPServerImageNotMounted"
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
