FROM alpine:latest

LABEL MAINTAINER "Philipp Schmitt <philipp@schmitt.co>"

RUN apk add --no-cache \
  bash \
  git \
  iproute2 \
  neovim \
  nmap \
  openssh \
  python3 \
  py3-pip && \
  echo "source /etc/profile" > /root/.profile

COPY ./aliases /etc/profile.d/aliases.sh

ENTRYPOINT ["/bin/bash", "-l"]
