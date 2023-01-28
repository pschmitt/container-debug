#!/usr/bin/env sh

set -ex

kubectl_latest() {
  wget -O - https://storage.googleapis.com/kubernetes-release/release/stable.txt
}

kubectl_arch() {
  case "$(uname -m)" in
    x86_64)
      echo "amd64"
      ;;
    arm64|aarch64)
      echo "arm64"
      ;;
    arm*)
      echo "arm"
      ;;
    ppc*)
      echo "ppc64le"
      ;;
    s3*)
      echo "s390x"
      ;;
    *)
      echo "Unsupported architecture $(uname -m)" >&2
      exit 1
      ;;
  esac
}

KUBECTL_VERSION="${KUBECTL_VERSION:-$(kubectl_latest)}"
KUBECTL_ARCH="${KUBECTL_ARCH:-$(kubectl_arch)}"
URL="https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"

echo "Downloading kubectl ${KUBECTL_VERSION} (${KUBECTL_ARCH}) from ${URL} ..."

wget -O /usr/local/bin/kubectl "$URL"
chmod +x /usr/local/bin/kubectl
