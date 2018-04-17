Get-Location;
New-Item -Path C:\Temp -ItemType Directory -Force | Out-Null
(New-Object System.Net.WebClient).DownloadFile('https://go.microsoft.com/fwlink/?linkid=839516', 'C:\Temp\Win8.1AndW2K12R2-KB3191564-x64.msu')
Write-Host "$( Get-Date ) Starting C:\Temp\Win8.1AndW2K12R2-KB3191564-x64.msu"
Start-Process wusa.exe -ArgumentList '"C:\Temp\Win8.1AndW2K12R2-KB3191564-x64.msu" /quiet' -Wait
