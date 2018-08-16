Write-Host "SPDEVOPSSTARTER_JENKINSLABEL: $env:SPDEVOPSSTARTER_JENKINSLABEL"
Write-Host "SPDEVOPSSTARTER_JENKINSHOST: $env:SPDEVOPSSTARTER_JENKINSHOST"
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"; Invoke-RestMethod -Uri "https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.9/swarm-client-3.9.jar" -OutFile "swarm-client-3.9.jar";
Start-Process -FilePath "java" -ArgumentList "-jar swarm-client-3.9.jar -name $env:computername -disableSslVerification -master http://$env:SPDEVOPSSTARTER_JENKINSHOST`:16080 -username admin -password admin -labels `'vm-$($env:SPDEVOPSSTARTER_JENKINSLABEL)`' -executors 2";
