Submits a certificate request to an enrollment server and saves the response to the pfx file.

```PowerShell
$pathToScriptFile/getcertificate.ps1 -DnsNames <String[]> -TemplateName <String> -FriendlyName <String> -PfxPass <SecureString> -OutputDirectory <String>
```

## Examples

### Generating certificate for one domain name

```PowerShell
./getcertificate.ps1 "sh01test.contoso.local" "CustomSSLCertificateTemplate"
```

### Generating certificate for a few domain names

```PowerShell
./getcertificate.ps1 "oos.contoso.local", "OOS01.CONTOSO.LOCAL", "OOS02.CONTOSO.LOCAL" "CustomSSLCertificateTemplate"
```

### Generating certificate with a specified friendly name

```PowerShell
./getcertificate.ps1 "oos.contoso.local", "OOS01.CONTOSO.LOCAL", "OOS02.CONTOSO.LOCAL" "CustomSSLCertificateTemplate" -FriendlyName "oos.contoso.local 2018-07-31"
```

### Generating certificate and saving it in a file with a specified password

```PowerShell
$pfxPass = ConvertTo-SecureString "sdpofiwojiosddf" -AsPlainText -Force
./getcertificate.ps1 "oos.contoso.local", "OOS01.CONTOSO.LOCAL", "OOS02.CONTOSO.LOCAL" "CustomSSLCertificateTemplate" -PfxPass $pfxPass
```
If PfxPass parameter is not specified, the password is generated automatically and displayed in output.

### Generating certificate and saving it in particular directory

```PowerShell
./getcertificate.ps1 "oos.contoso.local", "OOS01.CONTOSO.LOCAL", "OOS02.CONTOSO.LOCAL" "CustomSSLCertificateTemplate" -OutputDirectory "c:\certs"
```

### Different arguments together

```PowerShell
$pfxPass = ConvertTo-SecureString "sdpofiwojiosddf" -AsPlainText -Force
./getcertificate.ps1 "oos.contoso.local", "OOS01.CONTOSO.LOCAL", "OOS02.CONTOSO.LOCAL" "CustomSSLCertificateTemplate" -FriendlyName "oos.contoso.local 2018-07-31" -PfxPass $pfxPass -OutputDirectory "c:\certs"
```