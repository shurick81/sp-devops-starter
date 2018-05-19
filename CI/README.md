# CI Master

## Requirements
* Hardware
  * 2GB free RAM
  * 200GB free disk space
* Software
  * Packer
  * Vagrant
  * Hypervisor ( VirtualBox, HyperV or VMWare )
* ~ 2 hours to run tests

### Windows Server 2016
in admin PowerShell run:
```
Set-ExecutionPolicy Bypass -Force;
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install -y packer
choco install -y vagrant
choco install -y git
```

For VirtualBox, run `choco install -y virtualbox`
For Hyper-V, run:
```
Enable-WindowsOptionalFeature -Online -FeatureName:Microsoft-Hyper-V -All
New-NetFirewallRule -DisplayName 'Packer HTTP ports' -Profile @('Domain', 'Private') -Direction Inbound -Action Allow -Protocol TCP -LocalPort 8000-9000 | Out-Null
```

Reboot the machine: `shutdown /r`

### Hyper-V Server 2012 R2
in command line run:
```
powershell
Set-ExecutionPolicy Bypass -Force;
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install -y packer
choco install -y vagrant
choco install -y git
New-NetFirewallRule -DisplayName 'HTTP(S) Inbound' -Profile @('Domain', 'Private') -Direction Inbound -Action Allow -Protocol TCP -LocalPort @('80', '443', '8080') | Out-Null
New-NetFirewallRule -DisplayName 'Packer HTTP ports' -Profile @('Domain', 'Private') -Direction Inbound -Action Allow -Protocol TCP -LocalPort 8000-9000 | Out-Null
exit
```

Reboot the machine: `shutdown /r`

Configure external switch.

## Usage
Clone the project. For example, `git clone https://github.com/shurick81/sp-devops-starter c:\projects\sp-devops-starter`
Go to CI directory. For example, `cd c:\projects\sp-devops-starter\ci`

### Image
Create a box (virtual machine image):

```
cd c:\projects\sp-devops-starter\ci\images
packer build centos7-ci.json
```

### VM

Spin up a virtual machine from the boxes:

```
cd c:\projects\sp-devops-starter\ci
vagrant up
```

### Rerunning
```
del centos7-ci.box
packer build centos7-ci.json
```
```
vagrant destroy --force
vagrant box remove file://./images/centos7-ci.box --force
vagrant up
```

Updating pipelines:
`vagrant up --provision`




# CI/CD SharePoint agent

## Prerequisites
```
Set-ExecutionPolicy Bypass -Force;
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install -y git
choco install -y jre8;
```
Close the console.

## Connecting sharepoint client slave
```
Invoke-RestMethod -Uri https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.5/swarm-client-3.5.jar -OutFile swarm-client-3.5.jar
java -jar swarm-client-3.5.jar -name $env:computername -disableSslVerification -master http://127.0.0.1:8080 -username admin -password admin -labels "sharepoint client"
```

## Connecting sharepoint server slave
```
Invoke-RestMethod -Uri https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.5/swarm-client-3.5.jar -OutFile swarm-client-3.5.jar
java -jar swarm-client-3.5.jar -name $env:computername -disableSslVerification -master http://127.0.0.1:8080 -username admin -password admin -labels "sharepoint server"
```



# CI HyperVisor agent

## Prerequisites
* Software
  * Packer
  * Vagrant
  * Reload add-in: `vagrant plugin install vagrant-reload`
  * Hypervisor
  * /infrastructure/sp2013dev/SPServer2013SP1 directory with SP installation media with classic structure:
    * 2013
      * SharePoint
      * LanguagePacks
  Use AutoSPSourceBuilder to generate this one or extract from SP iso to /infrastructure/sp2013dev/SPServer2013SP1/2013/SharePoint

* ~ 2 hours to run tests

### Windows
1. Run in PowerShell:
```PowerShell
New-Item -Path C:\sp-onprem-files -ItemType Directory -Force;
$src = "http://care.dlservice.microsoft.com/dl/download/1/6/F/16FA20E6-4662-482A-920B-1A45CF5AAE3C/14393.0.160715-1616.RS1_RELEASE_SERVER_EVAL_X64FRE_EN-US.ISO";
$dest = "C:\sp-onprem-files\524abd34eb2abcc5e5a12da5b1c97fa3a6a626a831c29b4e74801f4131fb08ed.iso";
Start-BitsTransfer -Source $src -Destination $dest;
$src = "http://care.dlservice.microsoft.com/dl/download/6/2/A/62A76ABB-9990-4EFC-A4FE-C7D698DAEB96/9600.17050.WINBLUE_REFRESH.140317-1640_X64FRE_SERVER_EVAL_EN-US-IR3_SSS_X64FREE_EN-US_DV9.ISO";
$dest = "C:\sp-onprem-files\d408977ecf91d58e3ae7c4d0f515d950c4b22b8eadebd436d57f915a0f791224.iso";
Start-BitsTransfer -Source $src -Destination $dest;
$src = "http://mirrors.kernel.org/centos/7.4.1708/isos/x86_64/CentOS-7-x86_64-DVD-1708.iso";
$dest = "C:\sp-onprem-files\c4bf15f4237756dfa011191c28b7cfb6c897c65b3d56775b528770d5fa0c888f.iso";
Start-BitsTransfer -Source $src -Destination $dest;
$directoryName = [guid]::NewGuid().Guid;
New-Item -Path "$env:Temp\$directoryName" -ItemType Directory -Force | Out-Null
Invoke-RestMethod -Uri https://download.visualstudio.microsoft.com/download/pr/12221250/52257ee3e96d6e07313e41ad155b155a/vs_Enterprise.exe -OutFile "$env:Temp\$directoryName\vs_Enterprise.exe"
# https://download.visualstudio.microsoft.com/download/pr/11346816/52257ee3e96d6e07313e41ad155b155a/vs_Enterprise.exe was the old URL
Start-Process -FilePath "$env:Temp\$directoryName\vs_Enterprise.exe" -ArgumentList '--layout C:\sp-onprem-files\VS2017 --add Microsoft.VisualStudio.Workload.Office --includeRecommended --lang en-US --quiet' -Wait;
.\..\media.ps1 .\mediasp2013.json
Remove-Item C:\sp-onprem-files\VS2017 -Recurse -Force
Set-ExecutionPolicy Bypass -Force;
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install -y jre8;
choco install -y git
```
2. Close the PowerShell console.

## Connecting hypervisor manager slave
It might be wise to run the following snippet in a separate console in order to continue controlling vagrant.
### Windows
#### VirtualBox or Hyper-V
Run in a new PowerShell:
```PowerShell
Invoke-RestMethod -Uri https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.5/swarm-client-3.5.jar -OutFile swarm-client-3.5.jar
java -jar swarm-client-3.5.jar -name $env:computername -disableSslVerification -master http://127.0.0.1:8080 -username admin -password admin -labels "hvmanager win" -executors 2
```

## Connecting hypervisor manager slave with rebuilding SharePoint machine
It might be wise to run the following snippet in a separate console in order to continue controlling vagrant.
### Windows
#### VirtualBox or Hyper-V
Run in a new PowerShell:
```PowerShell
Invoke-RestMethod -Uri https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.5/swarm-client-3.5.jar -OutFile swarm-client-3.5.jar
java -jar swarm-client-3.5.jar -name $env:computername -disableSslVerification -master http://127.0.0.1:8080 -username admin -password admin -labels "hvmanager-cleanvms win" -executors 2
```

# Connecting hypervisor manager slave for infrastructure testing
It might be wise to run the following snippet in a separate console in order to continue controlling vagrant.
## Windows
### VirtualBox or Hyper-V
Run in PowerShell:
```PowerShell
Invoke-RestMethod -Uri https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.5/swarm-client-3.5.jar -OutFile swarm-client-3.5.jar
java -jar swarm-client-3.5.jar -name $env:computername -disableSslVerification -master http://127.0.0.1:8080 -username admin -password admin -labels "infrastructuretester win" -executors 2
```

# Cloning to other projecs
Copy the whole CI directory to your project