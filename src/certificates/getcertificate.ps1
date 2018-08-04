param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullorEmpty()]
    [String[]]
    $DnsNames,
    [Parameter(Mandatory=$true)]
    [ValidateNotNullorEmpty()]
    [String]
    $TemplateName,
    [Parameter(Mandatory=$false)]
    [String]
    $FriendlyName,
    [Parameter(Mandatory=$false)]
    [securestring]
    $PfxPass,
    [Parameter(Mandatory=$false)]
    [String]
    $OutputDirectory = "."
)

$certFileInfo = @{}
if ( !$friendlyName ) {
    $friendlyName = $DnsNames[0] + " " + ( Get-Date -Format 'yyyy-MM-dd' );
}
if ( !$PfxPass ) {
    $plainPass = -join ((65..90) + (97..122) | Get-Random -Count 12 | % {[char]$_})
    $certFileInfo.Password = $plainPass;
    $pfxPass = ConvertTo-SecureString $plainPass -AsPlainText -Force
}
$pfxFileName = "$outputDirectory\$friendlyName.pfx";
#Write-Host "$(Get-Date) Checking $pfxFileName file";
if ( !( Get-Item $pfxFileName -ErrorAction Ignore ) )
{
    #Write-Host "$(Get-Date) File is to be generated"
    $enrollmentResponse = Get-Certificate -Template $templateName -DnsName $dnsNames -CertStoreLocation cert:\LocalMachine\My
    $enrollmentStatus = $enrollmentResponse.Status;
    if ( $enrollmentStatus -band [Microsoft.CertificateServices.Commands.EnrollmentStatus]::Issued )
    {
        #Write-Host "$(Get-Date) certificate is issued";
        $cert = $enrollmentResponse.Certificate;
        $certFileInfo.Thumbprint = $cert.Thumbprint;
        $cert.FriendlyName = $friendlyName;
        #Write-Host "Thumbprint: $($cert.Thumbprint)";
        $cert | Export-PfxCertificate -FilePath $pfxFileName -Password $pfxPass -Force | Out-Null
        $certFileInfo.Path = ( Resolve-Path $pfxFileName ).Path;
        $cert | Remove-Item -Force;
    } else {
        throw "Enrollment status is $enrollmentStatus";
    }
} else {
    throw "File already exists";
}
return $certFileInfo;
