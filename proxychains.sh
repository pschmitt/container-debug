#!/usr/bin/env bash

# Documentation:
# https://github.com/rofl0r/proxychains-ng/blob/master/src/proxychains.conf

resolve() {
  # NOTE We eliminate lines matching # here because nslookup also outputs
  # the queried server
  nslookup -querytype=A -nofail "$1" | \
    awk -F ': +' '(!/#/ && /Address/) { print $2; exit }' | \
    grep '.'
}

# TODO IPv6 support
is_ip() {
  grep -qE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' <<< "$1"
}

# TODO Make DNS proxying optional
write_config() {
  # TODO extract host from all_proxy|http_proxy|https_proxy env vars
  local proxy_hostname="${PROXYCHAINS_HOSTNAME:-127.0.0.1}"
  local proxy_port="${PROXYCHAINS_PORT:-1080}"
  # optional
  local proxy_username="${PROXYCHAINS_USERNAME}"
  local proxy_password="${PROXYCHAINS_PASSWORD}"

  if ! is_ip "$proxy_host"
  then
    proxy_host="$(resolve "$proxy_host")"
  fi

  cat << EOF > "$CONFIG_FILE"
strict_chain

[ProxyList]
socks5 ${proxy_hostname} ${proxy_port} ${proxy_username} ${proxy_password}
EOF
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  CONFIG_FILE="$(mktemp -t proxychains_XXXXXX)"
  trap 'rm -rf $CONFIG_FILE' EXIT

  write_config

  if [[ -n "$PROXY_DEBUG" ]]
  then
    cat "$CONFIG_FILE"
  fi

  proxychains -f "$CONFIG_FILE" "$@"
fi
