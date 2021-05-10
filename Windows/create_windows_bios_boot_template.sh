#!/bin/bash

#creates a Windows unattend based template
#This script requires a working metalcloud-cli and jq tools.

#Note this will delete the existing template instead of updating it.

if [ "$#" -ne 2 ]; then
    echo "syntax: $0 <template-id> <os-version (eg: 8.)>"
    exit
fi

TEMPLATE_VERSION="$2" 
TEMPLATE_DISPLAY_NAME="Windows Server $TEMPLATE_VERSION Standard"
TEMPLATE_DESCRIPTION="$TEMPLATE_DISPLAY_NAME"
TEMPLATE_LABEL=$1
# TEMPLATE_ROOT=".tftp/boot/images/Windows-$TEMPLATE_VERSION"

SOURCES="./$TEMPLATE_VERSION"

MC="metalcloud-cli"

DATACENTER_NAME="$METALCLOUD_DATACENTER"
REPO_URL=$(metalcloud-cli datacenter get --id "$DATACENTER_NAME" --show-config -format json | jq ".[0].CONFIG | fromjson |.repoURLRoot" -r)
# TEMPLATE_BASE=$REPO_URL/$TEMPLATE_ROOT
TEMPLATE_WINPE_BASE="$REPO_URL/.tftp/boot/winpe"

# * It's ok to fail with _template <template_label> not found_ if an OS-template with this label doesn't yet exist
if $MC os-template get --id "$TEMPLATE_LABEL" --format json; then
    # * The delete operation, it's ok to fail, when the OS-template <template_label> it's used by an active instance
    if $MC os-template delete --id "$TEMPLATE_LABEL" --autoconfirm; then
        OS_TEMPLATE_COMMAND=create
        OS_TEMPLATE_FLAG=label
    else
        OS_TEMPLATE_COMMAND=update
        OS_TEMPLATE_FLAG=id
    fi
else
    OS_TEMPLATE_COMMAND=create
    OS_TEMPLATE_FLAG=label
fi

#create the template
$MC os-template $OS_TEMPLATE_COMMAND \
--$OS_TEMPLATE_FLAG "$TEMPLATE_LABEL" \
--display-name "$TEMPLATE_DISPLAY_NAME" \
--description "$TEMPLATE_DESCRIPTION" \
--boot-type "legacy_only" \
--os-architecture "x86_64" \
--os-type "Windows" \
--os-version "10.0.17763" \
--use-autogenerated-initial-password \
--initial-user "administrator" \
--initial-ssh-port 22 \
--boot-methods-supported "local_drives"

#first param is asset name, 
#second param is asset url relative to $TEMPLATE_WINPE_BASE
#third param is usage
function addWinPEBinaryURLAsset {
    $MC asset create --url "$TEMPLATE_WINPE_BASE/$2" --filename "$1-$TEMPLATE_LABEL" \
    --template-id "$TEMPLATE_LABEL" --mime "application/octet-stream" --path "$3" \
    --delete-if-exists --usage "$4" --return-id
}

#firt param is file name on disk
#second param is path in tftp/http
#third param is params accepted
function addFileAsset {
    $MC asset create --filename "$1-$TEMPLATE_LABEL" --template-id "$TEMPLATE_LABEL" \
    --mime "text/plain" --path "$2" --delete-if-exists --pipe < "$SOURCES/$1"
}

#add pxeboot.n12 bootloader for bios boot
TEMPLATE_INSTALL_BOOTLOADER_ASSET=$(addWinPEBinaryURLAsset "pxeboot.n12" "pxeboot.n12" "/pxeboot.n12" "bootloader")

#set the pxeboot.n12 bootloader as the template's default bootloader
metalcloud-cli os-template update --id "$TEMPLATE_LABEL" --install-bootloader-asset "$TEMPLATE_INSTALL_BOOTLOADER_ASSET"

#add bootmgr.exe
addWinPEBinaryURLAsset "bootmgr.exe" "bootmgr.exe" "/bootmgr.exe"

# add BCD store file - Boot Configuration Data
addWinPEBinaryURLAsset "BCDBIOS" "BCDBIOS" "\\Boot\\BCD"

# add boot.sdi file
addWinPEBinaryURLAsset "boot.sdi" "boot.sdi" "\\Boot\\boot.sdi"

# add boot.wim file
addWinPEBinaryURLAsset "boot.wim" "boot.wim" "\\Boot\\boot.wim"

# add wgl4_boot.ttf font
addWinPEBinaryURLAsset "wgl4_boot.ttf" "Fonts/wgl4_boot.ttf" "\\Boot\\Fonts\\wgl4_boot.ttf"

#add autounattend-bios.xml config file
addFileAsset "autounattend-bios.xml" "/autounattend-bios.xml"

#add data.bat file
addFileAsset "data.bat" "/data.bat"

