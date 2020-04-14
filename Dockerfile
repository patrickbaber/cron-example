FROM alpine:3.11
LABEL maintainer="Patrick Baber <patrick.baber@servivum.com>"

# Install DNS client
RUN apk add --no-cache bash && \
    mkdir -p /usr/src && \
    cd /usr/src && \
    wget http://io.regfish.de/downloads/dyndns/regfish.com_dynDNSv2_wget.tar.gz && \
    tar xzf regfish.com_dynDNSv2_wget.tar.gz && \
    mv regfish.com_dynDNSv2_wget/regfish_* /usr/local/bin && \
    rm -rf /usr/src

# Copy custom script
COPY regfish_ipcheck2.sh /usr/local/bin

# Configure cron
COPY crontab /etc/cron/crontab

# Init cron
RUN crontab /etc/cron/crontab

CMD ["crond", "-f"]