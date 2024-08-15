FROM ubuntu:latest AS build

COPY bitcoin.sh /bitcoin.sh
COPY fulcrum.sh /fulcrum.sh

RUN DEBIAN_FRONTEND=noninteractive apt update && apt upgrade -yq \
  && apt install -yq git psmisc sudo iptables iproute2 ufw tor gpg curl supervisor

RUN ["bash","-c","/bitcoin.sh && rm /bitcoin.sh && ./fulcrum.sh && rm /fulcrum.sh"]

ENTRYPOINT ["sh","/config/init.sh"]
