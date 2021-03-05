FROM amazon/aws-cli:latest

# Fix frontend not set error
ARG DEBIAN_FRONTEND=noninteractive

# Install gosu
ENV GOSU_VERSION=1.12
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && curl -o /usr/sbin/gosu -SL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64" \
    && curl -o /usr/sbin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64.asc" \
    && gpg --verify /usr/sbin/gosu.asc \
    && rm /usr/sbin/gosu.asc \
    && rm -r /root/.gnupg/ \
    && chmod +x /usr/sbin/gosu \
    # Verify that the binary works
    && gosu nobody true

# Make working directory
ENV WORK_DIR=/work
RUN mkdir ${WORK_DIR}

# Set Entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Confirm aws-cli version
RUN aws --version
