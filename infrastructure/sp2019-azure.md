# No-brainer SP 2019 sandbox installation in Azure

Tested on Windows but you can use it across any platform that is supported by Vagrant.

## Prerequisites

### Common prerequisites
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

### Azure prerequisites

The only virtualization provider currenlty supported by this project is Azure, so before using this tool, please install necessary components and set variables.

#### Vagrant Azure Provider

In order to install this plugin with the necessary fixes, run

```
vagrant plugin install vagrant-azure
Rename-Item -Path $env:USERPROFILE\.vagrant.d\gems\2.4.4\gems\vagrant-azure-2.0.0 -NewName "vagrant-azure-2.0.0 - Copy";
git clone https://github.com/shurick81/vagrant-azure $env:USERPROFILE\.vagrant.d\gems\2.4.4\gems\vagrant-azure-2.0.0;
```

#### Environmental variables

1. Create application and assign proper roles for managing Azure resources
2. Set values for following environment variables:
* ARM_CLIENT_ID
* ARM_CLIENT_SECRET
* ARM_SUBSCRIPTION_ID
* ARM_TENANT_ID

Use https://www.packer.io/docs/builders/azure-setup.html or https://github.com/Azure/vagrant-azure as a baseline.

#### Image Storage Account
Make sure that your in your subscription there is a resource group for images called "CommonRG", or change the name in `/infrastructure/images/sp-win2016-ad-db-sp2019-code.json` and `/infrastructure/stacks/dev-adsql2016sp2019code-spfarm/Vagrantfile` files.

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
packer build sp-win2016-ad-db-sp2019-code.json
```

This operation may take about 2 hours. Make sure that the end of output contains `==> azure-arm: Capturing image ...`. For example, it may look like this:

```
==> azure-arm: Capturing image ...
==> azure-arm:  -> Compute ResourceGroupName : 'packer-Resource-Group-z2r45yt9gl'
==> azure-arm:  -> Compute Name              : 'pkrvmz2r45yt9gl'
==> azure-arm:  -> Compute Location          : 'WestUS2'
==> azure-arm:  -> Image ResourceGroupName   : 'CommonRG'
==> azure-arm:  -> Image Name                : 'sp-win2016-ad-db-sp2019-code'
==> azure-arm:  -> Image Location            : 'southcentralus'
==> azure-arm: Deleting resource group ...
==> azure-arm:  -> ResourceGroupName : 'packer-Resource-Group-z2r45yt9gl'
==> azure-arm:
==> azure-arm: The resource group was created by Packer, deleting ...
==> azure-arm: Deleting the temporary OS disk ...
==> azure-arm:  -> OS Disk : skipping, managed disk was used...
==> azure-arm: Deleting the temporary Additional disk ...
==> azure-arm:  -> Additional Disk : skipping, managed disk was used...
==> azure-arm: Running post-processor: vagrant
Build 'azure-arm' errored: 1 error(s) occurred:

* Post-processor failed: Unknown artifact type, can't build box: Azure.ResourceManagement.VMImage

==> Some builds didn't complete successfully and had errors:
--> virtualbox-iso: Failed creating VirtualBox driver: exec: "VBoxManage": executable file not found in %PATH%
--> hyperv-iso: Failed creating Hyper-V driver: PS Hyper-V module is not loaded. Make sure Hyper-V feature is on.
--> azure-arm: 1 error(s) occurred:

* Post-processor failed: Unknown artifact type, can't build box: Azure.ResourceManagement.VMImage

==> Builds finished but no artifacts were created.
```
If the end of the transcript does not contain `==> azure-arm: Capturing image ...`, perhaps it failed and you want to run it once again or figure out the reason of a failure.

4. Open `/infrastructure/stacks/dev-adsql2016sp2019code-spfarm-customizations` directory in console.
For example, in Windows:

```
cd c:\projects\sp-devops-starter\infrastructure\stacks\dev-adsql2016sp2019code-spfarm-customizations
```

5. Run following commands

```
vagrant box add azure https://github.com/azure/vagrant-azure/raw/v2.0/dummy.box --provider azure
vagrant up --provider azure
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
vagrant up --provider azure
```

6. Connect to your new machine via running `vagrant rdp` and providing the following credential:

| User name | Password |
| --------- | ---------- |
| contoso\\_spadm16 | c0mp1Expa~~ |
