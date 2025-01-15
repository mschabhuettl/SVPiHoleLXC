#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/mschabhuettl/PiBlockLXC/main/misc/build.func)
# Copyright (c) 2021-2025 tteck, mschabhuettl
# Author: tteck (tteckster), mschabhuettl
# License: MIT | https://github.com/mschabhuettl/PiBlockLXC/raw/main/LICENSE
# Source: https://pi-hole.net/

# App Default Values
APP="PiBlockLXC"
var_tags="adblock"
var_cpu="2"
var_ram="1024"
var_disk="16"
var_os="debian"
var_version="12"
var_unprivileged="1"

# App Output & Base Settings
header_info "$APP"
base_settings

# Core
variables
color
catch_errors

function update_script() {
    header_info
    check_container_storage
    check_container_resources
    if [[ ! -d /etc/pihole ]]; then
        msg_error "No ${APP} Installation Found!"
        exit
    fi
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
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using the following URL:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}/admin${CL}"