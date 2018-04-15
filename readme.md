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

