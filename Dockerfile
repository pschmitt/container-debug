# hadolint ignore=DL3007
FROM alpine:latest AS kubectl

COPY ./install-kubectl.sh /install-kubectl.sh

RUN /install-kubectl.sh

# hadolint ignore=DL3007
FROM alpine:latest

# https://github.com/opencontainers/image-spec/blob/main/annotations.md
LABEL org.opencontainers.image.authors="Philipp Schmitt <philipp@schmitt.co>"
LABEL org.opencontainers.image.base.name="docker.io/library/alpine"
LABEL org.opencontainers.image.description="The last container you'll ever need for debugging"
LABEL org.opencontainers.image.documentaion="https://github.com/pschmitt/container-debug"
LABEL org.opencontainers.image.licenses="GPL-3.0-or-later"
LABEL org.opencontainers.image.source="https://github.com/pschmitt/container-debug"
LABEL org.opencontainers.image.title="pschmitt's debug container"
LABEL org.opencontainers.image.url="https://github.com/pschmitt/container-debug"

COPY --from=kubectl /usr/local/bin/kubectl /usr/local/bin/kubectl

WORKDIR /root

# hadolint ignore=DL3018
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
    websocat \
    yq && \
  echo "source /etc/profile" > /root/.profile && \
  mkdir -p /root/.ssh /root/.config/rclone

COPY ./aliases /etc/profile.d/aliases.sh
COPY ./proxychains.sh /usr/local/bin/proxychains.sh

CMD ["/bin/bash"]
