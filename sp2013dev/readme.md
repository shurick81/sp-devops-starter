# Requirements
* Hardware
  * 2GB free RAM
  * 30GB free disk space
* Software
  * Vagrant
  * Packer
  * Oracle VirtualBox or Hyper-V or VMWare
  * `\\STORAGE2\Volume_1\Install\SP2013wSP1Sw\2013` containing SP installation media.
* ~ 3 hours to run tests

# Usage

## PowerShell
`cd` to `images` directory and run `preparevmimages.ps1`



Create a box (virtual machine image):

`packer build sp-win2012r2-db-web-code.json`


Add the box to Vagrant:

```
vagrant box add sp-win2012r2-web-code.box --force --name sp-win2012r2-web-code
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
