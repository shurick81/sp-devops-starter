# Requirements
* Hardware
  * 2GB free RAM
  * 100GB free disk space
* Software
  * Vagrant
  * Packer
  * Oracle VirtualBox or Hyper-V or VMWare
  * `\\192.168.0.159\Volume_1\Install\SP2013wSP1\2013` containing SP installation media.
  * `\\192.168.0.159\Volume_1\Install\SQLServer2014SP1` containing SQL installation media. Can be downloaded from http://care.dlservice.microsoft.com/dl/download/2/F/8/2F8F7165-BB21-4D1E-B5D8-3BD3CE73C77D/SQLServer2014SP1-FullSlipstream-x64-ENU.iso and extracted to the given directory.
  * `\\192.168.0.159\Volume_1\Install\VS2017` containing VS media. Can be done via following commands:
```PowerShell
New-Item -Path C:\Temp\MB -ItemType Directory -Force | Out-Null
Invoke-RestMethod -Uri https://download.visualstudio.microsoft.com/download/pr/11346816/52257ee3e96d6e07313e41ad155b155a/vs_Enterprise.exe -OutFile C:\Temp\MB\vs_Enterprise.exe
Start-Process -FilePath C:\Temp\MB\vs_Enterprise.exe -ArgumentList '--layout \\192.168.0.159\Volume_1\Install\VS2017 --add Microsoft.VisualStudio.Workload.Office --includeRecommended --lang en-US --quiet' -Wait;
```
* ~ 3 hours to run tests

# Usage

## PowerShell
`cd` to `images` directory and run `preparevmimages.ps1`
`cd` to `stack` directory and run `vagrant up`
when 

# Cleaning up
`cd` to `stack` directory and run `vagrant destroy`
`cd` to `images` directory and run `removevmimages.ps1`

Consider also removing downloaded ISO files:

`rm images/packer_cache/*`
