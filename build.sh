#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

tg_upload(){
    curl -s https://api.telegram.org/bot"${BOTTOKEN}"/sendDocument -F document=@"${1}" -F chat_id="${CHATID}"
}

tg_notify(){
    curl -s https://api.telegram.org/bot"${BOTTOKEN}"/sendMessage -d parse_mode="Markdown" -d text="${1}" -d chat_id="${CHATID}"
}

log(){
	tg_notify "LOG: ${1}"
}

log "Start to setup enviorment"
apt-get update
apt-get install -y git wget curl openjdk-8-jdk zip p7zip-full build-essential libssl-dev libffi-dev python3-dev gawk

log "Start to clone the ErfanGSI tools"
git clone --recurse-submodules --depth=1 https://github.com/erfanoabdi/ErfanGSIs.git

log "Setting up ErfanGSI requirements"
chmod +x ErfanGSIs
cd ErfanGSIs
bash setup.sh

log "Start to build GSI"
bash url2GSI.sh http://183.201.201.1/bigota.d.miui.com/V12.0.2.0.QFHCNXM/miui_VIOLET_V12.0.2.0.QFHCNXM_cb92059195_10.0.zip MIUI

log "Start to make zip"
zip -r  MIUI.zip /drone/src/ErfanGSIs/output/

log "Start to upload"
tg_upload MIUI.zip

log "Build finish"
