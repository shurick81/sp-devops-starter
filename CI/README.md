# Requirements
* Hardware
  * 2GB free RAM
  * 30GB free disk space
* Software
  * Vagrant
  * Packer
  * Oracle VirtualBox or Hyper-V or VM-Ware
* ~ 30 mins to run tests

# Usage
Go to CI directory. For example, `cd c:\projects\sp-devops-starter\ci`
Create a box (virtual machine image):

```
packer build centos7-ci.json
```


Add the box to Vagrant:

```
vagrant box add centos7-ci-virtualbox.box --force --name centos7-ci
```


Spin up a virtual machine from the boxes:

`vagrant up`


Rerunning:
```
del centos7-ci-virtualbox.box && packer build centos7-ci.json
```
```
vagrant destroy --force && vagrant box remove file://centos7-ci-virtualbox.box --force && vagrant up
```
