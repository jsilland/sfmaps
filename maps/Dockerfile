FROM alpine:3.9

RUN apk add --no-cache curl gnupg

# Install mlr

RUN curl -SL https://github.com/johnkerl/miller/releases/download/5.4.0/mlr.linux.x86_64 -o /usr/bin/mlr && \
    chmod +x /usr/bin/mlr

# Install jq

ENV JQ_VERSION='1.6'
RUN curl -SL https://raw.githubusercontent.com/stedolan/jq/master/sig/jq-release.key -o /tmp/jq-release.key && \
    curl -SL https://raw.githubusercontent.com/stedolan/jq/master/sig/v${JQ_VERSION}/jq-linux64.asc -o /tmp/jq-linux64.asc && \
    curl -SL https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 -o /tmp/jq-linux64 && \
    gpg --import /tmp/jq-release.key && \
    gpg --verify /tmp/jq-linux64.asc /tmp/jq-linux64 && \
    cp /tmp/jq-linux64 /usr/bin/jq && \
    chmod +x /usr/bin/jq && \
    rm -f /tmp/jq-release.key && \
    rm -f /tmp/jq-linux64.asc && \
    rm -f /tmp/jq-linux64

# Application code

RUN mkdir -p /usr/app
WORKDIR /usr/app
COPY maps.sh maps.jq ./
COPY incidents ./incidents

# Building maps

ENTRYPOINT ["./maps.sh"]
