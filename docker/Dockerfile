# start from base
FROM ubuntu:xenial

# Build like this:
# docker build <path to dir containing this file>

# In order to run gdb, you need to run this image like this:
# docker run --privileged -it <image>

RUN set -ex; apt-get -yqq update; apt-get -yqq upgrade
RUN set -ex; apt-get -yqq install \
  sudo \
  build-essential \
  ninja-build \
  libedit-dev \
  python2.7-dev \
  curl \
  wget \
  emacs \
  git \
  gdb \
  man

# 4096R/345AD05D 2015-01-20 Hans Wennborg <hans@chromium.org>
# 2048R/02119294 2014-05-06 Tom Stellard <tstellar@redhat.com>
# 2048R/BB5A0569 2013-12-24 Bill Wendling <void@llvm.org>
# 4096R/7BFB4EDA 2014-06-16 Brad King <brad.king@kitware.com>
ENV GPG_KEYS \
  B6C8F98282B944E3B0D5C2530FC3042E345AD05D \
  11E521D646982372EB577A1F8F0871F202119294 \
  54E3BDE33185D9F69664D22455F5CD70BB5A0569 \
  CBA23971357C2E6590D9EFD3EC8FEF3A7BFB4EDA

RUN set -ex; \
  for key in $GPG_KEYS; do \
    gpg --keyserver hkp://ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done

RUN set -ex; \
  curl -fSL https://cmake.org/files/v3.7/cmake-3.7.2-SHA-256.txt -o cmake-3.7.2-SHA-256.txt; \
  curl -fSL https://cmake.org/files/v3.7/cmake-3.7.2-SHA-256.txt.asc -o cmake-3.7.2-SHA-256.txt.asc; \
  curl -fSL https://cmake.org/files/v3.7/cmake-3.7.2-Linux-x86_64.tar.gz -o cmake-3.7.2-Linux-x86_64.tar.gz; \
  gpg --verify cmake-3.7.2-SHA-256.txt.asc; \
  grep cmake-3.7.2-Linux-x86_64.tar.gz cmake-3.7.2-SHA-256.txt | sha256sum --check; \
  tar -xf cmake-3.7.2-Linux-x86_64.tar.gz -C /usr/local --strip-components=1; \
  rm cmake-3.7.2-*;

RUN set -ex; \
  git clone https://github.com/donhinton/misc.git; \
	misc/scripts/deploy_dotfiles.sh

# setup user
RUN set -ex; \
  useradd -m dhinton; \
  echo 'dhinton  ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers;

USER dhinton
WORKDIR /home/dhinton

# FIXME: Break this out into it's own Dockerfile, so I can run build
# with '--no-cache' for just the clang/llvm part
# setup clang+llvm dev environment
RUN set -ex; \
  git clone https://github.com/donhinton/misc.git; \
  misc/scripts/deploy_dotfiles.sh; \
  mkdir llvm_project; \
  git clone https://git.llvm.org/git/llvm.git llvm_project/llvm; \
  git clone https://git.llvm.org/git/clang.git llvm_project/llvm/tools/clang;
