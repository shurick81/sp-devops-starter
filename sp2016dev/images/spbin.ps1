$configName = "SPBin"
Configuration $configName
{
    param(
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName StorageDsc -ModuleVersion 4.0.0.0
    Import-DSCResource -ModuleName SharePointDSC -ModuleVersion 2.1.0.0

    Node $AllNodes.NodeName
    {

        WindowsFeature WindowsDefenderRemoved
        {
            Name    = "Windows-Defender"
            Ensure  = "Absent"
        }

        WindowsFeature WindowsDefenderGUIRemoved
        {
            Name    = "Windows-Defender-GUI"
            Ensure  = "Absent"
        }

        $SPImageDestinationPath = "C:\Install\SP2016RTMImage\officeserver.img"

        MountImage SPServerImageMounted
        {
            ImagePath   = $SPImageDestinationPath
            DriveLetter = 'F'
        }

        WaitForVolume SPServerImageMounted
        {
            DriveLetter      = 'F'
            RetryIntervalSec = 5
            RetryCount       = 10
            DependsOn   = "[MountImage]SPServerImageMounted"
        }
        
        SPInstallPrereqs SPPrereqsInstalled
        {
            InstallerPath   = "F:\Prerequisiteinstaller.exe"
            OnlineMode      = $true
            DependsOn   = "[WaitForVolume]SPServerImageMounted"
        }

        SPInstall SharePointBinariesInstalled 
        { 
            Ensure      = "Present"
            BinaryDir   = "F:"
            ProductKey  = "NQGJR-63HC8-XCRQH-MYVCH-3J3QR"
            DependsOn   = "[SPInstallPrereqs]SPPrereqsInstalled"
        }

    }
}

$configurationData = @{ AllNodes = @(
    @{ NodeName = $env:COMPUTERNAME; PSDscAllowPlainTextPassword = $True; PsDscAllowDomainUser = $True }
) }

&$configName `
    -ConfigurationData $configurationData;
Start-DscConfiguration $configName -Verbose -Wait -Force;