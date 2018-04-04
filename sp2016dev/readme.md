# Requirements
* Hardware
  * 2GB free RAM
  * 30GB free disk space
* Software
  * Vagrant
  * Packer
  * Oracle VirtualBox or Hyper-V
* ~ 30 minutes to run tests

# Usage
Create a box (virtual machine image):

`packer build win2016-db-web-code.json`


Add the box to Vagrant:

```
vagrant box add win2016-web-code-virtualbox.box --force --name win2016-web-code
vagrant box add win2016-web-code-hyperv.box --force --name win2016-web-code
vagrant box add win2016-db-web-code-virtualbox.box --force --name win2016-db-web-code
vagrant box add win2016-db-web-code-hyperv.box --force --name win2016-db-web-code
```


Spin up a multi virtual machine from the boxes:

`vagrant up`

# Verification
Verify the virtual machine is up and running:

`vagrant powershell`

then
```
whoami
ipconfig
exit
```

# Cleaning up
Remove the virtuatl machine:

`vagrant destroy`


Remove the box and temp files:

```
vagrant box remove win2016-base
rm win2016-base-virtualbox.box
rm win2016-base-hyperv.box
```

Consider also removing downloaded ISO files:

`rm packer_cache/*`


# Rebuilding
```
vagrant destroy --force
vagrant box remove win2016-base
rm win2016-base-virtualbox.box
rm win2016-base-hyperv.box
packer build win2016-base.json
vagrant box add win2016-base-virtualbox.box --force --name win2016-base
vagrant box add win2016-base-hyperv.box --force --name win2016-base
vagrant up
```
