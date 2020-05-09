#!/bin/bash

find /media -iname "*.mp3" > /ices-0.4/playlist.txt && \
/ices-0.4/ices \
    -C 2 \
    -D /ices-0.4 \
    -F /ices-0.4/playlist.txt \
    -h $STREAM_HOST \
    -p $STREAM_PORT \
    -P $STREAM_PASSWORD \
    -m $STREAM_PATH \
    -n $STREAM_NAME \
    -d $STREAM_DESC \
    -g $STREAM_GENRE \
    -r \
    -v 