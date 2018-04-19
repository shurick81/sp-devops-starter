$imageNames = @(
    "sp-win2012r2-ad",
    "sp-win2012r2-db-web-code"
)

$startProcessingMoment = Get-Date;
$imageNames | % {
    $imageName = $_;
    $retriesLimit = 3;
    $retriesCounter = 0;
    $jobDone = $false;
    Do {
        $retriesCounter++;
        Write-Host "$(Get-Date) Starting retry $retriesCounter of $retriesLimit";
        Write-Host "$(Get-Date) Checking $imageName image";
        $existingImages = vagrant box list | ? { $_ -like "$imageName *" };
        if ( !$existingImages ) {
            if ( Get-Item "output-*-iso" -ErrorAction Ignore ) {
                Write-Host "$(Get-Date) Found current output directory(s), now removing";
                Get-Item "output-*-iso";
                Remove-Item "output-*-iso" -Recurse;
            }
            if ( Get-Item "$imageName.box" -ErrorAction Ignore ) {
                Write-Host "$(Get-Date) Found current box file, now removing";
                Get-Item "$imageName.box";
                Remove-Item "$imageName.box";
            }
            Write-Host "$(Get-Date) Starting packer";
            packer build "$imageName.json"
            Write-Host "$(Get-Date) Adding image to vagrant";
            vagrant box add "$imageName.box" --name $imageName
            Write-Host "$(Get-Date) Removing temporary box file";
            Remove-Item "$imageName.box";
            $existingImages = vagrant box list | ? { $_ -like "$imageName *" };
            if ( $existingImages ) {
                $jobDone = $true;
            } else {
                Write-Host "$(Get-Date) Sleeping before starting the next step";
                Sleep 300;
            }
        } else {
            Write-Host "$(Get-Date) Image is already registered in vagrant";
        }
    } While ( ( $retriesCounter -lt $retriesLimit ) -and !$jobDone )
}
Write-Host "$(Get-Date) Operation took:";
( Get-Date ) - $startProcessingMoment;

