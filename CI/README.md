# CI Master

## Requirements
* Hardware
  * 2GB free RAM
  * 200GB free disk space
* Software
  * Packer
  * Vagrant
  * Hypervisor ( Local, like VirtualBox, HyperV, VMWare or clound, like Azure )
* ~ 2 hours to run tests

### Windows Server 2016 / Windows 10
in admin PowerShell run:
``` PowerShell
Set-ExecutionPolicy Bypass -Force;
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install -y packer
choco install -y vagrant --version 2.2.0
choco install -y git
```

For VirtualBox, run `choco install -y virtualbox --version 5.2.22`
For Hyper-V, run:
```
Enable-WindowsOptionalFeature -Online -FeatureName:Microsoft-Hyper-V -All
New-NetFirewallRule -DisplayName 'Packer HTTP ports' -Profile @('Domain', 'Private') -Direction Inbound -Action Allow -Protocol TCP -LocalPort 8000-9000 | Out-Null
```
For uninstalling VirtualBox, run `choco uninstall -y virtualbox`
For uninstalling Hyper-V, run:
```
Get-NetFirewallRule | ? { $_.DisplayName -eq 'Packer HTTP ports' } | Disable-NetFirewallRule
Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All
```

Reboot the machine: `shutdown /r`

### Hyper-V Server 2012 R2
in command line run:
```
powershell
Set-ExecutionPolicy Bypass -Force;
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install -y packer
choco install -y vagrant --version 2.2.0
choco install -y git
New-NetFirewallRule -DisplayName 'HTTP(S) Inbound' -Profile @('Domain', 'Private') -Direction Inbound -Action Allow -Protocol TCP -LocalPort @('80', '443', '16080') | Out-Null
New-NetFirewallRule -DisplayName 'Packer HTTP ports' -Profile @('Domain', 'Private') -Direction Inbound -Action Allow -Protocol TCP -LocalPort 8000-9000 | Out-Null
exit
```

Reboot the machine: `shutdown /r`

Configure external switch.

### Azure RM

1. `vagrant plugin install vagrant-azure`
2. Make sure you have storage account for saving images
3. Create application and assign proper roles for managing Azure resources
4. Set values for following variables:
* ARM_CLIENT_ID
* ARM_CLIENT_SECRET
* ARM_SUBSCRIPTION_ID
* ARM_TENANT_ID

Use this instruction as a baseline: https://www.packer.io/docs/builders/azure-setup.html

in admin PowerShell run:
``` PowerShell
Set-ExecutionPolicy Bypass -Force;
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install -y packer
choco install -y vagrant -vagrant 2.2.0
choco install -y git
```
if Vagrant requires reboot, do it before proceeding further.

## Usage
Clone the project. For example, `git clone https://github.com/shurick81/sp-devops-starter c:\projects\sp-devops-starter`
Consider changing branch to the one you need at the moment.

### Image

Create a box (virtual machine image) locally:

```
cd c:\projects\sp-devops-starter\ci\images
./../../infrastructure/images/preparevmimages.ps1 centos7-ci
```

or in the cloud:
```
cd c:\projects\sp-devops-starter\ci\images
packer build -only azure-arm centos7-ci.json
```

### VM

Spin up a virtual machine from the boxes locally:

```
cd c:\projects\sp-devops-starter\ci
vagrant up --provider virtualbox
```

Or in Azure
```
cd c:\projects\sp-devops-starter\ci
vagrant box add azure https://github.com/azure/vagrant-azure/raw/v2.0/dummy.box --provider azure
vagrant up --provider azure
```

### Rerunning

Locally:
```
cd c:\projects\sp-devops-starter\ci\images
./../../infrastructure/images/prepare removevmimages.ps1 centos7-ci
./../../infrastructure/images/prepare preparevmimages.ps1 centos7-ci
cd c:\projects\sp-devops-starter\ci
vagrant destroy --force
vagrant up --provider virtualbox
```

In Azure:
Remove image, then
```
cd c:\projects\sp-devops-starter\ci\images
packer build -only azure-arm centos7-ci.json
```
```
cd c:\projects\sp-devops-starter\ci
vagrant destroy --force
vagrant box add azure https://github.com/azure/vagrant-azure/raw/v2.0/dummy.box --provider azure
vagrant up --provider azure
```


Updating pipelines in VirtualBox:
`vagrant up --provision --provider virtualbox`

# Configuring parameters on the agent

Jenkins in Azure
```PowerShell
$env:SPDEVOPSSTARTER_JENKINSHOST = "spdvpsstrtrci.westus2.cloudapp.azure.com"
```
Jenkins locally
```PowerShell
$env:SPDEVOPSSTARTER_JENKINSHOST = "127.0.0.1"
```

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
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"; Invoke-RestMethod -Uri https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.9/swarm-client-3.9.jar -OutFile swarm-client-3.9.jar
java -jar swarm-client-3.9.jar -name $env:computername -disableSslVerification -master "http://$env:SPDEVOPSSTARTER_JENKINSHOST`:16080" -username admin -password admin -labels "sharepoint client" -executors 2
```

## Connecting sharepoint server slave
```
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"; Invoke-RestMethod -Uri https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.9/swarm-client-3.9.jar -OutFile swarm-client-3.9.jar
java -jar swarm-client-3.9.jar -name $env:computername -disableSslVerification -master "http://$env:SPDEVOPSSTARTER_JENKINSHOST`:16080" -username admin -password admin -labels "sharepoint server" -executors 2
```

## Connecting nosp stack
```
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"; Invoke-RestMethod -Uri https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.9/swarm-client-3.9.jar -OutFile swarm-client-3.9.jar
java -jar swarm-client-3.9.jar -name $env:computername -disableSslVerification -master "http://$env:SPDEVOPSSTARTER_JENKINSHOST`:16080" -username admin -password admin -labels "nosharepoint" -executors 2
```


# CI HyperVisor agent

## Prerequisites
* Software
  * Packer
  * Vagrant
  * Reload add-in: `vagrant plugin install vagrant-reload`
  * Hypervisor
  * /infrastructure/SPServer2013SP1 directory with SP installation media with classic structure:
    * 2013
      * SharePoint
      * LanguagePacks
  Use AutoSPSourceBuilder to generate this one or extract from SP iso to C:/sp-onprem-files/SPServer2013SP1/2013/SharePoint

* ~ 2 hours to run tests

### Windows
1. Run in PowerShell with admin privileges:
```PowerShell
Set-ExecutionPolicy Bypass -Force;
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install -y jre8;
choco install -y git;
git clone https://github.com/shurick81/sp-devops-starter c:\projects\sp-devops-starter
New-Item -Path C:\sp-onprem-files -ItemType Directory -Force;
$directoryName = [guid]::NewGuid().Guid;
New-Item -Path "$env:Temp\$directoryName" -ItemType Directory -Force | Out-Null
Invoke-RestMethod -Uri https://download.visualstudio.microsoft.com/download/pr/12221250/52257ee3e96d6e07313e41ad155b155a/vs_Enterprise.exe -OutFile "$env:Temp\$directoryName\vs_Enterprise.exe"
# https://download.visualstudio.microsoft.com/download/pr/11346816/52257ee3e96d6e07313e41ad155b155a/vs_Enterprise.exe was the old URL
Start-Process -FilePath "$env:Temp\$directoryName\vs_Enterprise.exe" -ArgumentList '--layout C:\sp-onprem-files\VS2017 --add Microsoft.VisualStudio.Workload.Office --includeRecommended --lang en-US --quiet' -Wait;
cd c:\projects\sp-devops-starter\CI
.\..\infrastructure\media.ps1 .\mediasp2013.json
Remove-Item C:\sp-onprem-files\VS2017 -Recurse -Force
```
2. Close the PowerShell console.

### Cloud dev machine

```PowerShell
choco install -y jre8;
```
close the window.

## Connecting hypervisor manager slave
It might be wise to run the following snippet in a separate console in order to continue controlling vagrant.
### Windows

#### VirtualBox or Hyper-V
Run in a new PowerShell:
```PowerShell
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"; Invoke-RestMethod -Uri https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.9/swarm-client-3.9.jar -OutFile swarm-client-3.9.jar
java -jar swarm-client-3.9.jar -name $env:computername -disableSslVerification -master "http://$env:SPDEVOPSSTARTER_JENKINSHOST`:16080" -username admin -password admin -labels "hvmanager win" -executors 2
```

## Connecting hypervisor manager slave with rebuilding SharePoint machine
It might be wise to run the following snippet in a separate console in order to continue controlling vagrant.
### Windows
#### VirtualBox or Hyper-V
Run in a new PowerShell:
```PowerShell
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"; Invoke-RestMethod -Uri https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.9/swarm-client-3.9.jar -OutFile swarm-client-3.9.jar
java -jar swarm-client-3.9.jar -name $env:computername -disableSslVerification -master "http://$env:SPDEVOPSSTARTER_JENKINSHOST`:16080" -username admin -password admin -labels "hvmanager-cleanvms win" -executors 2
```

# Connecting hypervisor manager slave for infrastructure testing
It might be wise to run the following snippet in a separate console in order to continue controlling vagrant.
## Windows
### VirtualBox or Hyper-V
Run in PowerShell:
```PowerShell
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"; Invoke-RestMethod -Uri https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.9/swarm-client-3.9.jar -OutFile swarm-client-3.9.jar
java -jar swarm-client-3.9.jar -name $env:computername -disableSslVerification -master "http://$env:SPDEVOPSSTARTER_JENKINSHOST`:16080" -username admin -password admin -labels "infrastructuretester win"
```

# Cloning to other projecs
Copy the whole CI directory to your project
