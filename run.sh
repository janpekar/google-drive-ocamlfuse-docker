#!/bin/bash
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
USER=googledrive
touch $XAUTH
ENV_VARS+=" --env=DISPLAY=$DISPLAY"
ENV_VARS+=" --env=XAUTHORITY=${XAUTH}"
ENV_VARS+=" --env=UID=$(id -u)"
VOLUMES+=" --volume=${XSOCK}:${XSOCK}"
VOLUMES+=" --volume=${XAUTH}:${XAUTH}"

#Allow to access X11
xauth nlist "$DISPLAY" | sed -e 's/^..../ffff/' | xauth -f "$XAUTH" nmerge -
#Docker run with fuse enabled and rshared bind to volume to see fuse mounts
docker run -i -t $VOLUMES $ENV_VARS \
           --device /dev/fuse \
           --cap-add SYS_ADMIN \
           --mount type=bind,source=$(pwd)/volumes/$USER,target=/home/$USER,bind-propagation=rshared \
           google-drive-ocamlfuse:latest
