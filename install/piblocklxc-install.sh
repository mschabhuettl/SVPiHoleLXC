#!/usr/bin/env bash

# Copyright (c) 2021-2024 tteck
# Copyright (c) 2024 mschabhuettl
# Author: tteck (tteckster), mschabhuettl
# License: MIT
# https://github.com/mschabhuettl/PiBlockLXC/raw/main/LICENSE

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get install -y curl
$STD apt-get install -y sudo
$STD apt-get install -y mc
$STD apt-get install -y ufw
$STD apt-get install -y ntp
msg_ok "Installed Dependencies"

msg_info "Installing Pi-hole"
mkdir -p /etc/pihole/
cat <<EOF >/etc/pihole/setupVars.conf
PIHOLE_INTERFACE=eth0
PIHOLE_DNS_1=8.8.8.8
PIHOLE_DNS_2=8.8.4.4
QUERY_LOGGING=true
INSTALL_WEB_SERVER=true
INSTALL_WEB_INTERFACE=true
LIGHTTPD_ENABLED=true
CACHE_SIZE=10000
DNS_FQDN_REQUIRED=true
DNS_BOGUS_PRIV=true
DNSMASQ_LISTENING=local
WEBPASSWORD=$(openssl rand -base64 48)
BLOCKING_ENABLED=true
EOF
# View script https://install.pi-hole.net
$STD bash <(curl -fsSL https://install.pi-hole.net) --unattended
msg_ok "Installed Pi-hole"

read -r -p "Would you like to add Unbound? <y/N> " prompt
if [[ ${prompt,,} =~ ^(y|yes)$ ]]; then
  msg_info "Installing Unbound"
  $STD apt-get install -y unbound
  cat <<EOF >/etc/unbound/unbound.conf.d/pi-hole.conf
server:
  verbosity: 0
  interface: 0.0.0.0
  port: 5335
  do-ip6: no
  do-ip4: yes
  do-udp: yes
  do-tcp: yes
  num-threads: 1
  hide-identity: yes
  hide-version: yes
  harden-glue: yes
  harden-dnssec-stripped: yes
  harden-referral-path: yes
  use-caps-for-id: no
  harden-algo-downgrade: no
  qname-minimisation: yes
  aggressive-nsec: yes
  rrset-roundrobin: yes
  cache-min-ttl: 300
  cache-max-ttl: 14400
  msg-cache-slabs: 8
  rrset-cache-slabs: 8
  infra-cache-slabs: 8
  key-cache-slabs: 8
  serve-expired: yes
  root-hints: /var/lib/unbound/root.hints
  serve-expired-ttl: 3600
  edns-buffer-size: 1232
  prefetch: yes
  prefetch-key: yes
  target-fetch-policy: "3 2 1 1 1"
  unwanted-reply-threshold: 10000000
  rrset-cache-size: 256m
  msg-cache-size: 128m
  so-rcvbuf: 1m
  private-address: 192.168.0.0/16
  private-address: 169.254.0.0/16
  private-address: 172.16.0.0/12
  private-address: 10.0.0.0/8
  private-address: fd00::/8
  private-address: fe80::/10
EOF
  mkdir -p /etc/dnsmasq.d/
  cat <<EOF >/etc/dnsmasq.d/99-edns.conf
edns-packet-max=1232
EOF
  wget -qO /var/lib/unbound/root.hints https://www.internic.net/domain/named.root
  sed -i -e 's/PIHOLE_DNS_1=8.8.8.8/PIHOLE_DNS_1=127.0.0.1#5335/' -e 's/PIHOLE_DNS_2=8.8.4.4/#PIHOLE_DNS_2=8.8.4.4/' /etc/pihole/setupVars.conf
  systemctl enable -q --now unbound
  systemctl restart pihole-FTL.service
  msg_ok "Installed Unbound"
fi

# Prompt user to decide whether to install pihole-updatelists
read -r -p "Would you like to add pihole-updatelists? <Y/n> " prompt
if [[ -z "$prompt" || ${prompt,,} =~ ^(y|yes)$ ]]; then
  # Displaying message about installing pihole-updatelists
  msg_info "Installing pihole-updatelists"
  
  # Installing necessary PHP packages
  $STD apt-get install -y php-cli php-sqlite3 php-intl php-curl sqlite3
  
  # Downloading and executing the installation script for pihole-updatelists
  wget -O - https://raw.githubusercontent.com/jacklul/pihole-updatelists/master/install.sh | bash
  
  # Disabling pihole's default updateGravity job in the cron.d/pihole to prevent conflicts
  sed -e '/pihole updateGravity/ s/^#*/#/' -i /etc/cron.d/pihole
  
  # Preparing a systemd override directory for pihole-FTL.service
  mkdir -p /etc/systemd/system/pihole-FTL.service.d
  
  # Creating an override config to pre-execute a command before pihole-FTL starts
  echo -e "[Service]\nExecStartPre=-/bin/sh -c '[ -w /etc/cron.d/pihole ] && /bin/sed -e \"/pihole updateGravity/ s/^#*/#/\" -i /etc/cron.d/pihole'" > /etc/systemd/system/pihole-FTL.service.d/override.conf
  
  # Preparing a systemd override directory for pihole-updatelists.timer
  mkdir -p /etc/systemd/system/pihole-updatelists.timer.d
  
  # Creating an override config for the timer to customize its schedule
  echo -e "[Timer]\nRandomizedDelaySec=5m\nOnCalendar=\nOnCalendar=*-*-* 03:00:00" > /etc/systemd/system/pihole-updatelists.timer.d/override.conf
  
  # Reloading systemd daemon to apply overrides and restarting pihole-FTL.service
  systemctl daemon-reload
  systemctl restart pihole-FTL.service
  
  # Downloading the configuration file for pihole-updatelists
  wget -O /etc/pihole-updatelists.conf https://raw.githubusercontent.com/mschabhuettl/PiBlockLXC/main/config/pihole-updatelists.conf
  
  # Cleaning up the gravity database by removing all adlists, domain lists, and their group associations
  sqlite3 /etc/pihole/gravity.db "DELETE FROM adlist"
  sqlite3 /etc/pihole/gravity.db "DELETE FROM adlist_by_group"
  sqlite3 /etc/pihole/gravity.db "DELETE FROM domainlist"
  sqlite3 /etc/pihole/gravity.db "DELETE FROM domainlist_by_group"
  
  # Executing pihole-updatelists to update lists based on the newly downloaded configuration
  pihole-updatelists
fi

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get autoremove
$STD apt-get autoclean
msg_ok "Cleaned"
