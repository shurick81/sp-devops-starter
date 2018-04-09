# Requirements
* Hardware
  * 2GB free RAM
  * 30GB free disk space
* Software
  * Vagrant
  * Packer
  * Oracle VirtualBox or Hyper-V
* ~ 30 mins to run tests

# Usage
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
vagrant destroy --force && vagrant up
```
