FROM buildpack-deps:trusty

ENV NODE_VERSION 0.10.40
ENV NPM_VERSION 2.14.1
ENV ZMQ_VERSION 4.0.4

# based upon https://raw.githubusercontent.com/nodejs/docker-node/d798690bdae91174715ac083e31198674f044b68/0.10/Dockerfile
RUN set -ex \
    && for key in \
        7937DFD2AB06298B2293C3187D33FF9D0246406D \
        114F43EE0176B71C7BC219DD50A3051F888C628D \
    ; do \
        gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
    done


RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
    && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
    && gpg --verify SHASUMS256.txt.asc \
    && grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
    && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
    && rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc \
    && npm install -g npm@"$NPM_VERSION" \
    && npm cache clear



# time to install zmq
RUN curl -SLO "http://download.zeromq.org/zeromq-$ZMQ_VERSION.tar.gz" \
    && tar xvf zeromq-$ZMQ_VERSION.tar.gz \
    && cd zeromq-$ZMQ_VERSION \
    && ./configure \
    && make \
    && make install \
    && cd .. \
    && rm -r zeromq-$ZMQ_VERSION \
    && rm zeromq-$ZMQ_VERSION.tar.gz
RUN ldconfig

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD [ "node" ]
