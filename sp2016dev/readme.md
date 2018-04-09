# Requirements
* Hardware
  * 2GB free RAM
  * 30GB free disk space
* Software
  * Vagrant
  * Packer
  * Oracle VirtualBox or Hyper-V
* ~ 3 hours to run tests

# Usage
Create a box (virtual machine image):

`packer build sp-win2016-db-web-code.json`


Add the box to Vagrant:

```
vagrant box add sp-win2016-web-code-virtualbox.box --force --name sp-win2016-web-code
vagrant box add sp-win2016-web-code-hyperv.box --force --name sp-win2016-web-code
vagrant box add sp-win2016-db-web-code-virtualbox.box --force --name sp-win2016-db-web-code
vagrant box add sp-win2016-db-web-code-hyperv.box --force --name sp-win2016-db-web-code
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
vagrant box remove sp-win2016-web-code
rm sp-win2016-web-code-virtualbox.box
rm sp-win2016-web-code-hyperv.box
vagrant box remove sp-win2016-db-web-code
rm sp-win2016-db-web-code-virtualbox.box
rm sp-win2016-db-web-code-hyperv.box
```

Consider also removing downloaded ISO files:

`rm packer_cache/*`
