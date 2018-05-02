$securedPassword = ConvertTo-SecureString "c0mp1Expa~~" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential( "contoso\_spadm16", $securedPassword )
Try
{
    Invoke-Command DBWEBCODE01 -Credential $credential -Authentication CredSSP { Invoke-SPDSCCommand -ScriptBlock {
        Get-SPDatabase;
    }}
}
Catch
{
    Write-Host "Failed to get farm";
    Exit 1;
}    
Write-Host "Succeeded to get farm";
Exit 0;