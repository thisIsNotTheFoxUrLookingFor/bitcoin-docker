fulcrumVersion="v1.11.0"
fulcrumArm="Fulcrum-1.11.0-arm64-linux.tar.gz"
fulcrumAmd64="Fulcrum-1.11.0-x86_64-linux.tar.gz"
fulcrumShaSums="Fulcrum-1.11.0-shasums"

# download Fulcrum
arch="$(dpkg --print-architecture)"
case "$arch" in \arm64)
  curl -fsSLO https://github.com/cculianu/Fulcrum/releases/download/${fulcrumVersion}/${fulcrumArm} ;;
\amd64)
  curl -fsSLO https://github.com/cculianu/Fulcrum/releases/download/${fulcrumVersion}/${fulcrumAmd64} ;;
esac;

# get hashes and signed hashes for Fulcrum
curl -fsSL https://github.com/cculianu/Fulcrum/releases/download/${fulcrumVersion}/${fulcrumShaSums}.txt -o fhashes
curl -fsSL https://github.com/cculianu/Fulcrum/releases/download/${fulcrumVersion}/${fulcrumShaSums}.txt.asc -o fhashes.asc

# fetch, import and trust Fulcrum signing gpg key
curl -fsSL https://fulcrumserver.org/calinkey.txt -o sign_key.asc
gpg --import sign_key.asc
gpg --list-keys --fingerprint --with-colons | sed -E -n -e 's/^fpr:::::::::([0-9A-F]+):$/\1:6:/p' | gpg --import-ownertrust

# verify that Fulcrum matches a signed hash and the hash is legitimately signed
gpg --keyid-format long --verify fhashes.asc fhashes
sha256sum -c --ignore-missing fhashes

# clean up hashes and gpg keys
echo "verified signed archive"
rm fhashes
rm fhashes.asc
rm sign_key.asc
sleep 10

# extract Fulcrum
case "$arch" in \arm64)
  tar -xvf ${fulcrumArm} --strip-component=1 -C /usr/local/bin/
  rm ${fulcrumArm} ;;
\amd64)
  tar -xvf ${fulcrumAmd64} --strip-component=1 -C /usr/local/bin/
  rm ${fulcrumAmd64} ;;
esac;
echo "Fulcrum is installed!"
