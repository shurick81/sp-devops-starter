For usage, read README.md in infrastructure/sp2013dev, infrastructure/sp2016dev and /ci


# Preparing a dev environment of the CI/Infrastructure project

## Windows 10/2016
Run in PowerShell:
```PowerShell
Set-ExecutionPolicy Bypass -Force;
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install -y packer
choco install -y vagrant
choco install -y git
choco install -y visualstudiocode
```

### Removing IE Enhanced Security
```PowerShell
$adminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
Set-ItemProperty -Path $adminKey -Name "IsInstalled" -Value 0
Stop-Process -Name Explorer
```

### Installing Hyper-V
```PowerShell
Enable-WindowsOptionalFeature -Online -FeatureName:Microsoft-Hyper-V -All
New-NetFirewallRule -DisplayName 'Packer HTTP ports' -Profile @('Domain', 'Private') -Direction Inbound -Action Allow -Protocol TCP -LocalPort 8000-9000 | Out-Null
```