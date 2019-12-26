#!/bin/bash
# These are all of the packages that need to be installed before bootstrap
# is run
set -e -v

source /tmp/proxy.sh

echo "ZONE=UTC" > /etc/sysconfig/clock
export TZ="UTC"
export HOME=/home/user
export IPFS_PATH=/home/user/data/jsipfs

cd /home/user

mkdir data
mkdir data/logs
mkdir data/ganache
mkdir repo

pushd code
  git clone https://github.com/joequant/blockchain-envelope --depth=1
  pushd blockchain-envelope
    pushd server
      npm install -g --unsafe-perm=true --allow-root --verbose --production
      pushd /usr/lib/node_modules
        modclean -r -f
      popd
    popd
    pushd client
      npm install -g --unsafe-perm=true --allow-root --verbose --production
      npm run build
      pushd node_modules
        modclean -r -f
      popd
    popd
  popd
popd    
geth --datadir /home/user/data/geth \
     init /home/user/code/blockchain-envelope/server/CustomGenesis.json

pushd data

npm install -g --unsafe-perm=true --allow-root --verbose --production \
    ganache-cli ipfs
pushd /usr/lib/node_modules
modclean -r -f
popd
jsipfs init
popd

#: '
# Gitea install
mkdir -p /var/lib/gitea/{custom,data,log}
chown -R user:user /var/lib/gitea/
chmod -R 750 /var/lib/gitea/
#:'

usermod -aG wheel user
chown -R user:user /home/user
cat <<EOF >> /etc/sudoers
%wheel        ALL=(ALL)       NOPASSWD: ALL
EOF

: '
# Gogs install
pushd /var/lib
curl https://dl.gogs.io/0.11.91/gogs_0.11.91_linux_amd64.tar.gz | tar -C /var/lib -xzf -
pushd /usr/local/bin
ln -s ../../../var/lib/gogs/gogs .
popd
popd
:'
