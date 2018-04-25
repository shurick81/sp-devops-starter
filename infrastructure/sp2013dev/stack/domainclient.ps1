$configName = "DomainClient"
Configuration $configName
{
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullorEmpty()]
        [PSCredential]
        $DomainAdminCredential
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DSCResource -ModuleName xComputerManagement -ModuleVersion 3.2.0.0
    Import-DscResource -ModuleName xNetworking -ModuleVersion 5.6.0.0

    Node $AllNodes.NodeName
    {        

        xDefaultGatewayAddress SetDefaultGateway 
        { 
            Address        = '192.168.52.1' 
            InterfaceAlias = 'Ethernet 2' 
            AddressFamily  = 'IPv4' 
        }
        
        xDnsServerAddress DnsServerAddress
        {
            InterfaceAlias = 'Ethernet 2'
            AddressFamily  = 'IPv4'
            Address        = '192.168.52.128'
            Validate       = $false
        }
 
        xComputer JoinDomain
        {
            Name        = $NodeName
            DomainName  = "contoso.local"
            Credential  = $DomainAdminCredential
            DependsOn   = "[xDnsServerAddress]DnsServerAddress"
        }

        Group AdminGroup
        {
            GroupName           = "Administrators"
            Credential          = $DomainAdminCredential
            MembersToInclude    = "contoso\OG SharePoint2016 Server Admin Prod"
            DependsOn           = "[xComputer]JoinDomain"
        }

    }
}


$configurationData = @{ AllNodes = @(
    @{ NodeName = $env:COMPUTERNAME; PSDscAllowPlainTextPassword = $True; PsDscAllowDomainUser = $True }
) }

$securedPassword = ConvertTo-SecureString "Fractalsol" -AsPlainText -Force
$DomainAdminCredential = New-Object System.Management.Automation.PSCredential( "contoso\administrator", $securedPassword )

&$configName `
    -ConfigurationData $configurationData `
    -DomainAdminCredential $DomainAdminCredential;
#Set-DscLocalConfigurationManager $configName -Verbose -Force;
Start-DscConfiguration $configName -Verbose -Wait -Force;