#!/bin/bash
 sudo -i
 yum update -y
 yum install unzip -y
 yum install net-tools
 wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.1.0.73491.zip
 mv sonarqube-10.1.0.73491.zip /opt/
 cd /opt/
 unzip sonarqube-10.1.0.73491.zip
 sudo mv sonarqube-10.1.0.73491 sonarqube

 sudo useradd sonar
 sudo chown -R sonar:sonar /opt/sonarqube

 sudo yum install java-17-amazon-corretto.x86_64 -y
 sudo amazon-linux-extras install postgresql14 -y

#basic installs toevoegen
#https://devopscube.com/setup-and-configure-sonarqube-on-linux/
#https://docs.sonarsource.com/sonarqube/latest/setup-and-upgrade/install-the-server-as-a-cluster/#application-nodes
#https://alexanderhose.com/transform-your-code-quality-with-sonarqube-on-aws-ecs-a-comprehensive-guide/
#key: Z0EB0KxnF++nr5+4vfTCaun/eWbv6gOoXodiAMqcFo=
#ip1: 10.0.3.65
#ip2: 10.0.4.86
#ip3: 10.0.3.189
#ip4: 10.0.4.150
#ip5: 10.0.5.188

# vergeet bij overzet niet de db aan te passen
#sonarqube-instance-1.c2b2r28b1tfo.eu-west-1.rds.amazonaws.com

#ip3:9001,ip4:9001,ip5:9001 === 10.0.3.189:9001,10.0.4.150:9001,10.0.5.188:9001

#ip3:9002,ip4:9002,ip5:9002 === 10.0.3.189:9002,10.0.4.150:9002,10.0.5.188:9002



sonar.cluster.enabled=true
sonar.cluster.node.type=application
sonar.cluster.node.host=ip1
sonar.cluster.node.port=9003
sonar.cluster.hosts=ip1,ip2
sonar.cluster.search.hosts=ip3:9001,ip4:9001,ip5:9001
sonar.auth.jwtBase64Hs256Secret=YOURGENERATEDSECRET:quality