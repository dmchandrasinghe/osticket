# osTicket Docker Image

This repository provides a Docker image for [osTicket](https://osticket.com/), an open-source support ticket system. The official osTicket project does **not** provide Docker images. Many community images are outdated or unmaintained, so this project aims to provide up-to-date and maintained Docker images for each osTicket release.

## Docker Hub

Images are published at:  
[dmchandrasinghe/osticket on Docker Hub](https://hub.docker.com/r/dmchandrasinghe/osticket)

## Features

- Based on PHP 7.4 and Apache
- Installs all required PHP extensions for osTicket
- Automated configuration via environment variables
- Supports custom database credentials, admin email, and table prefix
- Automatically downloads the specified osTicket version

## Usage

```sh
docker run -d \
  -e MYSQL_HOST=your-db-host \
  -e MYSQL_DATABASE=osticket_db \
  -e MYSQL_USER=osticket_user \
  -e MYSQL_PASSWORD=yourpassword \
  -e ADMIN_USERNAME=admin@example.com \
  -e INSTALL_SECRET=your_secret \
  -e OSTINSTALLED=true \
  -p 8080:80 \
  dmchandrasinghe/osticket:v1.14.3
```
