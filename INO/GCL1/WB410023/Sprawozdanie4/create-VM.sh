#!/bin/bash

VM_NAME="New-Fedora"
ISO_PATH="C:\Users\weron\Downloads\Fedora-Server-netinst-x86_64-38-1.6.iso"
VBOXMANAGE_PATH="C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"

"$VBOXMANAGE_PATH" createvm --name "$VM_NAME" --ostype "RedHat_64" --register
"$VBOXMANAGE_PATH" modifyvm "$VM_NAME" --memory 2048 --acpi on --boot1 dvd --nic1 bridged --bridgeadapter1 "MediaTek Wi-Fi 6 MT7921 Wireless LAN Card"
"$VBOXMANAGE_PATH" createhd --filename "${VM_NAME}.vdi" --size 10000
"$VBOXMANAGE_PATH" storagectl "$VM_NAME" --name "SATA Controller" --add sata
"$VBOXMANAGE_PATH" storageattach "$VM_NAME" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "${VM_NAME}.vdi"
"$VBOXMANAGE_PATH" storageattach "$VM_NAME" --storagectl "SATA Controller" --port 1 --device 0 --type dvddrive --medium "$ISO_PATH"
"$VBOXMANAGE_PATH" startvm "$VM_NAME"
