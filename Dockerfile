FROM ubuntu:latest AS build

# Bitcoin
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get upgrade -yq && apt remove openssh-client -yq \
  && apt-get -yq install build-essential libtool autotools-dev automake pkg-config bsdmainutils python3 libevent-dev libboost-dev libsqlite3-dev net-tools \
  git dnsutils htop libminiupnpc-dev libnatpmp-dev libzmq3-dev systemtap-sdt-dev psmisc sudo nano iptables iproute2 ufw tor torsocks gpg wget supervisor\
  && git clone https://github.com/bitcoin/bitcoin.git && cd bitcoin && git checkout v27.1 && ./autogen.sh && ./configure --disable-wallet --without-gui \
  && make -j 8 && make install && cd .. && rm -rf bitcoin \
# Fulcrum
  && arch="$(dpkg --print-architecture)"; case "$arch" in \arm64) wget https://github.com/cculianu/Fulcrum/releases/download/v1.11.0/Fulcrum-1.11.0-arm64-linux.tar.gz ;; \
  \amd64) wget https://github.com/cculianu/Fulcrum/releases/download/v1.11.0/Fulcrum-1.11.0-x86_64-linux.tar.gz ;; esac; \
  wget -O hashes https://github.com/cculianu/Fulcrum/releases/download/v1.11.0/Fulcrum-1.11.0-shasums.txt \
  && wget -O hashes.asc https://github.com/cculianu/Fulcrum/releases/download/v1.11.0/Fulcrum-1.11.0-shasums.txt.asc \
  && wget -O sign_key.asc https://fulcrumserver.org/calinkey.txt && gpg --import sign_key.asc \
  && gpg --list-keys --fingerprint --with-colons | sed -E -n -e 's/^fpr:::::::::([0-9A-F]+):$/\1:6:/p' | gpg --import-ownertrust \
  && gpg --keyid-format long --verify hashes.asc hashes && sha256sum -c --ignore-missing hashes && echo "verified signed archive" && sleep 10 \
  && case "$arch" in \arm64) tar -xvf Fulcrum-1.11.0-arm64-linux.tar.gz --strip-components=1 ;; \
  \amd64) tar -xvf Fulcrum-1.11.0-x86_64-linux.tar.gz --strip-components=1 ;; esac;

ENTRYPOINT ["sh","/config/init.sh"]
