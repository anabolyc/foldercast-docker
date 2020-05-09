# Containerized ices + icecast server

## Description

There are two docker images: ices (icesource) and ices. Each ices instance will stream one folder (mounted to /media inside container) in random order to shared ices service. Therefore normally you`d have one or more running ices servers connected to single ices server that would expose public access to all streams via http.

Using builx to target amd64 and armv7 archs

## How to build

(assuming docker and buildx already installed, see links section below)

### ICES 

* Go to `ices` folder 
* Run `config builder` task first to configure docker buildx.
* Run `docker buildx & export to docker` task to build ices docker image for current arch and export to docker environment.
* (Alternatively) Run `docker buildx` task to build ices docker image for all archs. This is currently failing to export image to docker environment due to some bug.
* (Alternatively) Run `docker buildx & push to registry` task to build ices docker image for all archs and push result to registry.

You should have ices working now, you may test it with `docker run` task to execute ices or `docker run bash` to run bash in target container and perhaps execute `start.sh` yourself

### ICECAST

* Go to `icecast` folder 
* Run `config builder` task first to configure docker buildx (in not done while building ices).
* Run `docker buildx & export to docker` task to build icecast docker image for current arch and export to docker environment.
* (Alternatively) Run `docker buildx` task to build icecast docker image for all archs. This is currently failing to export image to docker environment due to some bug.
* (Alternatively) Run `docker buildx & push to registry` task to build icecast docker image for all archs and push result to registry.

You should have icecast working now, you may test it with `docker run` task to execute icecast or `docker run bash` to run bash in target container and perhaps execute `start.sh` yourself. When executed you should be able to access web page at http://localhost:8000 and log on as admin using password specified in `ICECAST_ADMPASSWORD` container environment variable.

## How to run

To verify your setup one would run it locally in your environment using below steps. To run this as a service usind systemd and have it auto started on boot please use second part of instruction

### Run manually (most probably for testing)

TBC

### Run as a service (auto start on boot)

TBC 

## Links
* [ices Home](https://xiph.org/)
* [Install Docker](https://docs.docker.com/engine/install/ubuntu/)
* [Install BuildX](https://github.com/docker/buildx/)