#!/usr/bin/env bash

usage() {
  echo "Usage: $0"
}

array_join() {
  local IFS="$1"
  shift
  echo "$*"
}

get_available_architectures() {
  local image="$1"
  local tag="${2:-latest}"

  docker buildx imagetools inspect --raw "${image}:${tag}" | \
    jq -er '.manifests[] |
      .platform.os + "/" + .platform.architecture +
      (
        if (.platform | has("variant"))
        then
          "/" + .platform.variant
        else
          ""
        end
      )' | \
    sort
}

get_base_image() {
  sed -nr '0,/^FROM/{s/^FROM (([^:]+):([^ ]+).*)/\2 \3/gp}' Dockerfile
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  set -ex

  cd "$(readlink -f "$(dirname "$0")")" || exit 9

  read -r from tag <<< "$(get_base_image)"
  mapfile -t platforms < <(get_available_architectures "$from" "$tag")

  IMAGE_NAME="${IMAGE_NAME:-pschmitt/debug}"
  PUSH_IMAGE=true
  BUILD_TYPE=manual

  if [[ "$GITHUB_ACTIONS" == "true" ]]
  then
    BUILD_TYPE=github
  fi

  docker buildx build \
    --platform "$(array_join "," "${platforms[@]}")" \
    --output "type=image,push=${PUSH_IMAGE}" \
    --no-cache \
    --label=build-type="$BUILD_TYPE" \
    --label=built-by=pschmitt \
    --label=built-on="$HOSTNAME" \
    --tag "${IMAGE_NAME}:latest" \
    .
fi
