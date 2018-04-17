$imageNames = @(
    "sp-win2012r2-db-web-code"
)
$imageNames | % {
    $imageName = $_;
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
    } else {
        Write-Host "$(Get-Date) Image is already registered in vagrant";
    }
}