#!/bin/bash
sudo -i
# Increase the vm.max_map_count for kernel and ulimit for the current session at runtime.
sudo bash -c 'cat <<EOT> /etc/sysctl.conf
vm.max_map_count=524288
fs.file-max=131072
ulimit -n 65536
ulimit -u 4096
EOT'
sudo sysctl -w vm.max_map_count=524288
sysctl -w fs.file-max=131072

#Increase these permanently
sudo bash -c 'cat <<EOT> /etc/security/limits.conf
sonarqube   -   nofile   65536
sonarqube   -   nproc    4096
EOT'

# Need JDK 17 or higher to run SonarQube 9.9
yum update -y
sudo yum install java-17-amazon-corretto.x86_64 -y
# sudo update-alternatives --config java
# java -version


# Install and configure PostgreSQL & Create a user and database for sonar
# wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
# sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
# sudo apt install postgresql postgresql-contrib -y
# sudo systemctl enable postgresql.service
# sudo systemctl start  postgresql.service
# sudo echo "postgres:admin123" | chpasswd
# runuser -l postgres -c "createuser sonar"
# sudo -i -u postgres psql -c "ALTER USER sonar WITH ENCRYPTED PASSWORD 'admin123';"
# sudo -i -u postgres psql -c "CREATE DATABASE sonarqube OWNER sonar;"
# sudo -i -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE sonarqube to sonar;"
# sudo systemctl restart  postgresql
sudo amazon-linux-extras install postgresql14 -y


#Download the binaries for SonarQube 
# sudo mkdir -p /sonarqube/
# cd /sonarqube/
# sudo curl -O https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.0.65466.zip
# sudo apt-get install zip -y
# sudo unzip -o sonarqube-9.9.0.65466.zip -d /opt/
yum install unzip -y
yum install net-tools
wget https://binaries.sonarsource.com/CommercialDistribution/sonarqube-datacenter/sonarqube-datacenter-10.1.0.73491.zip
mv sonarqube-datacenter-10.1.0.73491.zip /opt/ 
cd /opt/
unzip sonarqube-datacenter-10.1.0.73491.zip 
sudo mv sonarqube-10.1.0.73491 sonarqube
sudo rm -rf /opt/sonarqube/conf/sonar.properties 
sudo touch /opt/sonarqube/conf/sonar.properties

# PostgreSQL database username and password

var=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1 -d'/')

sudo bash -c "cat <<EOT > /opt/sonarqube/conf/sonar.properties
sonar.jdbc.username=SonarQube
sonar.jdbc.password=Password123
sonar.jdbc.url=jdbc:postgresql://:5432/postgres
sonar.cluster.enabled=true
sonar.cluster.node.type=application
sonar.cluster.node.host=$var
sonar.cluster.node.port=9003
sonar.cluster.hosts=$var
sonar.cluster.search.hosts=
sonar.auth.jwtBase64Hs256Secret=Z0EB0KxnF++nr5+4vfTCaun/eWbv6gOoXodiAMqcFo=
EOT"
# Create the group
sudo groupadd sonar
sudo useradd -c "SonarQube - User" -d /opt/sonarqube/ -g sonar sonar
sudo chown sonar:sonar /opt/sonarqube/ -R

# Create a systemd service file for SonarQube to run at system startup
sudo touch /etc/systemd/system/sonarqube.service
sudo bash -c 'cat <<EOT> /etc/systemd/system/sonarqube.service
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]ls
Type=forking

ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

User=sonar
Group=sonar
Restart=always

LimitNOFILE=65536
LimitNPROC=4096


[Install]
WantedBy=multi-user.target
EOT'

# automatically system startup enable
sudo systemctl daemon-reload
sudo systemctl enable sonarqube.service

sudo systemctl restart sonarqube.service
