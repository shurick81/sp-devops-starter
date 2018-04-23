For usage, read README.md in /sp2013dev, /sp2016dev and /ci

# Preparing a dev environment of the CI/Infrastructure project

## Windows 10/2016
Run in PowerShell:
```PowerShell
Set-ExecutionPolicy Bypass -Force;
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install -y packer --version 1.2.2
choco install -y vagrant
choco install -y git
choco install -y visualstudiocode
$AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
Stop-Process -Name Explorer
```