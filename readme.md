# Installing prerequisites

## Windows Hyper-V Server 2012 R2
In command line run `` command.
In the PowerShell session run the following lines:
```Bat
powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
exit
choco install -y git
choco install -y packer
choco install -y vagrant
```

Some changes require OS restart so you need to reboot the machine. For example, you can run `shutdown /r`.

Clone the repo locally:
```
git clone https://github.com/shurick81/sp-devops-starter c:\projects\sp-devops-starter
```