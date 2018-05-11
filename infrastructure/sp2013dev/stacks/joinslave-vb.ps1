Invoke-RestMethod -Uri "https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.5/swarm-client-3.5.jar" -OutFile "swarm-client-3.5.jar";
Start-Process -FilePath "java" -ArgumentList "-jar swarm-client-3.5.jar -name $env:computername -disableSslVerification -master http://192.168.52.80:8080 -username admin -password admin -labels `"sharepoint-auto`" -executors 2";
