Import-Module PSPKI;
$certificateSourceTemplateName = "WebServer"
$templateName = "CustomSSLCertificateTemplate";
$templateDisplayName = "Custom SSL Certificate Template";
$templateCnName = "CN=" + $templateName;
$configContext = ( [ADSI]"LDAP://RootDSE" ).ConfigurationNamingContext;
Write-Host "$(Get-Date) Checking $templateName template";
$ADSI = [ADSI]"LDAP://$templateCnName,CN=Certificate Templates,CN=Public Key Services,CN=Services,$ConfigContext";
if ( !$ADSI.Guid ) {
    Write-Host "$(Get-Date) Template is to be created";
    $ADSI = [ADSI]"LDAP://CN=Certificate Templates,CN=Public Key Services,CN=Services,$configContext";
    $ADSI.Guid;
    $NewTempl = $ADSI.Create("pKICertificateTemplate", $templateCnName);
    $NewTempl.put("distinguishedName", "$templateCnName,CN=Certificate Templates,CN=Public Key Services,CN=Services,$configContext");
    $NewTempl.put("flags", "66113");
    $NewTempl.put("displayName", $templateDisplayName);
    $NewTempl.put("revision", "4");
    $NewTempl.put("pKIDefaultKeySpec", "1");
    $NewTempl.SetInfo();
    $NewTempl.put("pKIMaxIssuingDepth", "0")
    $NewTempl.put("pKICriticalExtensions", "2.5.29.15")
    $NewTempl.put("pKIExtendedKeyUsage", "1.3.6.1.5.5.7.3.1")
    $NewTempl.put("pKIDefaultCSPs", "2,Microsoft DH SChannel Cryptographic Provider, 1,Microsoft RSA SChannel Cryptographic Provider")
    $NewTempl.put("msPKI-RA-Signature", "0")
    $NewTempl.put("msPKI-Enrollment-Flag", "0")
    $NewTempl.put("msPKI-Private-Key-Flag", "16842768")
    $NewTempl.put("msPKI-Certificate-Name-Flag", "1")
    $NewTempl.put("msPKI-Minimal-Key-Size", "2048")
    $NewTempl.put("msPKI-Template-Schema-Version", "2")
    $NewTempl.put("msPKI-Template-Minor-Revision", "2")
    $NewTempl.put("msPKI-Cert-Template-OID", "1.3.6.1.4.1.311.21.8.287972.12774745.2574475.3035268.16494477.77.11347877.1740361")
    $NewTempl.put("msPKI-Certificate-Application-Policy", "1.3.6.1.5.5.7.3.1")
    $NewTempl.SetInfo()
    $WATempl = $ADSI.psbase.children | ? { $_.Name -eq $certificateSourceTemplateName }
    $NewTempl.pKIKeyUsage = $WATempl.pKIKeyUsage
    $NewTempl.pKIExpirationPeriod = $WATempl.pKIExpirationPeriod
    $NewTempl.pKIOverlapPeriod = $WATempl.pKIOverlapPeriod
    $NewTempl.SetInfo()

    $ADSI = [ADSI]"LDAP://CN=$templateName,CN=Certificate Templates,CN=Public Key Services,CN=Services,$configContext";
    $rules = $ADSI.psbase.ObjectSecurity.Access | ? { ( $_.IdentityReference -eq "contoso\CODE01$" ) -and ( $_.ActiveDirectoryRights -band [System.DirectoryServices.ActiveDirectoryRights]::ExtendedRight ) }
    if ( !$rules ) {
        $AdObj = New-Object System.Security.Principal.NTAccount("CODE01$")
        $identity = $AdObj.Translate([System.Security.Principal.SecurityIdentifier])
        $adRights = "ExtendedRight"
        $type = "Allow"
        $ACE = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($identity,$adRights,$type)
        $ADSI.psbase.ObjectSecurity.SetAccessRule($ACE)
        $ADSI.psbase.commitchanges()
    }
    $certTemplate = Get-CertificateTemplate -Name $templateName
    Get-CertificationAuthority | Get-CATemplate | Add-CATemplate -Template $certTemplate | Set-CATemplate
} else {
    Write-Host "$(Get-Date) Template already exists";
}
