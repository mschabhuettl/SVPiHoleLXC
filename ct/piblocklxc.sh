#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/nathankooistra/PiBlockLXC/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Copyright (c) 2024 mschabhuettl
# Author: tteck (tteckster), mschabhuettl
# License: MIT
# https://github.com/mschabhuettl/PiBlockLXC/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"
    ____  _ ____  __           __   __   _  ________
   / __ \(_) __ )/ /___  _____/ /__/ /  | |/ / ____/
  / /_/ / / __  / / __ \/ ___/ //_/ /   |   / /     
 / ____/ / /_/ / / /_/ / /__/ ,< / /___/   / /___   
/_/   /_/_____/_/\____/\___/_/|_/_____/_/|_\____/   

EOF
}
header_info
echo -e "Loading..."
APP="PiBlockLXC"
var_disk="16"
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
msg_info "Updating ${APP}"
set +e
pihole -up
msg_ok "Updated ${APP}"
exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${APP} should be reachable by going to the following URL.
         ${BL}http://${IP}/admin${CL} \n"
