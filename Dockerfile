FROM alpine:latest

LABEL MAINTAINER "Philipp Schmitt <philipp@schmitt.co>"

RUN apk add --no-cache \
  bash \
  bind-tools \
  curl \
  fping \
  git \
  iproute2 \
  jq \
  neovim \
  netcat-openbsd \
  nmap \
  openssh \
  openssl \
  python3 \
  py3-pip && \
  echo "source /etc/profile" > /root/.profile

COPY ./aliases /etc/profile.d/aliases.sh

CMD ["/bin/bash"]
