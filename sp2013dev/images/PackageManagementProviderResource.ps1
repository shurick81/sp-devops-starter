Write-Host "$( Get-Date ) Install-PackageProvider -Name NuGet"
Install-PackageProvider -Name NuGet -Force -RequiredVersion 2.8.5.201;
Write-Host "$( Get-Date ) Install-Module -Name PackageManagementProviderResource"
Install-Module -Name PackageManagementProviderResource -Force -RequiredVersion 1.0.3;