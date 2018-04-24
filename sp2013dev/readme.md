# Requirements
* Hardware
  * 2GB free RAM
  * 100GB free disk space
* Software
  * Vagrant
  * Packer
  * Oracle VirtualBox or Hyper-V or VMWare
  * `images/sp2013wSP1.zip`, containing SP installation media.
  * `images/sqlserver2014sp1.zip`, containing SQL media.
  * `images/vs2017.zip`, containing VS media.


```PowerShell
New-Item -Path C:\Temp\MB -ItemType Directory -Force | Out-Null
Invoke-RestMethod -Uri https://download.visualstudio.microsoft.com/download/pr/11346816/52257ee3e96d6e07313e41ad155b155a/vs_Enterprise.exe -OutFile C:\Temp\MB\vs_Enterprise.exe
Start-Process -FilePath C:\Temp\MB\vs_Enterprise.exe -ArgumentList '--layout \\192.168.0.159\Volume_1\Install\VS2017 --add Microsoft.VisualStudio.Workload.Office --includeRecommended --lang en-US --quiet' -Wait;
.\..\media.ps1 .\media.json
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
