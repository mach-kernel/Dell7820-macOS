#!/bin/bash

if [ "$1" = "-h" ]; then
	echo "Usage: $0 [path]"
fi

DOWNLOAD_DIR="./.downloads"
TARGET_DIR=$1

if [ -z "$TARGET_DIR" ]; then
	printf "No target, using ./EFI\n\n"
	TARGET_DIR="./EFI"
fi

if [ -z "$OC_PKG"]; then
	OC_PKG="https://github.com/acidanthera/OpenCorePkg/releases/download/0.5.5/OpenCore-0.5.5-RELEASE.zip"
fi

if [ -d "$TARGET_DIR" ]; then
	printf "OK to delete existing target directory %s?\n" $TARGET_DIR
	read -p "(y/n): " choice
	case "$choice" in 
		y|Y )
			rm -rf $TARGET_DIR
			mkdir $TARGET_DIR
			;;
		n|N )
			exit 1
			;;
		* ) echo "invalid";;
	esac
fi

mkdir -p $DOWNLOAD_DIR
cd $DOWNLOAD_DIR

printf "Downloading OpenCorePkg\n"
curl -O $OC_PKG $DOWNLOAD_DIR
