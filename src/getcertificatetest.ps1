# Application
    try
    {
        $dnsNames = "oos.contoso.local", "OOS01.CONTOSO.LOCAL", "OOS02.CONTOSO.LOCAL";
        $templateName = "CustomSSLCertificateTemplate";
        $friendlyName = "oos.contoso.local 2018-07-31";
        $pfxPass = ConvertTo-SecureString "sdpofiwojiosddf" -AsPlainText -Force
        $outputDirectory = ".";

        c:/projects/sp-devops-starter/src/getcertificate.ps1 -DnsNames $dnsNames -TemplateName $templateName -FriendlyName $friendlyName -PfxPass $pfxPass -OutputDirectory $outputDirectory
    }
    catch
    {
        Write-Host "$(Get-Date) Exception in getcertificate:";
        $_.Exception.Message;
        Exit 1;
    }

# Test
    try
    {
        $dnsNames = "oos.contoso.local", "oos1.contoso.local", "oos2.contoso.local";
        $friendlyName = "oos.contoso.local 2018-07-31";
        $certPass = $null;
        $certFileDirectory = ".";
        if ( !( Get-Item "$certFileDirectory\$friendlyName.pfx" -ErrorAction Ignore ) )
        {
            Write-Host "$(Get-Date) Pfx file is not found";
            Exit 1;
        }
    }
    catch
    {
        Write-Host "$(Get-Date) Exception in getcertificate test:";
        $_.Exception.Message;
        Exit 1;
    }

Exit 0;