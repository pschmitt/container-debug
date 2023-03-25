FROM alpine:latest as kubectl

COPY ./install-kubectl.sh /install-kubectl.sh

RUN /install-kubectl.sh

FROM alpine:latest
LABEL MAINTAINER "Philipp Schmitt <philipp@schmitt.co>"

COPY --from=kubectl /usr/local/bin/kubectl /usr/local/bin/kubectl

RUN \
  apk add --no-cache \
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
    proxychains-ng \
    python3 \
    py3-pip \
    yq && \
  echo "source /etc/profile" > /root/.profile

COPY ./aliases /etc/profile.d/aliases.sh

CMD ["/bin/bash"]
