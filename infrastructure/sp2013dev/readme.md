# Requirements
* Hardware
  * 2GB free RAM
  * 100GB free disk space
* Software
  * Vagrant
  * Packer
  * Oracle VirtualBox or Hyper-V or VMWare
  * /infrastructure/sp2013dev/SPServer2013SP1 directory with SP installation media with classic structure:
    * 2013
      * SharePoint
      * LanguagePacks
Use AutoSPSourceBuilder to generate this one or extract from SP iso to /infrastructure/sp2013dev/SPServer2013SP1/2013/SharePoint

```PowerShell
$directoryName = [guid]::NewGuid().Guid;
New-Item -Path "$env:Temp\$directoryName" -ItemType Directory -Force | Out-Null
Invoke-RestMethod -Uri https://download.visualstudio.microsoft.com/download/pr/11346816/52257ee3e96d6e07313e41ad155b155a/vs_Enterprise.exe -OutFile "$env:Temp\$directoryName\vs_Enterprise.exe"
Start-Process -FilePath "$env:Temp\$directoryName\vs_Enterprise.exe" -ArgumentList '--layout .\VS2017 --add Microsoft.VisualStudio.Workload.Office --includeRecommended --lang en-US --quiet' -Wait;
.\..\..\media.ps1 .\media.json
Remove-Item .\VS2017 -Recurse -Force
```

* On the Hyper-V host, open incoming ports 8000 to 9000.

* ~ 3 hours to run tests

# Usage

## PowerShell
`cd` to `images` directory and run `.\preparevmimages.ps1`
`cd` to `stacks/dev` directory and run `vagrant up`
when 

# Cleaning up
`cd` to `stack` directory and run `vagrant destroy`
`cd` to `images` directory and run `removevmimages.ps1`

Consider also removing downloaded ISO files:

`rm images/packer_cache/*`