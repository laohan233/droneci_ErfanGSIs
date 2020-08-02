#!/bin/bash

ROMURL=http://download.h2os.com/OnePlus7/MP/OnePlus7Hydrogen_14.H.26_OTA_026_all_2005131921_07ed821de2814cf6.zip
ROMCLASS=OxygenOS

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
apt-get install -y git wget curl openjdk-8-jdk

log "Start to clone the ErfanGSI tools"
git clone --recurse-submodules --depth=1 https://github.com/erfanoabdi/ErfanGSIs.git

log "Setting up ErfanGSI requirements"
chmod +x ErfanGSIs
cd ErfanGSIs
bash setup.sh

log "Start to build GSI"
bash url2GSI.sh ${ROMURL} ${ROMCLASS}

log "Start to make zip"
zip -r ${ROMCLASS}.zip /drone/src/ErfanGSIs/output/

log "Start to upload"
tg_upload ${ROMCLASS}.zip

log "Build finish"
