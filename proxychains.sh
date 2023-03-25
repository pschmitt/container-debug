#!/usr/bin/env bash

# Documentation:
# https://github.com/rofl0r/proxychains-ng/blob/master/src/proxychains.conf

usage() {
  echo "Usage: $(basename "$0") [ARGS] -- COMMAND"
  echo
  echo "ARGS:"
  echo
  echo "      --hostname, -H   Proxy hostname/IP [localhost] (\$PROXYCHAINS_HOSTNAME)"
  echo "      --port,     -P   Proxy port        [1080]      (\$PROXYCHAINS_PORT)"
  echo "      --username, -u   Proxy username    [N/A]       (\$PROXYCHAINS_USERNAME)"
  echo "      --password, -p   Proxy password    [N/A]       (\$PROXYCHAINS_PASSWORD)"
  echo
  echo "Examples:"
  echo
  echo "\$ $(basename "$0") --host tnl.default.svc.cluster.local --port 1080 -- curl ipinfo.io"
}

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

  if ! is_ip "$proxy_hostname"
  then
    proxy_hostname="$(resolve "$proxy_hostname")"
  fi

  cat << EOF > "$CONFIG_FILE"
strict_chain

[ProxyList]
socks5 ${proxy_hostname} ${proxy_port} ${proxy_username} ${proxy_password}
EOF
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  if [[ -z "$1" ]]
  then
    usage >&2
    exit 2
  fi

  while [[ -n "$*" ]]
  do
    case "$1" in
      -h|--help)
        usage
        exit 0
        ;;
      --host|--hostname|-H)
        PROXYCHAINS_HOSTNAME="$2"
        shift 2
        ;;
      --port|-P)
        PROXYCHAINS_PORT="$2"
        shift 2
        ;;
      --username|--user|-u)
        PROXYCHAINS_USERNAME="$2"
        shift 2
        ;;
      --password|--pass|-p)
        PROXYCHAINS_PASSWORD="$2"
        shift 2
        ;;
      --)
        break
        ;;
      *)
        break
        ;;
    esac
  done

  CONFIG_FILE="$(mktemp -t proxychains_XXXXXX)"
  trap 'rm -rf $CONFIG_FILE' EXIT

  write_config

  if [[ -n "$PROXY_DEBUG" ]]
  then
    cat "$CONFIG_FILE"
  fi

  proxychains -f "$CONFIG_FILE" "$@"
fi
