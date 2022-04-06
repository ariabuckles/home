#!/bin/sh
printf 'nextdns link-ip url (leave empty to leave as-is): '
read -r url
if test -n "$url"; then
  cat aria-link-nextdns-public.service | NEXTDNS_LINK_IP_URL="$url" envsubst > /etc/systemd/system/aria-link-nextdns-public.service
fi
