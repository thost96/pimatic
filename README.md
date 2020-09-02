# Docker images for PIMATIC
Docker container to run [PIMATIC](https://pimatic.org).

![Docker Image CI](https://github.com/thost96/docker-pimatic/workflows/Docker%20Image%20CI/badge.svg)
![Lint Code Base](https://github.com/thost96/docker-pimatic/workflows/Lint%20Code%20Base/badge.svg)

## Docker RUN

    docker run \
      --name pimatic \
      --hostname pimatic \
      --restart always \  
      --port 80:80 \
      --volume /data:/pimatic-app \
      thost96/pimatic

## Docker-Compose

    version: '2'
    services:
        pimatic:
            container_name: pimatic
            hostname: pimatic        
            restart: always
            volumes:
                - '/data:/pimatic-app'
            ports:
                - 80:80
            image: 'thost96/pimatic'


## Changelog

### 1.2.3 (pending)
* (thost96) - removed security checks from Docker Image CI Action into own Security Check Action

### 1.2.2 (27.08.2020)
* (thost96) - added Snyk security check to github actions

### 1.2.1 (20.06.2020)
* (thost96) - added github actions
* (thost96) - changed dockerfile for automated builds
* (thost96) - added pimatic user to dockerfile and improved setting locales and timezone

### 1.2.0 (20.06.2020)
* (thost96) - changed changelog to global version
* (thost96) - added Dependabot v2 config file
* (thost96) - removed deepsource from repo
* (thost96) - updated from node-10 to node-14
* (thost96) - added docker-run and docker-compose to README.md

### 1.1.0 (21.02.2020)
* (thost96) - removed unused stages and linked logfile to stdout for docker logs

### 1.0.0 (01.05.2019)
* (thost96) - Initial release
