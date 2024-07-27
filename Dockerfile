FROM ubuntu:latest AS build

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get upgrade -yq \
  && apt-get -yq install build-essential libtool autotools-dev automake pkg-config bsdmainutils python3 libevent-dev libboost-dev libsqlite3-dev net-tools \
  git dnsutils htop wget curl libminiupnpc-dev libnatpmp-dev libzmq3-dev systemtap-sdt-dev psmisc tor torsocks nano sudo \
  && git clone https://github.com/bitcoin/bitcoin.git && cd bitcoin && git checkout v27.1 && ./autogen.sh && ./configure --disable-wallet --without-gui \
  && make -j 8 && make install && cd .. && rm -rf bitcoin 

RUN echo "HiddenServiceDir /tor/bitcoin-service\nHiddenServicePort 8333 127.0.0.1:8334" >> /etc/tor/torrc

ENTRYPOINT ["sh","/config/init.sh"]
