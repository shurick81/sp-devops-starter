# Requirements
* Hardware
  * 12GB free RAM
  * 100GB free disk space
* Software
  * Vagrant
  * Vagrant reload
  * Packer
  * Oracle VirtualBox or Hyper-V or VMWare
  * /infrastructure/sp2013dev/SPServer2013SP1 directory with SP installation media with classic structure:
    * 2013
      * SharePoint
      * LanguagePacks
Use AutoSPSourceBuilder to generate this one or extract from SP iso to /infrastructure/sp2013dev/SPServer2013SP1/2013/SharePoint

Run in PowerShell:
```PowerShell
Set-ExecutionPolicy Bypass -Force;
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install -y packer
choco install -y vagrant
```
Then reboot for finishing insalling Vagrant and continue with the following snippet:
```PowerShell
vagrant plugin install vagrant-reload
```

Then `cd` to the `/sp2013dev` directory and run:
```PowerShell
$directoryName = [guid]::NewGuid().Guid;
New-Item -Path "$env:Temp\$directoryName" -ItemType Directory -Force | Out-Null
Invoke-RestMethod -Uri https://download.visualstudio.microsoft.com/download/pr/11346816/52257ee3e96d6e07313e41ad155b155a/vs_Enterprise.exe -OutFile "$env:Temp\$directoryName\vs_Enterprise.exe"
Start-Process -FilePath "$env:Temp\$directoryName\vs_Enterprise.exe" -ArgumentList '--layout .\VS2017 --add Microsoft.VisualStudio.Workload.Office --includeRecommended --lang en-US --quiet' -Wait;
.\..\..\media.ps1 .\media.json
Remove-Item .\VS2017 -Recurse -Force
```

### Removing IE Enhanced Security
```PowerShell
$adminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
Set-ItemProperty -Path $adminKey -Name "IsInstalled" -Value 0
Stop-Process -Name Explorer
```

### Installing VirtualBox on Windows
```
choco install -y virtualbox
```

### Installing Hyper-V on Windows Server or Windows Pro
```PowerShell
Enable-WindowsOptionalFeature -Online -FeatureName:Microsoft-Hyper-V -All
New-NetFirewallRule -DisplayName 'Packer HTTP ports' -Profile @('Domain', 'Private') -Direction Inbound -Action Allow -Protocol TCP -LocalPort 8000-9000 | Out-Null
```
You will need to reboot the machine for changes to apply
Using Hyper-V Manager, configure network switch with external access.

* ~ 3 hours to run tests

# Creating a development environment

## PowerShell
`cd` to `images` directory and run `.\preparevmimages.ps1 sp-win2012r2-ad,sp-win2012r2-db-web-code`
`cd` to `stacks/dev` directory and run `vagrant up`
when 

# Cleaning up
`cd` to `stack` directory and run `vagrant destroy`
`cd` to `images` directory and run `removevmimages.ps1 sp-win2012r2-ad,sp-win2012r2-db-web-code`

Consider also removing downloaded ISO files:

`rm images/packer_cache/*`