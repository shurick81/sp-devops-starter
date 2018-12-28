# No-brainer SP 2019 sandbox installation with VirtualBox or Hyper-V

Tested on Windows but you can use it across any platform that is supported by Vagrant.

## Prerequisites

First of all, you will need Git, Packer and Vagrant installed. Here is example how you can install them in Windows PowerShell.

```PowerShell
Set-ExecutionPolicy Bypass -Force;
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install -y git
choco install -y packer
choco install -y vagrant -vagrant 2.2.0
```

If one of installed components was Vagrant, you now need to reboot your machine.

Beside these main components, you also want to install 
Vagrant Reload Provisioner plugin. Run following command to do that:

```
vagrant plugin install vagrant-reload
```

Also make sure you have at least 100GB of free space on the disk drive.

## Usage

1. Clone the project locally.

For example, in Windows:

```
git clone https://github.com/shurick81/sp-devops-starter c:\projects\sp-devops-starter
```

2. Open `/infrastructure/images` directory in console.

For example, in Windows:

```
cd c:\projects\sp-devops-starter\infrastructure\images
```

3. Run the following command:

```
.\preparevmimages.ps1 sp-win2016-ad-db-sp2019-code
```

This operation may take about 3 hours and will require about 70GB of free disk space. Make sure that the end of output contains `box: Successfully added box 'sp-win2016-ad-db-sp2019-code'`. If the end of the transcript does not contain this, perhaps it failed and you want to run it once again or figure out the reason of a failure.

4. Open `/infrastructure/stacks/dev-adsql2016sp2019code-spfarm` directory in console.
For example, in Windows:

```
cd c:\projects\sp-devops-starter\infrastructure\stacks\dev-adsql2016sp2019code-spfarm
```

5. Run

```
vagrant up
```

It may take about one hour to finish this provisioning. In case of success the end of the output should look as following:

```
    ADDBWEB01: VERBOSE: [adDBWEB01]:                            [[SPSite]DefaultPathSite] Leaving EndProcessing
Method of
    ADDBWEB01: Get-SPSite.
    ADDBWEB01: VERBOSE: [adDBWEB01]: LCM:  [ End    Test     ]  [[SPSite]DefaultPathSite] True in 1.2180 seconds
.
    ADDBWEB01: VERBOSE: [adDBWEB01]: LCM:  [ End    Resource ]  [[SPSite]DefaultPathSite]
    ADDBWEB01: VERBOSE: [adDBWEB01]: LCM:  [ End    Compare  ]     Completed processing compare operation. The o
peration returned
    ADDBWEB01: True.
    ADDBWEB01: VERBOSE: [adDBWEB01]: LCM:  [ End    Compare  ]    in  5.0310 seconds.
    ADDBWEB01: VERBOSE: Operation 'Invoke CimMethod' complete.
    ADDBWEB01: VERBOSE: Time taken for configuration job to complete is 5.104 seconds
```

In case of failure, you may want to try again:

```
vagrant destroy --force
vagrant up
```

6. Connect to your new machine via running `vagrant rdp` and providing the following credential:

| User name | Password |
| --------- | ---------- |
| contoso\\_spadm16 | c0mp1Expa~~ |
