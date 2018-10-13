param(
    [Parameter(Mandatory=$false,Position=3)]
    [String]
    $ScriptDirectory = ".\infrastructure\stacks\customizations"
)

# Application
try
{
    Write-Host ( Resolve-Path $ScriptDirectory )
    $securedPassword = ConvertTo-SecureString "c0mp1Expa~~" -AsPlainText -Force
    $DomainAdminCredential = New-Object System.Management.Automation.PSCredential( "contoso\dauser1", $securedPassword );
    Invoke-Command -FilePath "$scriptDirectory\certtemplate.ps1" "CA01.contoso.local" -Credential $DomainAdminCredential -Authentication CredSSP
}
catch
{
    Write-Host "$(Get-Date) Exception in certtemplate:";
    $_.Exception.Message;
    Exit 1;
}

# Test
try
{
    $securedPassword = ConvertTo-SecureString "c0mp1Expa~~" -AsPlainText -Force
    $DomainAdminCredential = New-Object System.Management.Automation.PSCredential( "contoso\dauser1", $securedPassword );
    $result = Invoke-Command $env:COMPUTERNAME -Credential $DomainAdminCredential -Authentication CredSSP {
        $templateName = "CustomSSLCertificateTemplate";
        $templateCnName = "CN=" + $templateName;
        Import-Module PSPKI;
        $ConfigContext = ([ADSI]"LDAP://RootDSE").ConfigurationNamingContext;
        $ADSI = [ADSI]"LDAP://$templateCnName,CN=Certificate Templates,CN=Public Key Services,CN=Services,$ConfigContext";
        if ( $ADSI.Path ) {
            $rules = $ADSI.psbase.ObjectSecurity.Access | ? { ( $_.IdentityReference -eq "contoso\OPS01$" ) -and ( $_.ActiveDirectoryRights -band [System.DirectoryServices.ActiveDirectoryRights]::ExtendedRight ) }
            if ( $rules ) {
                Write-Host "$(Get-Date) Access is properly set";
            } else {
                Write-Host "$(Get-Date) Access is not properly set";
                return $false;
            }
        } else {
            Write-Host "$(Get-Date) Certificate template is not found";
            return $false;
        }
        return $true;
    }
    if ( !$result ) {
        Write-Host "$(Get-Date) Test returned False";
        Exit 1;
    }
}
catch
{
    Write-Host "$(Get-Date) Exception in certtemplate test:";
    $_.Exception.Message;
    Exit 1;
}

Exit 0;