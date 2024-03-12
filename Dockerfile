FROM alpine:latest as kubectl

COPY ./install-kubectl.sh /install-kubectl.sh

RUN /install-kubectl.sh

FROM alpine:latest
LABEL MAINTAINER "Philipp Schmitt <philipp@schmitt.co>"

COPY --from=kubectl /usr/local/bin/kubectl /usr/local/bin/kubectl

WORKDIR /root

RUN apk add --no-cache \
    bash \
    bind-tools \
    curl \
    fping \
    fuse3 \
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
    rclone \
    s3cmd \
    yq && \
  echo "source /etc/profile" > /root/.profile && \
  mkdir -p /root/.ssh /root/.config/rclone

COPY ./aliases /etc/profile.d/aliases.sh
COPY ./proxychains.sh /usr/local/bin/proxychains.sh

CMD ["/bin/bash"]
