FROM debian:bookworm-slim AS build

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get upgrade -yq \
  && apt-get -yq install build-essential libtool autotools-dev automake pkg-config bsdmainutils python3 libevent-dev libboost-dev libsqlite3-dev net-tools \
  git dnsutils htop wget curl libminiupnpc-dev libnatpmp-dev libzmq3-dev systemtap-sdt-dev \
  && git clone https://github.com/tortxoFFoxtrot/bitcoin.git && cd bitcoin && ./autogen.sh && ./configure --disable-wallet --without-gui \
  && make -j 8 && make install

WORKDIR /scripts

COPY scripts /scripts

RUN chmod 555 /scripts/start.sh

CMD /scripts/start.sh
