ARG base
FROM mageia:7
LABEL maintainer="Joseph C Wang <joequant@gmail.com>"

COPY install-01.rpm.sh proxy.sh /tmp/
RUN source /tmp/install-01.rpm.sh ; rm /tmp/*.sh
FROM scratch
WORKDIR /
COPY --from=0 / .
COPY install-02.git.sh proxy.sh /tmp/
RUN source /tmp/install-02.git.sh ; rm /tmp/*.sh
COPY install-03.pkgs.sh proxy.sh startup.sh CustomGenesis.json \
     test-system.sh gitea.ini \
     graphql-server.mjs package.json /tmp/
RUN source /tmp/install-03.pkgs.sh ; rm /tmp/*.sh