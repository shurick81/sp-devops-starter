# SP 2013 Requirements
* Hardware
  * 12GB free RAM
  * 100GB free disk space
* Software
  * Vagrant
  * Vagrant reload
  * Packer
  * Oracle VirtualBox or Hyper-V or VMWare
  * /infrastructure/SPServer2013SP1 directory with SP installation media with classic structure:
    * 2013
      * SharePoint
      * LanguagePacks
Use AutoSPSourceBuilder to generate this one or extract from SP iso to /infrastructure/SPServer2013SP1/2013/SharePoint

Run in PowerShell:
```PowerShell
Set-ExecutionPolicy Bypass -Force;
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install -y packer
choco install -y vagrant
```
Then reboot for finishing insalling Vagrant and continue with `vagrant plugin install vagrant-reload`
```

Then `cd` to the `/infrastructure` directory and run:
```PowerShell
$directoryName = [guid]::NewGuid().Guid;
New-Item -Path "$env:Temp\$directoryName" -ItemType Directory -Force | Out-Null
Invoke-RestMethod -Uri https://download.visualstudio.microsoft.com/download/pr/12221250/52257ee3e96d6e07313e41ad155b155a/vs_Enterprise.exe -OutFile "$env:Temp\$directoryName\vs_Enterprise.exe"
# https://download.visualstudio.microsoft.com/download/pr/11346816/52257ee3e96d6e07313e41ad155b155a/vs_Enterprise.exe was the old URL
Start-Process -FilePath "$env:Temp\$directoryName\vs_Enterprise.exe" -ArgumentList '--layout .\VS2017 --add Microsoft.VisualStudio.Workload.Office --includeRecommended --lang en-US --quiet' -Wait;
.\media.ps1 .\media2013.json
Remove-Item .\VS2017 -Recurse -Force
```

If you want to speed up the installation for the first time, save Windows installation media from http://care.dlservice.microsoft.com/dl/download/6/2/A/62A76ABB-9990-4EFC-A4FE-C7D698DAEB96/9600.17050.WINBLUE_REFRESH.140317-1640_X64FRE_SERVER_EVAL_EN-US-IR3_SSS_X64FREE_EN-US_DV9.ISO to /images/packer_cache/d408977ecf91d58e3ae7c4d0f515d950c4b22b8eadebd436d57f915a0f791224.iso

### Removing IE Enhanced Security
```PowerShell
$adminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
Set-ItemProperty -Path $adminKey -Name "IsInstalled" -Value 0
Stop-Process -Name Explorer
```

### Installing Hyper-V on Windows Server or Windows Pro
```PowerShell
Enable-WindowsOptionalFeature -Online -FeatureName:Microsoft-Hyper-V -All
New-NetFirewallRule -DisplayName 'Packer HTTP ports' -Profile @('Domain', 'Private') -Direction Inbound -Action Allow -Protocol TCP -LocalPort 8000-9000 | Out-Null
```
You will need to reboot the machine for changes to apply
Using Hyper-V Manager, configure network switch with external access.

* ~ 3 hours to run tests

### (alernatively) Installing VirtualBox on Windows
```
choco install -y virtualbox
```

# Creating a development environment

## PowerShell
`cd` to `images` directory and run `.\preparevmimages.ps1 sp-win2012r2-ad,sp-win2012r2-db-web-code`
`cd` to `stacks/dev-2013` directory and run `vagrant up`

### Hyper-V
When running `vagrant up` you will be asked to choose the switch manually.
if you encounter `The box is not able to report an address for WinRM to connect to yet.` exit, run `vagrant up` again.

# Accessing the machine
`vagrant rdp DBWEBCODE01`
account: `contoso\_spadm16`
pass: `c0mp1Expa~~`

# Cleaning up
`cd` to `stack` directory and run `vagrant destroy`
`cd` to `images` directory and run `removevmimages.ps1 sp-win2012r2-ad,sp-win2012r2-db-web-code`

Consider also removing downloaded ISO files:

`rm images/packer_cache/*`