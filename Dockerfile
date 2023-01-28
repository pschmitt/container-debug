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
  py3-pip \
  yq && \
  kubectl_version=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt) && \
  curl -fsSL "https://storage.googleapis.com/kubernetes-release/release/${kubectl_version}/bin/linux/amd64/kubectl" > /usr/local/bin/kubectl && \
  chmod +x /usr/local/bin/kubectl && \
  echo "source /etc/profile" > /root/.profile

COPY ./aliases /etc/profile.d/aliases.sh

CMD ["/bin/bash"]
