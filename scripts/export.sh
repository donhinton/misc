#! /bin/bash

DIRS="/usr/bin /usr/include /usr/lib /lib"
HOST_DEST="/tmp/docker/ubuntu"
CONT_DEST="/tmp/ubuntu"

if [ $# -eq 1 ]; then

  OS=`uname`
  if [ "$OS" = "Linux" ]; then
    READLINK=readlink
  elif [ "$OS" = "Darwin" ]; then
    READLINK=stat
    EXT=".dylib"
  fi

  if [ ! -d $HOST_DEST ]; then
    mkdir -p $HOST_DEST
  fi

  SRC_DIR="$( cd "$( dirname "$(${READLINK} -f "$0")" )" && pwd )"
  CONTAINER=$1
  SCRIPTS_DIR=/tmp/`basename $SRC_DIR`
  docker run -it -v $SRC_DIR:$SCRIPTS_DIR -v $HOST_DEST:$CONT_DEST $CONTAINER $SCRIPTS_DIR/export.sh

else

  cd $CONT_DEST && tar cf - $DIRS | tar xf -

fi
