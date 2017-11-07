# !/bin/bash

# FIXME: Add parameter support, reduce duplication, and convert to
# python.

set -x

ROOT_DIR=`pwd`
echo "dir = $ROOT_DIR"

#if [ "$(basename $ROOT_DIR)" != "llvm_project" ] ; then
#  echo "not llvm_project"
#  exit 1
#fi

# llvm
PROJ=llvm
SUBDIR=${ROOT_DIR}
PROJ_DIR=${SUBDIR}/${PROJ}
if [ -d ${PROJ_DIR} ] ; then
  cd ${PROJ_DIR}
  MSG=$(git stash)
  BRANCH=$(git rev-parse --abbrev-ref HEAD)
  ${ROOT_DIR}/llvm/utils/git-svn/git-svnup
  if [ "$MSG" != "No local changes to save" ]; then
    git stash pop
	fi
  if [ "$BRANCH" != "master" ]; then
    git rebase master
  fi
  ###
else
  cd ${SUBDIR}
  git clone https://git.llvm.org/git/${PROJ}.git
  cd ${PROJ_DIR}
  git svn init https://llvm.org/svn/llvm-project/${PROJ}/trunk --username=dhinton
  git config svn-remote.svn.fetch :refs/remotes/origin/master
  git svn rebase -l  # -l avoids fetching ahead of the git mirror.
fi

# clang
PROJ=clang
SUBDIR=${ROOT_DIR}/llvm/tools
PROJ_DIR=${SUBDIR}/${PROJ}
if [ -d ${PROJ_DIR} ] ; then
  cd ${PROJ_DIR} 
  MSG=$(git stash)
  BRANCH=$(git rev-parse --abbrev-ref HEAD)
  ${ROOT_DIR}/llvm/utils/git-svn/git-svnup
  if [ "$MSG" != "No local changes to save" ]; then
    git stash pop
	fi
  if [ "$BRANCH" != "master" ]; then
    git rebase master
  fi
else
  cd ${SUBDIR}
  git clone https://git.llvm.org/git/${PROJ}.git
  cd ${PROJ_DIR}
  git svn init https://llvm.org/svn/llvm-project/cfe/trunk --username=dhinton
  git config svn-remote.svn.fetch :refs/remotes/origin/master
  git svn rebase -l  # -l avoids fetching ahead of the git mirror.
fi
