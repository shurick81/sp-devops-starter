New-Item -Path C:\Temp -ItemType Directory -Force | Out-Null
Write-Host "$( Get-Date ) Downloading http://download.windowsupdate.com/c/msdownload/update/software/secu/2018/04/windows8.1-kb4103715-x64_43bebfcb5be43876fb6a13a4eb840174ecb1790c.msu"
(New-Object System.Net.WebClient).DownloadFile('http://download.windowsupdate.com/c/msdownload/update/software/secu/2018/04/windows8.1-kb4103715-x64_43bebfcb5be43876fb6a13a4eb840174ecb1790c.msu', 'C:\Temp\windows8.1-kb4103715-x64_43bebfcb5be43876fb6a13a4eb840174ecb1790c.msu.msu')
Write-Host "$( Get-Date ) Starting C:\Temp\windows8.1-kb4103715-x64_43bebfcb5be43876fb6a13a4eb840174ecb1790c.msu"
Start-Process wusa.exe -ArgumentList '"C:\Temp\windows8.1-kb4103715-x64_43bebfcb5be43876fb6a13a4eb840174ecb1790c.msu" /quiet'
