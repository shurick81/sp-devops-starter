# Application
    try
    {
        $dnsNames = "oos.contoso.local", "OOS01.CONTOSO.LOCAL", "OOS02.CONTOSO.LOCAL";
        $templateName = "CustomSSLCertificateTemplate";
        $friendlyName = "oos.contoso.local 2018-07-31";
        $pfxPass = ConvertTo-SecureString "sdpofiwojiosddf" -AsPlainText -Force
        $outputDirectory = "c:\tmp";

        $result = .\src\certificates\getcertificate.ps1 -DnsNames $dnsNames -TemplateName $templateName -FriendlyName $friendlyName -PfxPass $pfxPass -OutputDirectory $outputDirectory
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
        $pfxPass = ConvertTo-SecureString "sdpofiwojiosddf" -AsPlainText -Force
        $outputDirectory = "c:\tmp";
        if ( Get-Item "$outputDirectory\$friendlyName.pfx" -ErrorAction Ignore )
        {
            $cert = Import-PfxCertificate -FilePath "$outputDirectory\$friendlyName.pfx" -CertStoreLocation Cert:\LocalMachine\My -Password $pfxPass;
            if ( $cert ) {
                $cert | Remove-Item -Force;
            } else {
                Write-Host "$(Get-Date) Certificate could not be imported";
                Exit 1;
            }
        } else {
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
        $outputDirectory = "c:\tmp";
        Remove-Item "$outputDirectory\$friendlyName.pfx"
        if ( Get-Item "$outputDirectory\$friendlyName.pfx" -ErrorAction Ignore )
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
Write-Host "$(Get-Date) Test #1 is complete";


# Application
try
{
    $dnsNames = "sh01test.contoso.local";
    $templateName = "CustomSSLCertificateTemplate";
    $friendlyName = "sh01test.contoso.local 2018-07-31";
    $pfxPass = ConvertTo-SecureString "sdpofiwojiosddf" -AsPlainText -Force
    $outputDirectory = ".";

    $result = .\src\certificates\getcertificate.ps1 -DnsNames $dnsNames -TemplateName $templateName -FriendlyName $friendlyName -PfxPass $pfxPass -OutputDirectory $outputDirectory
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
    $outputDirectory = ".";
    if ( !( Get-Item "$outputDirectory\$friendlyName.pfx" -ErrorAction Ignore ) )
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
    $outputDirectory = ".";
    Remove-Item "$outputDirectory\$friendlyName.pfx"
    if ( Get-Item "$outputDirectory\$friendlyName.pfx" -ErrorAction Ignore )
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

Write-Host "$(Get-Date) Test #2 is complete";


# Application
try
{
    $dnsNames = "sh02test.contoso.local";
    $templateName = "CustomSSLCertificateTemplate";

    $result = .\src\certificates\getcertificate.ps1 -DnsNames $dnsNames -TemplateName $templateName
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
    $outputDirectory = ".";
    if ( !( Get-Item "$outputDirectory\$friendlyName.pfx" -ErrorAction Ignore ) )
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
    $outputDirectory = ".";
    Remove-Item "$outputDirectory\$friendlyName.pfx"
    if ( Get-Item "$outputDirectory\$friendlyName.pfx" -ErrorAction Ignore )
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

Write-Host "$(Get-Date) Test #3 is complete";


# Application
try
{
    $dnsNames = "oos.contoso.local", "OOS01.CONTOSO.LOCAL", "OOS02.CONTOSO.LOCAL";
    $templateName = "CustomSSLCertificateTemplate";

    $result = .\src\certificates\getcertificate.ps1 -DnsNames $dnsNames -TemplateName $templateName
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
    $outputDirectory = ".";
    if ( !( Get-Item "$outputDirectory\$friendlyName.pfx" -ErrorAction Ignore ) )
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
    $outputDirectory = ".";
    Remove-Item "$outputDirectory\$friendlyName.pfx"
    if ( Get-Item "$outputDirectory\$friendlyName.pfx" -ErrorAction Ignore )
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

Write-Host "$(Get-Date) Test #4 is complete";


Exit 0;
