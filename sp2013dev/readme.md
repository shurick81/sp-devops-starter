# Requirements
* Hardware
  * 2GB free RAM
  * 100GB free disk space
* Software
  * Vagrant
  * Packer
  * Oracle VirtualBox or Hyper-V or VMWare
  * `\\192.168.0.159\Volume_1\Install\SP2013wSP1\2013` containing SP installation media.
* ~ 3 hours to run tests

# Usage

## PowerShell
`cd` to `images` directory and run `preparevmimages.ps1`
`cd` to `stack` directory and run `vagrant up`
when 

# Cleaning up
`cd` to `stack` directory and run `vagrant destroy`
`cd` to `images` directory and run `removevmimages.ps1`

Consider also removing downloaded ISO files:

`rm images/packer_cache/*`
