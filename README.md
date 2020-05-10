# Containerized ices + icecast server

## Description

There are two docker images: ices (icesource) and icecast (which is SHOUTcast open-source alternative). Each ices instance will stream one folder (mounted to /media inside container) in random order to shared icecast service. Therefore normally you`d have one or more running ices servers connected to single icecast server that would expose public access to all streams via http.

Using docker buildx to target amd64 and armv7 archs

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

(assuming docker-compose is already installed and working correctly, see links section below)

To verify your setup one would run it locally in your environment using below steps. To run this as a service usind systemd and have it auto started on boot please use second part of instruction

### Run manually (most probably for testing)

just run `docker-compose up`, you shoul be able to see similar output
```
Creating network "foldercast-docker_default" with the default driver
Creating foldercast-docker_icecast_1 ... done
Creating foldercast-docker_ices_1    ... done
Attaching to foldercast-docker_icecast_1, foldercast-docker_ices_1
icecast_1  | [2020-05-10  11:19:51] WARN CONFIG/_parse_root Warning, <hostname> not configured, using default value "localhost". This will cause problems, e.g. with YP directory listings.
icecast_1  | [2020-05-10  11:19:51] WARN CONFIG/_parse_root Warning, <location> not configured, using default value "Earth".
icecast_1  | [2020-05-10  11:19:51] WARN CONFIG/_parse_root Warning, <admin> contact not configured, using default value "icemaster@localhost".
icecast_1  | [2020-05-10  11:19:51] WARN fserve/fserve_recheck_mime_types Cannot open mime types file /etc/mime.types
```

Now you may see status under http://localhost:8000/admin/ and listen stream under http://localhost:8000/listen

### Run as a service (auto start on boot)

Using [this](https://gist.github.com/mosquito/b23e1c1e5723a7fd9e6568e5cf91180f) example.

* Create generic service runner using `sudo nano /etc/systemd/system/docker-compose@.service`. Place following contents there
```
[Unit]
Description=%i service with docker compose
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=true
WorkingDirectory=/etc/docker/compose/%i
ExecStart=/usr/local/bin/docker-compose up -d --remove-orphans
ExecStop=/usr/local/bin/docker-compose down

[Install]
WantedBy=multi-user.target
```
* Copy `docker-compose.yml` file to `/etc/docker/compose/foldercast` and start service like this
```
sudo systemctl start docker-compose@foldercast 
```
Hopefully this started without an error, and you should be able to see status `active (running)` 
```
systemctl status docker-compose@foldercast 
```
Now you may enbale service to auto start on boot 
```
sudo systemctl enable docker-compose@foldercast 
```

### Docker cleanup service

Docker tends to take to much space with time, so once in a while you may come and run `docker system prune` to remove unused images and volumes. As an alternative one may setup a service to do it automatically once in a while.

Create a timer file `sudo nano /etc/systemd/system/docker-cleanup.timer` and add following content
```
[Unit]
Description=Docker cleanup timer

[Timer]
OnUnitInactiveSec=12h

[Install]
WantedBy=timers.target
```

Create a servce file `sudo nano /etc/systemd/system/docker-cleanup.service` and add following content
```
[Unit]
Description=Docker cleanup
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
WorkingDirectory=/tmp
User=root
Group=root
ExecStart=/usr/bin/docker system prune -af

[Install]
WantedBy=multi-user.target
```

Now enable service with this command
```
systemctl enable docker-cleanup.timer
```

## Links
* [IceS Home](https://xiph.org/)
* [Install Docker](https://docs.docker.com/engine/install/ubuntu/)
* [Install Docker Compose on amd64](https://docs.docker.com/compose/install/)
* [Install Docker Compose on arm](https://www.berthon.eu/2019/revisiting-getting-docker-compose-on-raspberry-pi-arm-the-easy-way/)
* [Install BuildX](https://github.com/docker/buildx/)
