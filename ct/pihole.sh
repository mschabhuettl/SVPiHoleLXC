#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/mschabhuettl/SVPiHoleLXC/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Copyright (c) 2024 mschabhuettl
# Author: tteck (tteckster), mschabhuettl
# License: MIT
# https://github.com/mschabhuettl/SVPiHoleLXC/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"
   ______    ______  _       __  ______  __    ______
  / ___/ |  / / __ \(_)     / / / / __ \/ /   / ____/
  \__ \| | / / /_/ / /_____/ /_/ / / / / /   / __/   
 ___/ /| |/ / ____/ /_____/ __  / /_/ / /___/ /___   
/____/ |___/_/   /_/     /_/ /_/\____/_____/_____/   
 
EOF
}
header_info
echo -e "Loading..."
APP="SVPihole"
var_disk="8"
var_cpu="2"
var_ram="1024"
var_os="debian"
var_version="12"
variables
color
catch_errors

function default_settings() {
  CT_TYPE="1"
  PW=""
  CT_ID=$NEXTID
  HN=$NSAPP
  DISK_SIZE="$var_disk"
  CORE_COUNT="$var_cpu"
  RAM_SIZE="$var_ram"
  BRG="vmbr0"
  NET="dhcp"
  GATE=""
  APT_CACHER=""
  APT_CACHER_IP=""
  DISABLEIP6="no"
  MTU=""
  SD=""
  NS=""
  MAC=""
  VLAN=""
  SSH="no"
  VERB="no"
  echo_default
}

function update_script() {
header_info
if [[ ! -d /etc/pihole ]]; then msg_error "No ${APP} Installation Found!"; exit; fi
msg_info "Updating ${APP} LXC"
apt-get update &>/dev/null
apt-get -y upgrade &>/dev/null
msg_ok "Updated Successfully"
exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${APP} should be reachable by going to the following URL.
         ${BL}http://${IP}/admin${CL} \n"
