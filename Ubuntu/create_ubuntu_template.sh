#!/bin/bash

#creates a Ubuntu kickstart based template
#This script requires a working metalcloud-cli and jq tools.

#Note this will delete the existing template instead of updating it.

if [ "$#" -ne 2 ]; then
    echo "syntax: $0 <template-id> <os-version (eg: 8.)>"
    exit
fi

TEMPLATE_VERSION="$2" 
TEMPLATE_DISPLAY_NAME="Ubuntu $TEMPLATE_VERSION LTS"
TEMPLATE_DESCRIPTION="$TEMPLATE_DISPLAY_NAME"
TEMPLATE_LABEL=$1
TEMPLATE_ROOT=".tftp/boot/images/Ubuntu-$TEMPLATE_VERSION"


SOURCES="./$TEMPLATE_VERSION"

MC="metalcloud-cli"

DATACENTER_NAME="$METALCLOUD_DATACENTER"
REPO_URL=$(metalcloud-cli datacenter get --id "$DATACENTER_NAME" -show-config -format json | jq ".[0].CONFIG | fromjson |.repoURLRoot" -r)
TEMPLATE_BASE=$REPO_URL/$TEMPLATE_ROOT

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
--boot-type uefi_only \
--os-architecture "x86_64" \
--os-type "Ubuntu" \
--os-version "$TEMPLATE_VERSION" \
--use-autogenerated-initial-password \
--initial-user "root" \
--initial-ssh-port 22 \
--boot-methods-supported "local_drives"

#first param is asset name, 
#second param is asset url relative to $TEMPLATE_BASE 
#third param is usage
function addBinaryURLAsset {
    $MC asset create --url "$TEMPLATE_BASE/$2" --filename "$1-$TEMPLATE_LABEL" \
    --template-id "$TEMPLATE_LABEL" --mime "application/octet-stream" --path "/$1" \
    --delete-if-exists --usage "$3" --return-id
}

#firt param is file name on disk
#second param is path in tftp/http
#third param is params accepted
function addFileAsset {
    $MC asset create --filename "$1-$TEMPLATE_LABEL" --template-id "$TEMPLATE_LABEL" \
    --mime "text/plain" --path "$2" --delete-if-exists --pipe < "$SOURCES/$1"
}

#add bootx64 (pre-bootloader uefi for secure boot)
TEMPLATE_INSTALL_BOOTLOADER_ASSET=$(addBinaryURLAsset "bootx64.efi" "bootx64.efi" "bootloader")

#set the bootx64 bootloader as the template's default bootloader
metalcloud-cli os-template update -id "$TEMPLATE_LABEL" -install-bootloader-asset "$TEMPLATE_INSTALL_BOOTLOADER_ASSET"

#add grub bootloader
addBinaryURLAsset "grubx64.efi" "grubnetx64.efi"

#add grub config file
addFileAsset 'grubx64.cfg' '/grub/grub.cfg'

#add vmlinuz
addBinaryURLAsset 'vmlinuz' 'vmlinuz'

#add initrd.gz
addBinaryURLAsset 'initrd.gz' 'initrd.gz'

#add kickstart file ks.cfg
addFileAsset 'ks.cfg' '/ks.cfg'

#add snmpd.conf
addFileAsset 'snmpd.conf' '/snmpd.conf'

