e:\cert\VBoxCertUtil add-trusted-publisher e:\cert\vbox-sha1.cer --root e:\cert\vbox-sha1.cer
e:\cert\VBoxCertUtil add-trusted-publisher e:\cert\vbox-sha256.cer --root e:\cert\vbox-sha256.cer
if ( Get-Item e:\cert\vbox-sha256-r3.cer -ErrorAction Ignore ) {
    e:\cert\VBoxCertUtil add-trusted-publisher e:\cert\vbox-sha256-r3.cer --root e:\cert\vbox-sha256-r3.cer
}
e:\VBoxWindowsAdditions.exe /S