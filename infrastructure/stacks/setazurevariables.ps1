Write-Host "Setting up environment variables";
[System.Environment]::SetEnvironmentVariable('ARM_TENANT_ID', $env:SPDEVOPSSTARTER_ARM_TENANT_ID, [System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable('ARM_CLIENT_ID', $env:SPDEVOPSSTARTER_ARM_CLIENT_ID, [System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable('ARM_CLIENT_SECRET', $env:SPDEVOPSSTARTER_ARM_CLIENT_SECRET, [System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable('ARM_SUBSCRIPTION_ID', $env:SPDEVOPSSTARTER_ARM_SUBSCRIPTION_ID, [System.EnvironmentVariableTarget]::User)
