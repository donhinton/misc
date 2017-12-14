# start from base
FROM gcc:6

# Build like this:
# docker build [-t <name:tag>] --build-arg user=${USER} <path to dir containing this file>

# In order to run gdb, you need to run this image like this:
# docker run [-v <hostdir>:/home/${USER}/<containerdir>] --privileged -it <image>

# Access <hostdir> as /home/${USER}/<containerdir> via the '-v' option

# Require "--build-arg user=<some user>" was passed.
ARG user
RUN test -n "${user}"
ENV user ${user}

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

RUN \
  set -ex; \
  apt-get -yqq update; \
  apt-get -yqq upgrade; \
  apt-get -yqq install \
  sudo \
  gcc-multilib \
  g++-multilib \
  libedit-dev \
  python2.7-dev \
  curl \
  wget \
  emacs \
  git-svn \
  gdb \
  man; \
  #apt-get -yqq clean; \
  #rm -rf /var/lib/apt/lists/*; \
  \
  curl -fSL https://cmake.org/files/v3.9/cmake-3.9.0-SHA-256.txt -o cmake-3.9.0-SHA-256.txt; \
  curl -fSL https://cmake.org/files/v3.9/cmake-3.9.0-SHA-256.txt.asc -o cmake-3.9.0-SHA-256.txt.asc; \
  curl -fSL https://cmake.org/files/v3.9/cmake-3.9.0-Linux-x86_64.tar.gz -o cmake-3.9.0-Linux-x86_64.tar.gz; \
  gpg --verify cmake-3.9.0-SHA-256.txt.asc; \
  grep cmake-3.9.0-Linux-x86_64.tar.gz cmake-3.9.0-SHA-256.txt | sha256sum --check; \
  tar -xf cmake-3.9.0-Linux-x86_64.tar.gz -C /usr/local --strip-components=1; \
  rm cmake-3.9.0-*;

# apt-get version of ninja, 1.3.4, segfaults with certain llvm
# configurations, so we build latest, 1.8.2.
RUN \
  set -ex; \
  git clone git://github.com/ninja-build/ninja.git && cd ninja; \
  git checkout release; \
  ./configure.py --bootstrap; \
  sudo cp ninja /usr/local/bin/

# setup user
RUN set -ex; \
  useradd -m ${user}; \
  echo "${user}  ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers;

USER ${user}
WORKDIR /home/${user}

RUN set -ex; \
  git clone https://github.com/donhinton/misc.git; \
  misc/scripts/deploy_dotfiles.sh; \
  sudo su - -c "/home/dhinton/misc/scripts/deploy_dotfiles.sh"
