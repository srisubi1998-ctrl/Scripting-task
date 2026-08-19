#!/bin/bash
mkdir -p Docker-Task-2
cd Docker-Task-2
cat << 'HTML' > index.html
<!DOCTYPE html>
<html>
<head><title>DevOps Profile</title></head>
<body>
    <h1>DevOps Engineer Profile</h1>
    <p><strong>Name:</strong> Subitcha</p>
    <p><strong>Role:</strong> DevOps / AWS Student</p>
    <p><strong>Task:</strong> GUVI Docker Task - 2</p>
</body>
</html>
HTML

cat << 'DOCKER' > Dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
DOCKER

cat << 'COMPOSE' > docker-compose.yml
services:
  web-app:
    build: .
    ports:
      - "8080:80"
    restart: always
COMPOSE

docker compose up -d --build
docker compose ps
curl http://localhost:8080
