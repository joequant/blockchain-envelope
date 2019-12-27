#!/bin/bash
export GITEA_WORK_DIR=/var/lib/gitea/
pushd $HOME
BLOCK=${BLOCK:-ganache}
if [[ $BLOCK = "geth" ]] ; then
    geth --datadir $HOME/data/geth \
		  --networkid 15 --rpc >> \
		  data/logs/geth.log 2>&1 &
else
    ganache-cli --db $HOME/data/ganache \
			 -i="5777" \
			 -d \
			 --mnemonic="myth like bonus scare over problem client lizard pioneer submit female collect" \
			 >> data/logs/ganache.log 2>&1 &
fi

pushd code/blockchain-envelope
pushd server
node --experimental-modules ./graphql-server.mjs >> $HOME/data/logs/graphql-server.log 2>&1 &
popd
pushd client
pnpm run start &
popd
popd

if [[ -n "$IPFS_URI" ]]; then
    jsipfs daemon >> data/logs/ipfs.log 2>&1 &
fi

gitea web  -c $HOME/code/blockchain-envelope/server/gitea.ini >> data/logs/gitea.log &
exec /bin/bash
popd
