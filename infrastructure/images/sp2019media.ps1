$configName = "SPMedia"
Write-Host "$(Get-Date) Defining DSC"
try
{
    Configuration $configName
    {
        param(
        )
    
        Import-DscResource -ModuleName PSDesiredStateConfiguration
        Import-DscResource -ModuleName xPSDesiredStateConfiguration -Name xRemoteFile -ModuleVersion 8.2.0.0
        Import-DscResource -ModuleName StorageDsc -ModuleVersion 4.0.0.0
    
        Node $AllNodes.NodeName
        {
    
            $spImageUrl = "https://download.microsoft.com/download/C/B/A/CBA01793-1C8A-4671-BE0D-38C9E5BBD0E9/officeserver.img";
            $SPImageUrl -match '[^/\\&\?]+\.\w{3,4}(?=([\?&].*$|$))' | Out-Null
            $SPImageFileName = $matches[0]
            $SPImageDestinationPath = "C:\Install\SP2019PreviewImage\$SPImageFileName"
    
            xRemoteFile SPServerImageFilePresent
            {
                Uri             = $SPImageUrl
                DestinationPath = $SPImageDestinationPath
                MatchSource     = $false
            }
    
            MountImage SPServerImageMounted
            {
                ImagePath   = $SPImageDestinationPath
                DriveLetter = 'G'
                DependsOn   = "[xRemoteFile]SPServerImageFilePresent"
            }
    
            WaitForVolume SPServerImageMounted
            {
                DriveLetter      = 'G'
                RetryIntervalSec = 5
                RetryCount       = 10
                DependsOn   = "[MountImage]SPServerImageMounted"
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
    if ( $env:SPDEVOPSSTARTER_NODSCWAIT )
    {
        Start-DscConfiguration $configName -Verbose -Force;
        Sleep 20;
        0..720 | % {
            $res = Get-DscLocalConfigurationManager;
            Write-Host $res.LCMState;
            if ( ( $res.LCMState -ne "Idle" ) -and ( $res.LCMState -ne "PendingConfiguration" ) ) {
                Sleep 10;
            }
        }
        if ( ( $res.LCMState -ne "Idle" ) -and ( $res.LCMState -ne "PendingConfiguration" ) ) {
            Write-Host "Timouted waiting for LCMState"
            Exit 1;
        }
    } else {
        Start-DscConfiguration $configName -Verbose -Wait -Force;
    }
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
} else {
    Write-Host "$(Get-Date) Skipping tests"
}
Exit 0;
