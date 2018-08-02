Try
{
    $securedPassword = ConvertTo-SecureString "c0mp1Expa~~" -AsPlainText -Force
    $SPInstallAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_spadm16", $securedPassword );
    $db = Invoke-Command DBWEBCODE01.contoso.local -Credential $SPInstallAccountCredential -Authentication CredSSP { Invoke-SPDSCCommand -ScriptBlock {
        Get-SPDatabase;
    }}
    if ( $db ) {
        Write-Host "Found dbs";
        Exit 0
    } else {
        Write-Host "Did not find dbs";
        Exit 1
    }
}
Catch
{
    Write-Host "Failed to get farm";
    Exit 1;
}
Write-Host "Succeeded to get farm";
Exit 0;