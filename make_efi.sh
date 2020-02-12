#!/bin/bash

if [ "$1" = "-h" ]; then
	echo "Usage: $0 [path]"
fi

DOWNLOAD_DIR="$PWD/.downloads"
TARGET_DIR=$1

DL_DEPENDENCIES=(
	# OpenCore
	https://github.com/acidanthera/OpenCorePkg/releases/download/0.5.5/OpenCore-0.5.5-RELEASE.zip
	https://github.com/acidanthera/AppleSupportPkg/releases/download/2.1.5/AppleSupport-2.1.5-RELEASE.zip

	# Drivers & kexts
	https://bitbucket.org/RehabMan/os-x-intel-network/downloads/RehabMan-IntelMausiEthernet-v2-2018-1031.zip
	https://github.com/acidanthera/Lilu/releases/download/1.4.1/Lilu-1.4.1-RELEASE.zip
	https://bitbucket.org/RehabMan/os-x-usb-inject-all/downloads/RehabMan-USBInjectAll-2018-1108.zip
	https://github.com/acidanthera/VirtualSMC/releases/download/1.1.1/VirtualSMC-1.1.1-RELEASE.zip
	https://downloads.sourceforge.net/project/voodoohda/VoodooHDA.kext-292.zip
	https://github.com/acidanthera/WhateverGreen/releases/download/1.3.6/WhateverGreen-1.3.6-RELEASE.zip
)

if [ -z "$TARGET_DIR" ]; then
	printf "No target specified, using ./EFI\n\n"
	TARGET_DIR="$PWD/EFI"
fi

mkdir -p $TARGET_DIR

if [ -d "$TARGET_DIR/OC" ]; then
	printf "OK to delete existing %s?\n" "$TARGET_DIR/OC"
	read -p "(y/n): " choice
	case "$choice" in 
		y|Y )
			rm -rf "$TARGET_DIR/OC"
			;;
		n|N )
			exit 1
			;;
		* ) echo "invalid";;
	esac
fi

mkdir -p $DOWNLOAD_DIR
pushd $DOWNLOAD_DIR
printf "Downloading dependencies...(please wait)\n"

for dependency in "${DL_DEPENDENCIES[@]}"; do
	printf "Fetching %s\n" $dependency
	curl -sOL $dependency &
done

wait

for filename in *.zip; do
	unzip $filename -d "${filename%.zip}"
done

mkdir -p "$TARGET_DIR/BOOT"
mkdir -p "$TARGET_DIR/OC"
mkdir -p "$TARGET_DIR/OC/Drivers"
mkdir -p "$TARGET_DIR/OC/Kexts"

# OpenCore + things we need from AppleSupport
mv OpenCore*/EFI/BOOT/BOOTx64.efi "$TARGET_DIR/BOOT"
mv OpenCore*/EFI/OC/Tools "$TARGET_DIR/OC"
mv OpenCore*/EFI/OC/OpenCore.efi "$TARGET_DIR/OC"
mv AppleSupport*/Drivers/ApfsDriverLoader.efi "$TARGET_DIR/OC/Drivers"
mv AppleSupport*/Drivers/VBoxHfs.efi "$TARGET_DIR/OC/Drivers"
mv OpenCore*/EFI/OC/Drivers/FwRuntimeServices.efi "$TARGET_DIR/OC/Drivers"

# VirtualSMC
mv VirtualSMC*/Kexts/SMCProcessor.kext "$TARGET_DIR/OC/Kexts"
mv VirtualSMC*/Kexts/SMCSuperIO.kext "$TARGET_DIR/OC/Kexts"
mv VirtualSMC*/Kexts/VirtualSMC.kext "$TARGET_DIR/OC/Kexts"

# Kexts
mv RehabMan-USBInjectAll*/Release/USBInjectAll.kext "$TARGET_DIR/OC/Kexts"
mv RehabMan-IntelMausiEthernet*/Release/IntelMausiEthernet.kext "$TARGET_DIR/OC/Kexts"
mv Lilu*/Lilu.kext "$TARGET_DIR/OC/Kexts"
mv VoodooHDA*/VoodooHDA.kext "$TARGET_DIR/OC/Kexts"
mv WhateverGreen*/WhateverGreen.kext "$TARGET_DIR/OC/Kexts"

popd
rm -rf $DOWNLOAD_DIR

pushd OC-7820
cp -r ACPI "$TARGET_DIR/OC"
cp config.plist "$TARGET_DIR/OC"
popd
