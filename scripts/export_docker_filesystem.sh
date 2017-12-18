#! /bin/bash

# This script leverages docker to export a subset of the file system
# needed to cross compile.

# FIXME: Convert this to python, and incorporate the fix.py script
# which fixes absolute symlinks.

# example:
# export_docker_filesystem.sh donhinton/dev_env
# then cross compile like this...
# /Users/dhinton/usr/bin/clang++ ~/x.cpp --sysroot=/tmp/docker/ubuntu -target x86_64-linux-gnu -fuse-ld=lld

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
  IMAGE=$1
  SCRIPTS_DIR=/tmp/`basename $SRC_DIR`
  docker run -it -v $SRC_DIR:$SCRIPTS_DIR -v $HOST_DEST:$CONT_DEST $IMAGE $SCRIPTS_DIR/export_docker_filesystem.sh

  ${SRC_DIR}/fix_absolute_symlinks.py ${HOST_DEST}
else
  
  cd $CONT_DEST
  rm -rf *
  tar cf - $DIRS | tar xf -

fi
