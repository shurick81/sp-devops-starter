$securedPassword = ConvertTo-SecureString "Fractalsol" -AsPlainText -Force
$ShortDomainAdminCredential = New-Object System.Management.Automation.PSCredential( "administrator", $securedPassword )
Write-Host "Starting sysprep";
Start-Process -FilePath C:\Windows\System32\Sysprep\Sysprep.exe -ArgumentList '/generalize /oobe /shutdown /quiet /unattend:c:\tmp\autounattend_sysprep.xml' -Credential $ShortDomainAdminCredential;
#Write-Host "Start sysprep manually";