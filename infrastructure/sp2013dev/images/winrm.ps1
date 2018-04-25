New-NetFirewallRule -DisplayName 'WinRM-HTTP' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5985
New-NetFirewallRule -DisplayName 'WinRM-HTTPS' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5986
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/Config '@{MaxEnvelopeSizekb = "1536"}'
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name LocalAccountTokenFilterPolicy -PropertyType DWord -Value 1