$imageNames = @(
    "sp-win2016-db-web-code"
)
$imageNames | % {
    $imageName = $_;
    Write-Host "$(Get-Date) Checking $imageName image";
    $existingImages = vagrant box list | ? { $_ -like "$imageName *" };
    if ( $existingImages ) {
        Write-Host "$(Get-Date) Image is found in vagrant, removing";
        vagrant box remove $imageName --force
    } else {
        Write-Host "$(Get-Date) Image is not registered in vagrant";
    }
}