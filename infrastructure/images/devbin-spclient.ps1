Write-Host "$(Get-Date) Starting msiexec"
$MSIArguments = @(
    "/i"
    ('"{0}"' -f "C:\Install\SQLClientSDK\sharepointclientcomponents_16-4351-1000_x64_en-us.msi")
    "/qn"
    "/norestart"
)
Start-Process "msiexec.exe" -ArgumentList $MSIArguments -Wait -NoNewWindow
Sleep 10;
Write-Host "$(Get-Date) Installed products:"
get-wmiobject Win32_Product | Format-Table IdentifyingNumber, Name, LocalPackage -AutoSize
