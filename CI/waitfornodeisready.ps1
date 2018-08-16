$filePath = "c:\sp-devops-starter.busy.txt"
while ( Get-Item $filePath -ErrorAction Ignore ) {
    Write-Host "$(Get-Date) File $filePath is found so we wait until it disappears."
    Sleep 300;
}
Write-Host "$(Get-Date) File $filePath is not found."
