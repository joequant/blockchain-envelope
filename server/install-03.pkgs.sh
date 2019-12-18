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

cp /tmp/startup.sh /home/user/data
cp /tmp/CustomGenesis.json /home/user/data
cp /tmp/test-system.sh /home/user/data

chmod a+x /home/user/data/startup.sh
geth --datadir /home/user/data/geth \
     init /home/user/data/CustomGenesis.json

cp /tmp/graphql-server.mjs /home/user/data
cp /tmp/package.json /home/user/data
pushd data
npm install -g --unsafe-perm=true --allow-root --verbose
npm install -g --unsafe-perm=true --allow-root --verbose ganache-cli \
    truffle ipfs
pushd /usr/lib/node_modules
modclean -r -f
popd
pushd node_modules
modclean -r -f
popd
jsipfs init
popd

usermod -aG wheel user
chown -R user:user /home/user
cat <<EOF >> /etc/sudoers
%wheel        ALL=(ALL)       NOPASSWD: ALL
EOF

#: '
# Gitea install
cp /tmp/gitea.ini /home/user/data
pushd /usr/local/bin
curl https://dl.gitea.io/gitea/1.10.1/gitea-1.10.1-linux-amd64 > gitea
chmod +x gitea
popd

mkdir -p /var/lib/gitea/{custom,data,log}
chown -R user:user /var/lib/gitea/
chmod -R 750 /var/lib/gitea/
#:'

: '
# Gogs install
pushd /var/lib
curl https://dl.gogs.io/0.11.91/gogs_0.11.91_linux_amd64.tar.gz | tar -C /var/lib -xzf -
pushd /usr/local/bin
ln -s ../../../var/lib/gogs/gogs .
popd
popd
:'
