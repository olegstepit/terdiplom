#!/bin/bash

cat <<EOF >  /home/ubuntu/docker-compose.jenkins.yaml
version: '3.8'
services:
  jenkins:
    image: jj975/testdiplom:jenkins.v.1.0.0
    privileged: true
    user: root
    ports:
      - 8080:8080
      - 55555:50000
    container_name: jenkins
    volumes:
      - ./jenkins_conf:/var/jenkins_home
      #- ./varlib_jenkins_conf:/var/lib/jenkins/
      #- ./ssh_conf:/root/.ssh/
      - /var/run/docker.sock:/var/run/docker.sock
EOF
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu
sudo docker-compose  -f /home/ubuntu/docker-compose.jenkins.yaml  up -d 
#sleep 180
#sudo reboot 

