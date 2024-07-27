FROM ubuntu:latest AS build

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get upgrade -yq \
  && apt-get -yq install build-essential libtool autotools-dev automake pkg-config bsdmainutils python3 libevent-dev libboost-dev libsqlite3-dev net-tools \
  git dnsutils htop libminiupnpc-dev libnatpmp-dev libzmq3-dev systemtap-sdt-dev psmisc sudo nano \
  && git clone https://github.com/bitcoin/bitcoin.git && cd bitcoin && git checkout v27.1 && ./autogen.sh && ./configure --disable-wallet --without-gui \
  && make -j 8 && make install && cd .. && rm -rf bitcoin 

ENTRYPOINT ["sh","/config/init.sh"]
