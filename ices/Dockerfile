FROM debian:buster-slim as build

ENV DEBIAN_FRONTEND noninteractive

RUN  apt-get update && \
     apt-get install -y wget apt-transport-https ca-certificates locales && \
     apt-get update

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales && \
    /usr/sbin/update-locale LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN  apt-get install -y build-essential libmp3lame-dev libxml2-dev libshout-dev libvorbis-dev

ADD http://downloads.us.xiph.org/releases/ices/ices-0.4.tar.gz /
RUN tar xf /ices-0.4.tar.gz

WORKDIR /ices-0.4

RUN ./configure --prefix=/usr/local --with-pic --with-lame && make 

FROM debian:buster-slim

RUN  apt-get update && \
     apt-get install -y libmp3lame-dev libxml2-dev libshout-dev libvorbis-dev

WORKDIR /ices-0.4
COPY --from=build /ices-0.4/src/ices .
ADD start.sh .

ENV STREAM_PASSWORD "f498f60c-4ca0-4506-b9ac-1b9623d3db6e"
ENV STREAM_HOST "localhost"
ENV STREAM_PORT 8000
ENV STREAM_PATH "/listen"
ENV STREAM_NAME "MY STREAM"
ENV STREAM_DESC "MY STREAM DESCRIPTION"
ENV STREAM_GENRE "Everything"

CMD ["/bin/bash", "./start.sh"]