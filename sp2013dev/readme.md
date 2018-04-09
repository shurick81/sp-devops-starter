# Requirements
* Hardware
  * 2GB free RAM
  * 30GB free disk space
* Software
  * Vagrant
  * Packer
  * Oracle VirtualBox or Hyper-V
  * `en_sharepoint_server_2013_with_sp1_x64_dvd_3823428.iso` file in "sp2013dev" directory from MSDN
* ~ 3 hours to run tests

# Usage
Create a box (virtual machine image):

`packer build sp-win2012r2-db-web-code.json`


Add the box to Vagrant:

```
vagrant box add sp-win2012r2-web-code-virtualbox.box --force --name sp-win2012r2-web-code
vagrant box add sp-win2012r2-web-code-hyperv.box --force --name sp-win2012r2-web-code
vagrant box add sp-win2012r2-db-web-code-virtualbox.box --force --name sp-win2012r2-db-web-code
vagrant box add sp-win2012r2-db-web-code-hyperv.box --force --name sp-win2012r2-db-web-code
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
Remove the virtual machine:

`vagrant destroy`


Remove the box and temp files:

```
vagrant box remove sp-win2012r2-web-code
rm sp-win2012r2-web-code-virtualbox.box
rm sp-win2012r2-web-code-hyperv.box
vagrant box remove sp-win2012r2-db-web-code
rm sp-win2012r2-db-web-code-virtualbox.box
rm sp-win2012r2-db-web-code-hyperv.box
```

Consider also removing downloaded ISO files:

`rm packer_cache/*`
