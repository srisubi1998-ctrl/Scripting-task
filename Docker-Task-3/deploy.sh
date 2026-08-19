#!/bin/bash

mkdir -p Docker-Task-3/html_data
cd Docker-Task-3

cat << 'CONF' > custom-nginx.conf
server {
    listen 80;
    server_name localhost;

    location / {
        root /var/opt/nginx;
        index index.html;
    }
}
CONF

cat << 'HTML' > html_data/index.html
<!DOCTYPE html>
<html>
<head><title>Docker Task 3</title></head>
<body>
    <h1>Custom Nginx with Bind Mount</h1>
    <p><strong>Mounted at:</strong> /var/opt/nginx</p>
    <p><strong>Student:</strong> Subitcha</p>
</body>
</html>
HTML

cat << 'DOCKER' > Dockerfile
FROM nginx:alpine
COPY custom-nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
DOCKER

cat << 'COMPOSE' > docker-compose.yml
services:
  custom-nginx:
    build: .
    image: localhost:5000/custom-nginx:latest
    ports:
      - "8080:80"
    volumes:
      - ./html_data:/var/opt/nginx
    restart: always
COMPOSE

docker compose up -d --build
docker compose ps
curl http://localhost:8080
docker compose push
