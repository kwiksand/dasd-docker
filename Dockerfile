FROM quay.io/kwiksand/cryptocoin-base:latest

RUN useradd -m das

ENV DAEMON_RELEASE="DAS-v0.12.1.5"
ENV DAS_DATA=/home/das/.das

USER das

RUN cd /home/das && \
    mkdir /home/das/bin && \
    echo "\n# Some aliases to make the das clients/tools easier to access\nalias dasd='/usr/bin/dasd -conf=/home/das/.das/das.conf'\nalias das-cli='/usr/bin/das-cli -conf=/home/das/.das/das.conf'\n" >> /home/das/.bashrc && \
    mkdir .ssh && \
    chmod 700 .ssh && \
    ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts && \
    ssh-keyscan -t rsa bitbucket.org >> ~/.ssh/known_hosts && \
    git clone --branch $DAEMON_RELEASE https://github.com/Truckman83/DAS-source.git dasd && \
    cd /home/das/dasd && \
    ./autogen.sh && \
    ./configure LDFLAGS="-L/home/das/db4/lib/" CPPFLAGS="-I/home/das/db4/include/" && \
    make && \
    strip src/dasd && \
    strip src/das-cli && \
    strip src/das-tx && \
    mv src/dasd src/das-cli src/das-tx /home/das/bin && \
    rm -rf /home/das/dasd
    
EXPOSE 9378 9399

#VOLUME ["/home/das/.das"]

USER root

COPY docker-entrypoint.sh /entrypoint.sh

RUN chmod 777 /entrypoint.sh && \
    echo "\n# Some aliases to make the das clients/tools easier to access\nalias dasd='/usr/bin/dasd -conf=/home/das/.das/das.conf'\nalias das-cli='/usr/bin/das-cli -conf=/home/das/.das/das.conf'\n\n[ ! -z \"\$TERM\" -a -r /etc/motd ] && cat /etc/motd" >> /etc/bash.bashrc && \
    echo "Das (DAS) Cryptocoin Daemon\n\nUsage:\n das-cli help - List help options\n das-cli listtransactions - List Transactions\n\n" > /etc/motd && \
    chmod 755 /home/das/bin/dasd && \
    chmod 755 /home/das/bin/das-cli && \
    chmod 755 /home/das/bin/das-tx && \
    mv /home/das/bin/dasd /usr/bin/dasd && \
    mv /home/das/bin/das-cli /usr/bin/das-cli && \
    mv /home/das/bin/das-tx /usr/bin/das-tx

ENTRYPOINT ["/entrypoint.sh"]

CMD ["dasd"]
