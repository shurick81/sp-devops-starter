param(
    [Parameter(Mandatory=$true,Position=1)]
    [ValidateNotNullorEmpty()]
    [String[]]
    $DnsNames,
    [Parameter(Mandatory=$true,Position=2)]
    [ValidateNotNullorEmpty()]
    [String]
    $TemplateName,
    [Parameter(Mandatory=$false,Position=3)]
    [String]
    $FriendlyName,
    [Parameter(Mandatory=$false)]
    [securestring]
    $PfxPass,
    [Parameter(Mandatory=$false)]
    [String]
    $OutputDirectory = "."
)

$certFileInfo = New-Object -TypeName psobject;
$firstDnsName = $DnsNames[0];
$subjectName = "CN=$firstDnsName";
if ( !$friendlyName ) {
    $friendlyName = $firstDnsName + " " + ( Get-Date -Format 'yyyy-MM-dd' );
}
if ( !$PfxPass ) {
    $plainPass = -join ((65..90) + (97..122) | Get-Random -Count 12 | % {[char]$_})
    $certFileInfo | Add-Member -MemberType NoteProperty -Name Password -Value $plainPass;
    $pfxPass = ConvertTo-SecureString $plainPass -AsPlainText -Force;
}
$pfxFileName = "$outputDirectory\$friendlyName.pfx";
#Write-Host "$(Get-Date) Checking $pfxFileName file";
if ( !( Get-Item $pfxFileName -ErrorAction Ignore ) )
{
    #Write-Host "$(Get-Date) File is to be generated"
    $enrollmentResponse = Get-Certificate -Template $templateName -DnsName $dnsNames -CertStoreLocation cert:\LocalMachine\My -SubjectName $subjectName;
    $enrollmentStatus = $enrollmentResponse.Status;
    if ( $enrollmentStatus -band [Microsoft.CertificateServices.Commands.EnrollmentStatus]::Issued )
    {
        #Write-Host "$(Get-Date) certificate is issued";
        $cert = $enrollmentResponse.Certificate;
        $certFileInfo | Add-Member -MemberType NoteProperty -Name Thumbprint -Value $cert.Thumbprint;
        $cert.FriendlyName = $friendlyName;
        #Write-Host "Thumbprint: $($cert.Thumbprint)";
        $cert | Export-PfxCertificate -FilePath $pfxFileName -Password $pfxPass -Force | Out-Null
        $certFileInfo | Add-Member -MemberType NoteProperty -Name Path -Value ( Resolve-Path $pfxFileName )
        $cert | Remove-Item -Force;
    } else {
        throw "Enrollment status is $enrollmentStatus";
    }
} else {
    throw "File already exists";
}
Write-Output $certFileInfo;
