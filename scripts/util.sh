#!/bin/bash


function getOS() {
    local OS=$(awk -vFS='[="]+' '
        $1=="ID" {OS=$2}
	$1=="VERSION_ID" {sub("\\..*$","",$2);VER=$2}
       	END {print OS""VER} ' /etc/os-release 2>/dev/null)
    echo "${OS:-unk}"
}

OS=$(getOS)

echo $OS

