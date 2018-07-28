download iso from MSDN site.
```PowerShell
$imagePath = (Resolve-Path ./).Path + "\en_office_online_server_last_updated_november_2017_x64_dvd_100181876.iso"
$OOSLanguagePackUrl = "https://download.microsoft.com/download/5/B/7/5B7D1B87-2619-4DF6-AA2C-F2EB707E2231/wacserverlanguagepack.exe"
$OOSCumulativeUpdateUrl = "https://download.microsoft.com/download/F/6/6/F6643383-9CCC-42F7-B66C-F1366BF65CED/wacserver2016-kb4011026-fullfile-x64-glb.exe"
$tempDestination = ".\OOS"
$oosDirectoryName = "OOS"
Write-Host "Checking $imagePath file"
$ISOFile = Get-ChildItem $imagePath -ErrorAction SilentlyContinue;
if ( $ISOFile )
{
    Write-Host "Mounting image file";
    $mountResult = Mount-DiskImage $imagePath -PassThru;
    $driveLetter = ( $mountResult | Get-Volume ).DriveLetter;
    Get-PSDrive > $null
    Write-Host "Waiting while files are ready on $driveLetter drive";
    Do {
        $driveFiles = $null;
        $temp = Start-Sleep 5;
        $driveFiles = Get-ChildItem "$driveLetter`:\*" -Recurse -ErrorAction SilentlyContinue;
    } Until ( $driveFiles )

    #Source builder
    Write-Host "Copy source files to the temp location"
    New-Item -ItemType Directory -Force -Path "$tempDestination\2016\$oosDirectoryName" | Out-Null;
    Copy-Item -Path "$driveLetter`:\*" -Destination "$tempDestination\2016\$oosDirectoryName" -Recurse;
    Write-Host "Dismounting image file";
    Dismount-DiskImage -ImagePath $imagePath;

    Write-Host "Cleaning the LP temp folder"
    $lpFolderPath = "$env:TEMP\OOSLPTemp";
    $lpTempFiles = $null;
    $lpTempFiles = Get-ChildItem $lpFolderPath -ErrorAction SilentlyContinue;
    if ( $lpTempFiles )
    {
        Write-Host "Existing files in $lpFolderPath are found, deleting";
        Remove-Item -Force -Recurse -Path $lpFolderPath;
    }
    New-Item -ItemType Directory -Force -Path $lpFolderPath | Out-Null;
    Sleep 3;
    Write-Host "Downloading $OOSLanguagePackUrl into $lpFolderPath"
    $OOSLPFileName = $OOSLanguagePackUrl.Split('/')[-1]
    Start-BitsTransfer -Source $OOSLanguagePackUrl -Destination "$lpFolderPath\$OOSLPFileName"
    $filePath = "$lpFolderPath\$OOSLPFileName"
    if ( Test-Path $filePath )
    {
        Write-Host "Unpacking LP into destination"
        Start-Process -FilePath $filePath -ArgumentList "/extract:`"$tempDestination\2016\LanguagePacks\sv-se`" /passive /quiet" -Wait -NoNewWindow
        Sleep 10;
        Remove-Item -Force -Recurse -Path $lpFolderPath;

        Write-Host "Cleaning the CU temp folder"
        $cuFolderPath = "$env:TEMP\OOSCUTemp";
        $cuTempFiles = $null;
        $cuTempFiles = Get-ChildItem $cuFolderPath -ErrorAction SilentlyContinue;
        if ( $cuTempFiles )
        {
            Write-Host "Existing files in $cuFolderPath are found, deleting";
            Remove-Item -Force -Recurse -Path $cuFolderPath;
        }
        New-Item -ItemType Directory -Force -Path $cuFolderPath | Out-Null;
        Write-Host "Downloading $OOSCumulativeUpdateUrl into $cuFolderPath";
        $OOSCUFileName = $OOSCumulativeUpdateUrl.Split('/')[-1];
        Start-BitsTransfer -Source $OOSCumulativeUpdateUrl -Destination "$cuFolderPath\$OOSCUFileName";
        $filePath = "$cuFolderPath\$OOSCUFileName";
        if ( Test-Path $filePath )
        {
            Write-Host "Unpacking CU into destination";
            Start-Process -FilePath $filePath -ArgumentList "/extract:`"$tempDestination\2016\OOS\Updates`" /passive" -Wait -NoNewWindow;
            Sleep 10;
            Remove-Item -Force -Recurse -Path $cuFolderPath;
        }
    }
}
.\media.ps1 .\mediaoos.json
```
