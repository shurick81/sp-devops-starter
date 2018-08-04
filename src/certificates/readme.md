# Usage

Run commands in PowerShell console with administrative privileges
## Syntax

## Examples

```
$pfxPass = ConvertTo-SecureString "sdpofiwojiosddf" -AsPlainText -Force

./getcertificate.ps1 -DnsNames "oos.contoso.local", "OOS01.CONTOSO.LOCAL", "OOS02.CONTOSO.LOCAL" -TemplateName "CustomSSLCertificateTemplate" -FriendlyName "oos.contoso.local 2018-07-31" -PfxPass $pfxPass -OutputDirectory "."
```