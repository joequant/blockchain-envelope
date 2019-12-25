#!/bin/bash
# These are all of the packages that need to be installed before bootstrap
# is run
set -e -v

source /tmp/proxy.sh
export HOME=/home/user
echo "ZONE=UTC" > /etc/sysconfig/clock
export TZ="UTC"
useradd user
chmod a+rx ~user
echo 'cubswin:)' | passwd user --stdin
echo 'cubswin:)' | passwd root --stdin

if [[ ! -z "$http_proxy" ]] ; then
    git config --global http.proxy $http_proxy
    if [[ ! -z "$GIT_PROXY" ]] ; then
	git config --global url."$GIT_PROXY".insteadOf https://
    fi
    git config --global http.sslVerify false
fi

npm install -g --unsafe-perm=true --allow-root --verbose --production pnpm
pnpm install -g --production modclean
pnpm config set prefix /usr

cd ~user
mkdir code
pushd code

git clone https://github.com/joequant/tea --depth=1
pushd tea
go build
mv tea /usr/bin
popd
rm -rf tea

git clone https://github.com/joequant/gitea --depth=1
pushd gitea
for i in options public templates; do 
   pushd modules/$i
   go run -mod=vendor main.go
   popd
done
TAGS="bindata sqlite sqlite_unlock_notify pam" make build
mv gitea /usr/bin
popd
rm -rf gitea

git clone https://github.com/git-lfs/git-lfs --depth=1
pushd git-lfs
make
mv bin/git-lfs /usr/bin
popd
git lfs install
rm -rf git-lfs

git clone https://github.com/joequant/git-lfs-ipfs --depth=1
pushd git-lfs-ipfs/git-lfs-ipfs-cli
cargo build --release
popd

git clone https://github.com/ethereum/go-ethereum.git --depth=1
pushd go-ethereum
make geth
mv build/bin/geth /usr/bin
popd
rm -rf go-ethereum

git clone https://github.com/joequant/mango-admin.git -b dev/work --depth=1
pushd mango-admin
pnpm install -g --production
pushd /usr/lib/node_modules
modclean -r -f
popd
popd

git clone https://github.com/joequant/git-remote-mango.git --depth=1
pushd git-remote-mango
pnpm install -g --production
pushd /usr/lib/node_modules
modclean -r -f
popd
pushd /usr/bin
ln -s ../../home/user/code/git-remote-mango/git-remote-mango .
popd

#pushd go-ipfs
#mv cmd/ipfs/ipfs /usr/bin
#popd
popd

git config --unset --global http.proxy || true
git config --unset --global http.sslVerify || true
git config --unset --global url."$GIT_PROXY".insteadOf || true

