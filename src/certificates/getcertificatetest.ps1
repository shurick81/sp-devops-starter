Write-Host "$(Get-Date) Test #1";
# Application
    try
    {
        $dnsNames = "oos.contoso.local", "OOS01.CONTOSO.LOCAL", "OOS02.CONTOSO.LOCAL";
        $templateName = "CustomSSLCertificateTemplate";
        $friendlyName = "oos.contoso.local 2018-07-31";
        $pfxPass = ConvertTo-SecureString "sdpofiwojiosddf" -AsPlainText -Force
        $outputDirectory = ".";

        .\src\certificates\getcertificate.ps1 -DnsNames $dnsNames -TemplateName $templateName -FriendlyName $friendlyName -PfxPass $pfxPass -OutputDirectory $outputDirectory
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
        $friendlyName = "oos.contoso.local 2018-07-31";
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

# Clean
    try
    {
        $friendlyName = "oos.contoso.local 2018-07-31";
        $certFileDirectory = ".";
        Remove-Item "$certFileDirectory\$friendlyName.pfx"
        if ( Get-Item "$certFileDirectory\$friendlyName.pfx" -ErrorAction Ignore )
        {
            Write-Host "$(Get-Date) Pfx file is not found";
            Exit 1;
        }
    }
    catch
    {
        Write-Host "$(Get-Date) Exception in getcertificate clean:";
        $_.Exception.Message;
        Exit 1;
    }


Write-Host "$(Get-Date) Test #2";
# Application
try
{
    $dnsNames = "sh01test.contoso.local";
    $templateName = "CustomSSLCertificateTemplate";
    $friendlyName = "sh01test.contoso.local 2018-07-31";
    $pfxPass = ConvertTo-SecureString "sdpofiwojiosddf" -AsPlainText -Force
    $outputDirectory = ".";

    .\src\certificates\getcertificate.ps1 -DnsNames $dnsNames -TemplateName $templateName -FriendlyName $friendlyName -PfxPass $pfxPass -OutputDirectory $outputDirectory
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
    $friendlyName = "sh01test.contoso.local 2018-07-31";
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

# Clean
try
{
    $friendlyName = "sh01test.contoso.local 2018-07-31";
    $certFileDirectory = ".";
    Remove-Item "$certFileDirectory\$friendlyName.pfx"
    if ( Get-Item "$certFileDirectory\$friendlyName.pfx" -ErrorAction Ignore )
    {
        Write-Host "$(Get-Date) Pfx file detected";
        Exit 1;
    }
}
catch
{
    Write-Host "$(Get-Date) Exception in getcertificate clean:";
    $_.Exception.Message;
    Exit 1;
}


Write-Host "$(Get-Date) Test #3";
# Application
try
{
    $dnsNames = "sh02test.contoso.local";
    $templateName = "CustomSSLCertificateTemplate";

    .\src\certificates\getcertificate.ps1 -DnsNames $dnsNames -TemplateName $templateName
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
    $friendlyName = "sh02test.contoso.local $( Get-Date -Format 'yyyy-MM-dd' )";
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

# Clean
try
{
    $friendlyName = "sh02test.contoso.local $( Get-Date -Format 'yyyy-MM-dd' )";
    $certFileDirectory = ".";
    Remove-Item "$certFileDirectory\$friendlyName.pfx"
    if ( Get-Item "$certFileDirectory\$friendlyName.pfx" -ErrorAction Ignore )
    {
        Write-Host "$(Get-Date) Pfx file detected";
        Exit 1;
    }
}
catch
{
    Write-Host "$(Get-Date) Exception in getcertificate clean:";
    $_.Exception.Message;
    Exit 1;
}


Write-Host "$(Get-Date) Test #4";
# Application
try
{
    $dnsNames = "oos.contoso.local", "OOS01.CONTOSO.LOCAL", "OOS02.CONTOSO.LOCAL";
    $templateName = "CustomSSLCertificateTemplate";

    .\src\certificates\getcertificate.ps1 -DnsNames $dnsNames -TemplateName $templateName
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
    $friendlyName = "oos.contoso.local $( Get-Date -Format 'yyyy-MM-dd' )";
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

# Clean
try
{
    $friendlyName = "oos.contoso.local $( Get-Date -Format 'yyyy-MM-dd' )";
    $certFileDirectory = ".";
    Remove-Item "$certFileDirectory\$friendlyName.pfx"
    if ( Get-Item "$certFileDirectory\$friendlyName.pfx" -ErrorAction Ignore )
    {
        Write-Host "$(Get-Date) Pfx file detected";
        Exit 1;
    }
}
catch
{
    Write-Host "$(Get-Date) Exception in getcertificate clean:";
    $_.Exception.Message;
    Exit 1;
}


Exit 0;
