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
    [System.IO.FileInfo]
    $OutputDirectory
)

$pfxFileName = "$outputDirectory\$friendlyName.pfx";
Write-Host "$(Get-Date) Checking $pfxFileName file";
if ( !( Get-Item $pfxFileName -ErrorAction Ignore ) )
{
    Write-Host "$(Get-Date) File is to be generated"
    $enrollmentResponse = Get-Certificate -Template $templateName -DnsName $dnsNames -CertStoreLocation cert:\LocalMachine\My
    $enrollmentStatus = $enrollmentResponse.Status;
    if ( $enrollmentStatus -band [Microsoft.CertificateServices.Commands.EnrollmentStatus]::Issued )
    {
        Write-Host "$(Get-Date) certificate is issued";
        $cert = $enrollmentResponse.Certificate;
        $cert.FriendlyName = $friendlyName;
        Write-Host "Thumbprint: $($cert.Thumbprint)";
        $cert | Export-PfxCertificate -FilePath $pfxFileName -Password $pfxPass -Force | Out-Null
        $cert | Remove-Item -Force;
    } else {
        Write-Host "$(Get-Date) Enrollment status is $enrollmentStatus";
    }
} else {
    Write-Host "$(Get-Date) File already exists";
}
