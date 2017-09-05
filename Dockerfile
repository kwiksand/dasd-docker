FROM quay.io/kwiksand/cryptocoin-base:latest

RUN useradd -m das

ENV DAS_DATA=/home/das/.das

USER das

RUN cd /home/das && \
    mkdir .ssh && \
    chmod 700 .ssh && \
    ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts && \
    ssh-keyscan -t rsa bitbucket.org >> ~/.ssh/known_hosts && \
    git clone https://github.com/Truckman83/DAS-source.git dasd && \
    cd /home/das/dasd && \
    ./autogen.sh && \
    ./configure LDFLAGS="-L/home/das/db4/lib/" CPPFLAGS="-I/home/das/db4/include/" && \
    make 
    
EXPOSE 59998 9999

#VOLUME ["/home/das/.das"]

USER root

COPY docker-entrypoint.sh /entrypoint.sh

RUN chmod 777 /entrypoint.sh && cp /home/das/dasd/src/das-cli /usr/bin/das-cli && chmod 755 /usr/bin/das-cli && \
    chmod 777 /entrypoint.sh && cp /home/das/dasd/src/das-tx /usr/bin/das-tx && chmod 755 /usr/bin/das-tx && \
    chmod 777 /entrypoint.sh && cp /home/das/dasd/src/dasd /usr/bin/dasd && chmod 755 /usr/bin/dasd

ENTRYPOINT ["/entrypoint.sh"]

CMD ["dasd"]
