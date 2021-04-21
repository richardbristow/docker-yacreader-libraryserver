# docker-yacreader-libraryserver

[![Build and Publish](https://github.com/richardbristow/docker-yacreader-libraryserver/actions/workflows/build-and-publish.yml/badge.svg)](https://github.com/richardbristow/docker-yacreader-libraryserver/actions/workflows/build-and-publish.yml)

Runs a headless version of the [YACreader](https://github.com/YACReader/yacreader) library server in a container, using the alpine base image.

When starting the image it will attempt to locate an existing YACreader library and automatically add it before starting the server. If an existing library is not found a new one will be created.

The image has a cron job setup that runs the YACreader update-library command every 10 minutes, to add new files to the library.

The docker image is also available to be pulled from the GitHub container registry.

## Example usage

```docker
docker run --rm \
  -p 8080:8080 \
  -v /path/to/comics:/comics \
  richardbristow/docker-yacreader-libraryserver
```

## Docker-compose example

```docker
version: '3'
services:
  docker-yacreader-libraryserver:
    container_name: docker-yacreader-libraryserver
    image: richardbristow/docker-yacreader-libraryserver
    restart: unless-stopped
    volumes:
      - /path/to/comics:/comics
    ports:
      - 8080:8080
```
