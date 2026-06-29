#!/bin/bash
#

DstDir=/usr/local/lib/systemd/system
ScrDir="$(cd $(dirname $0);pwd)"
PrjDir="$(cd $(dirname $0)/..;pwd)"
SrcUnit="$PrjDir/service/llamacpp.service"
UnitName="$(basename ${SrcUnit})"
DstUnit=/usr/local/lib/systemd/system/$UnitName

if [ ! -f "$SrcUnit" ]; then
    echo "ERROR: can not found $SrcUnit"
    exit 1
fi

if [ ! -d "$DstDir" ]; then
    sudo mkdir -p "$DstDir"
fi

if [ -e "${DstUnit}" -o -L "${DstUnit}" ]; then
    echo "stop $UnitName"
    sudo systemctl stop $UnitName >/dev/null 2>&1
    sudo systemctl disable $UnitName >/dev/null 2>&1
    echo "clear $UnitName"
    sudo rm -f "${DstUnit}"
elif [ ! -d "$DstDir" ]; then
    sudo mkdir -p "$DstDir"
    if [ ! -d "$DstDir" ]; then
        echo "ERROR: can not found $DstDir"
        exit 1
    fi
fi
echo "install $UnitName"
sudo ln -s "${SrcUnit}" "${DstUnit}"
sudo systemctl daemon-reload
echo "enable $UnitName"
sudo systemctl enable $UnitName
sudo systemctl start $UnitName

