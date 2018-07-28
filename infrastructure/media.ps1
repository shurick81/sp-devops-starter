param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullorEmpty()]
    [String]
    $ConFigFile
)

[Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null;

$config = Get-Content -Raw -Path $ConFigFile | ConvertFrom-Json;
@( "sql", "sp", "vs", "ssms", "oos" ) | % {
    $key = $_;
    Write-Host "$(Get-Date) Checking $key in configuration document";
    if ( $config.$key )
    {
        Write-Host "$(Get-Date) Processing $key media";
        $sourceImageUrl = $config.$key.SourceImageUrl;
        $directoryName = [guid]::NewGuid().Guid;
        $imageUNC = "$env:TEMP\$directoryName\image.iso";
        $unpackedUNC = $config.$key.UnpackedUNC;
        if ( !$unpackedUNC )
        {
            $unpackedUNC = "$env:TEMP\$directoryName\Extracted";
            $unpackedTemporary = $true;
        } else {
            $unpackedTemporary = $false;
        }
        $localFilePath = $config.$key.localFilePath;
        Write-Host "$(Get-Date) Checking $localFilePath";
        if ( !( Get-Item $localFilePath -ErrorAction Ignore ) )
        {
            if ( $localFilePath.Split(".")[-1] -eq "zip" )
            {
                if ( !( Get-Item $unpackedUNC -ErrorAction Ignore ) )
                {
                    if ( $sourceImageUrl )
                    {
                        if ( !( Get-Item $imageUNC -ErrorAction Ignore ) )
                        {
                            Write-Host "$(Get-Date) Local image file $imageUNC is not found locally, downloading from $sourceImageUrl.";
                            New-Item -ItemType Directory -Path "$env:TEMP\$directoryName" | Out-Null;
                            Start-BitsTransfer -Source $sourceImageUrl -Destination $imageUNC;
                            Write-Host "$(Get-Date) Done.";
                        }
                        if ( !( Get-Item $imageUNC ) )
                        {
                            Write-Host "$(Get-Date) Done.";
                            Exit 1;
                        }
                    } else {
                        Write-Host "$(Get-Date) Unpacked media at $unpackedUNC is not found, and SourceImageUrl is not found. So nothing we can do."
                        Exit 1;
                    }
                    Write-Host "$(Get-Date) Unpacked media at $unpackedUNC is not found, unpacking from $imageUNC.";
                    $mountResult = Mount-DiskImage $imageUNC -PassThru;
                    $driveLetter = ( $mountResult | Get-Volume ).DriveLetter;
                    Get-PSDrive > $null
                    Do {
                        Write-Host "$(Get-Date) Waiting 5 seconds until files are ready on $driveLetter drive";
                        $driveFiles = $null;
                        Start-Sleep 5;
                        $driveFiles = Get-ChildItem "$driveLetter`:\*" -Recurse -ErrorAction SilentlyContinue;
                    } Until ( $driveFiles )
                    Write-Host "$(Get-Date) Creating $unpackedUNC directory"
                    New-Item -ItemType Directory -Path $unpackedUNC | Out-Null;
                    Write-Host "$(Get-Date) Copying files from the mounted image into the file share";
                    Copy-Item -Path "$driveLetter`:\*" -Destination $unpackedUNC -Recurse;
                    Write-Host "$(Get-Date) Dismounting image file";
                    Dismount-DiskImage -ImagePath $imageUNC;
                    Write-Host "$(Get-Date) Removing image file";
                    Remove-Item $imageUNC;
                    Write-Host "$(Get-Date) Done.";
                }
                if ( !( Get-Item $unpackedUNC ) )
                {
                    Exit 1;
                }
                Write-Host "$(Get-Date) Zipped file is not found, now packing $unpackedUNC into $localFilePath.";
                if ( $unpackedUNC[0] -eq "." )
                {
                    $absoluteUnpackedUNC = (Get-Item -Path ".\").FullName + $unpackedUNC;
                } else {
                    $absoluteUnpackedUNC = $unpackedUNC;
                }
                if ( $localFilePath[0] -eq "." )
                {
                    $absolutelocalFilePath = (Get-Item -Path ".\").FullName + $localFilePath;
                } else {
                    $absolutelocalFilePath = $localFilePath;
                }
                [io.compression.zipfile]::CreateFromDirectory( $absoluteUnpackedUNC, $absolutelocalFilePath );
                Write-Host "$(Get-Date) Done.";
                if ( $unpackedTemporary )
                {
                    Write-Host "$(Get-Date) Removing temporary directory $unpackedUNC.";
                    Remove-Item $unpackedUNC -Recurse -Force
                    Write-Host "$(Get-Date) Done.";
                }
            } else {
                Write-Host "$(Get-Date) Local file $localFilePath is not found locally, downloading from $sourceImageUrl.";
                Start-BitsTransfer -Source $sourceImageUrl -Destination $localFilePath;
                Write-Host "$(Get-Date) Done.";
            }
        }
        if ( !( Get-Item $localFilePath ) )
        {
            Exit 1;
        }
    } else {
        Write-Host "$(Get-Date) Skipping $key media because it is missing in configuration document";
    }
}
