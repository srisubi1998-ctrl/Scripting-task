#!/bin/bash
mkdir -p Docker-Task
sudo apt update
sudo apt install -y docker.io
sudo usermod -aG docker ubuntu
docker pull nginx:latest
docker run -d --name nginx-web -p 8080:80 nginx:latest
docker ps
docker images
docker volume create my_app_data
docker volume ls
docker network create my_custom_network
docker network ls
docker stop nginx-web
docker rm nginx-web
docker volume rm my_app_data
docker network rm my_custom_network
