# Containerized icecast+shoutcast 

## DEscription

...
Using builx to target amd64 and armv7 archs

## How to build

(assuming docker and buildx already installed, see links below)

### ICECAST 

* Go to icecast folder 
* Run 'config builder' task first to configure docker buildx.
* Run 'docker buildx & export to docker' task to build icecast docker image for current arch and export to docker environment.
* (Alternatively) Run 'docker buildx' task to build icecast docker image for all archs. This is failing to export image to docker environment for some reason.
* (Alternatively) Run 'docker buildx & push to registry' task to build icecast docker image for all archs and push result to registry.

You should have icecast working now, you may test it with 'docker run' task to execute icecast or 'docker run bash' to run bash in target container and perhaps execute start.sh yourself

### SHOUTCAST

TBC

## Links

[Install Docker](https://docs.docker.com/engine/install/ubuntu/)
[Install BuildX](https://github.com/docker/buildx/)