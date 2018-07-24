$configName = "DomainClientVirtualBoxNetwork"
Write-Host "$(Get-Date) Defining DSC"
try
{
    Configuration $configName
    {
        param(
        )

        Import-DscResource -ModuleName PSDesiredStateConfiguration
        Import-DscResource -ModuleName xNetworking -ModuleVersion 5.6.0.0

        $netIP = Get-NetAdapter 'Ethernet 2' | Get-NetIPAddress -ea 0 -AddressFamily IPv4;
        $ipNumbers = $netIP.IPAddress.Split( "." );
        $ipAddressPrefix = $ipNumbers[0], $ipNumbers[1], $ipNumbers[2] -join "."
        Node $AllNodes.NodeName
        {        

            xDefaultGatewayAddress SetDefaultGateway 
            { 
                Address        = "$ipAddressPrefix.1"
                InterfaceAlias = 'Ethernet 2'
                AddressFamily  = 'IPv4'
            }
            
            xDnsServerAddress DnsServerAddress
            {
                InterfaceAlias = 'Ethernet 2'
                AddressFamily  = 'IPv4'
                Address        = "$ipAddressPrefix.128"
                Validate       = $false
            }

        }
    }
}
catch
{
    Write-Host "$(Get-Date) Exception in defining DCS:"
    $_.Exception.Message
    Exit 1;
}
$configurationData = @{ AllNodes = @(
    @{ NodeName = $env:COMPUTERNAME; PSDscAllowPlainTextPassword = $True; PsDscAllowDomainUser = $True }
) }

Write-Host "$(Get-Date) Compiling DSC"
try
{
    &$configName `
        -ConfigurationData $configurationData;
}
catch
{
    Write-Host "$(Get-Date) Exception in compiling DCS:";
    $_.Exception.Message
    Exit 1;
}
Write-Host "$(Get-Date) Starting DSC"
try
{
    Start-DscConfiguration $configName -Verbose -Wait -Force;
}
catch
{
    Write-Host "$(Get-Date) Exception in starting DCS:"
    $_.Exception.Message
    Exit 1;
}
if ( $env:SPDEVOPSSTARTER_NODSCTEST -ne "TRUE" )
{
    Write-Host "$(Get-Date) Testing DSC"
    try {
        $result = Test-DscConfiguration $configName -Verbose;
        $inDesiredState = $result.InDesiredState;
        $failed = $false;
        $inDesiredState | % {
            if ( !$_ ) {
                Write-Host "$(Get-Date) Test failed"
                Exit 1;
            }
        }
    }
    catch {
        Write-Host "$(Get-Date) Exception in testing DCS:"
        $_.Exception.Message
        Exit 1;
    }
} else {
    Write-Host "$(Get-Date) Skipping tests"
}
Exit 0;
