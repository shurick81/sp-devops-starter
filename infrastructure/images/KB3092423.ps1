$patchFileUrl = "https://download.microsoft.com/download/F/1/0/F1093AF6-E797-4CA8-A9F6-FC50024B385C/AppFabric-KB3092423-x64-ENU.exe"
$dllVersion = "1.0.4657.2";
$patchFileName = "$env:temp\AppFabric-KB3092423-x64-ENU.exe";
$dllPath = "C:\Program Files\AppFabric 1.1 for Windows Server\PowershellModules\DistributedCacheConfiguration\Microsoft.ApplicationServer.Caching.Configuration.dll";

if ( (Get-ItemProperty $dllPath -Name VersionInfo).VersionInfo.ProductVersion -ne $dllVersion )
{
    Write-Host "AppFabric has not the desired version, upgrading"
    Invoke-RestMethod -Uri $patchFileUrl -OutFile $patchFileName	
    $patchfile = Get-ChildItem $patchFileName;
    if ( $null -eq $patchfile ) { 
        Write-Host "Unable to retrieve the file. Exiting Script"
        Exit 1;
    }
    Start-Process -FilePath $patchFileName -ArgumentList "/passive" -Wait;
    if ( (Get-ItemProperty $dllPath -Name VersionInfo).VersionInfo.ProductVersion -ne $dllVersion )
    {
        Write-Host "Patch installation is not done properly, so exiting";
        Exit 1;
    }
    Write-Host "Patch installation complete";
    Write-Host "Updating AppFabric config";
    $location = "C:\Program Files\AppFabric 1.1 for Windows Server\DistributedCacheService.exe.config";
    $xml = [xml]( get-content $location );
    if ( $null -eq $xml.configuration.appSettings ) {
        $appsettings = $xml.CreateElement( "appSettings" );
        $add = $xml.CreateElement( "add" );
        $key = $xml.CreateAttribute( "key" );
        $key.InnerText = "backgroundGC";
        $add.Attributes.Append( $key ) | out-null;
        $value = $xml.CreateAttribute( "value" );
        $value.InnerText = "true";
        $add.Attributes.Append( $value ) | out-null;
        $appsettings.AppendChild( $add ) | out-null;
        $configsections = $xml.configuration.configSections;
        $xml.configuration.InsertAfter( $appsettings,$configsections ) | out-null;
        $xml.save( $location );
    }
    Write-Host "Updating AppFabric config complete"
    Exit 0;
} else {
    Write-Host "AppFabric already has the desired version, skipping the upgrade"
    Exit 0;
}
