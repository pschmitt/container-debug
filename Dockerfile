FROM alpine:latest

LABEL MAINTAINER "Philipp Schmitt <philipp@schmitt.co>"

RUN \
  echo "@testing https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
  apk add --no-cache \
    bash \
    bind-tools \
    curl \
    fping \
    git \
    iproute2 \
    jq \
    kubectl@testing \
    neovim \
    netcat-openbsd \
    nmap \
    openssh \
    openssl \
    python3 \
    py3-pip \
    yq && \
  echo "source /etc/profile" > /root/.profile

COPY ./aliases /etc/profile.d/aliases.sh

CMD ["/bin/bash"]
