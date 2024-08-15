#!/bin/bash

bitcoinVersion="bitcoin-core-27.1"
bitcoinArm="bitcoin-27.1-aarch64-linux-gnu.tar.gz"
bitcoinAmd64="bitcoin-27.1-x86_64-linux-gnu.tar.gz"

# get bitcoin core
arch="$(dpkg --print-architecture)";
case "$arch" in \arm64)
  curl -fsSLO https://bitcoincore.org/bin/${bitcoinVersion}/${bitcoinArm} ;;
\amd64)
  curl -fsSLO https://bitcoincore.org/bin/${bitcoinVersion}/${bitcoinAmd64} ;;
esac;

# fetch, import and trust bitcoin core signing gpg keys
curl -fsSL https://raw.githubusercontent.com/tortxoFFoxtrot/bitcoin-docker/main/bitcoincore-signers.txt  -o  keys.txt;
while read line;
do
  gpg  --keyserver keyserver.ubuntu.com  --recv-key ${line:0:41};
done < keys.txt;
gpg --list-keys --fingerprint --with-colons | sed -E -n -e 's/^fpr:::::::::([0-9A-F]+):$/\1:6:/p' | gpg --import-ownertrust

# get hashes and signed hashes for bitcoin core
curl -fsSL https://bitcoincore.org/bin/${bitcoinVersion}/SHA256SUMS -o bhashes
curl -fsSL https://bitcoincore.org/bin/${bitcoinVersion}/SHA256SUMS.asc -o bhashes.asc

# verify that bitcoin core matches a signed hash and the hash is legitimately signed
gpg --keyid-format long --verify bhashes.asc bhashes
sha256sum -c --ignore-missing bhashes
echo "verified signed archive"

# clean up hashes and gpg keys
rm keys.txt
rm bhashes.asc
rm bhashes
sleep 10

# extract bitcoin core
mkdir bitcoin-bins
case "$arch" in \arm64)
  tar -xvf ${bitcoinArm} --strip-component=1 -C bitcoin-bins
  rm -rf ${bitcoinArm} ;;
\amd64)
  tar -xvf ${bitcoinAmd64} --strip-component=1 -C bitcoin-bins
  rm -rf ${bitcoinAmd64} ;;
esac;
cp bitcoin-bins/bin/bitcoind /usr/local/bin/bitcoind
cp bitcoin-bins/bin/bitcoin-cli /usr/local/bin/bitcoin-cli
cp bitcoin-bins/bin/bitcoin-util /usr/local/bin/bitcoin-util
cp bitcoin-bins/bin/bitcoin-tx /usr/local/bin/bitcoin-tx
cp bitcoin-bins/bin/bench_bitcoin /usr/local/bin/bench_bitcoin
rm -rf bitcoin-bins
echo "Bitcoin is installed!"
