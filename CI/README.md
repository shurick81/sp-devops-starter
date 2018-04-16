# Requirements
* Hardware
  * 2GB free RAM
  * 30GB free disk space
* Software
  * Vagrant
  * Packer
  * Oracle VirtualBox or Hyper-V or VM-Ware
  * Java
* ~ 2 hours to run tests

## Windows
1. Save `http://care.dlservice.microsoft.com/dl/download/6/2/A/62A76ABB-9990-4EFC-A4FE-C7D698DAEB96/9600.17050.WINBLUE_REFRESH.140317-1640_X64FRE_SERVER_EVAL_EN-US-IR3_SSS_X64FREE_EN-US_DV9.ISO` to `C:\sp-onprem-files\d408977ecf91d58e3ae7c4d0f515d950c4b22b8eadebd436d57f915a0f791224.iso`
2. `choco install -y jre8`

# Usage
Go to CI directory. For example, `cd c:\projects\sp-devops-starter\ci`

## Image
Create a box (virtual machine image):

```
packer build centos7-ci.json
```

## VM

Spin up a virtual machine from the boxes:

`vagrant up`

## Connecting slave
It might be wise to run the following snippet in a separate console in order to continue controlling vagrant.
### Windows
#### VirtualBox
Run in cmd:
```
powershell
Invoke-RestMethod -Uri https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.5/swarm-client-3.5.jar -OutFile swarm-client-3.5.jar
exit
java -jar swarm-client-3.5.jar -name %ComputerName% -disableSslVerification -master http://localhost:8080 -username admin -password admin -labels "win vbox"
```
#### Hyper-V
Run in cmd:
```
powershell
Invoke-RestMethod -Uri https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.5/swarm-client-3.5.jar -OutFile swarm-client-3.5.jar
exit
java -jar swarm-client-3.5.jar -name %ComputerName%-disableSslVerification -master http://localhost:8080 -username admin -password admin -labels "win hyperv"
```

## Rerunning
```
del centos7-ci-virtualbox.box && packer build centos7-ci.json
```
```
vagrant destroy --force && vagrant box remove file://centos7-ci-virtualbox.box --force && vagrant up
```
