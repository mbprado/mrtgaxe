#!/bin/bash

DEVICE=""
NAME=""
FORCE=0

BITAXE_DIR=$PWD
BITAXE_MINERS_DIR=$PWD/miners

validate_ip() {
    local ip=$1
    [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]] || return 1

    for i in $(echo "$ip" | tr '.' ' '); do
        [ "$i" -le 255 ] || return 1
    done
}

validate_name() {
    #[[ "$1" =~ ^[A-Za-z0-9._-]+$ ]]
    [[ "$1" =~ ^[A-Za-z0-9._\ -]+$ ]]
}


if [ ! -f /usr/bin/dialog ] ; then
	apt update && apt -fy install dialog
	sleep 5
	if [ ! -f /usr/bin/dialog ] ; then
		echo 'Unable to activate menu. Try to install "dialog" manually, or use the scripts'
		exit 255
	fi
fi

while true; do

FORCE_LABEL="OFF"
[ "$FORCE" -eq 1 ] && FORCE_LABEL="ON"

CHOICE=$(dialog --clear \
--title "MRTGaxe Setup" \
--menu "Configure or add miners" 18 60 8 \
1 "Install Required Packages           " \
2 "Run MRTGAxe                         " \
"S" "Stop MRTGAxe"  \
"" "  Add a new miner:" \
3 "Miner IP        : ${DEVICE:-<not set>}" \
4 "Miner Name       : ${NAME:-<not set>}" \
5 "Force            : $FORCE_LABEL" \
6 "Show Derived Values" \
7 "Add Miner" \
0 "Exit" \
3>&1 1>&2 2>&3)
#3>&1 1>&2 2>&3)

# Capture dialog exit status immediately
STATUS=$?

# Exit if Cancel (1) or Esc (255)
if [ $STATUS -ne 0 ]; then
    clear
    echo "Cancelled. Exiting."
    exit 0
fi


clear

case $CHOICE in

1)	
apt uptate 
apt -fy install mrtg busybox 
if [ $? -eq 0 ] ; then 
	dialog --msgbox "Requirements succesfully installed" 6 30
else 
	dialog --msgbox "Impossible to install requirements, install manually or using your distro package manager" 8 30
fi
	;;

2)
	$BITAXE_DIR/mrtgaxe_run.sh
	if [ $? -ne 0 ] ; then
		dialog --msgbox "Failed to start.\\nCheck if MRTG or Busybox are not running already.\\nStop MRTGAxe and try again." 8 60
	fi
	;;

"S")   
	$BITAXE_DIR/mrtgaxe_stop.sh
	;;

3)

TMP=$(dialog --inputbox "Enter Device IP" 8 40 "$DEVICE" 3>&1 1>&2 2>&3)

if [ $? -eq 0 ]; then
    if validate_ip "$TMP"; then
        DEVICE=$TMP
    else
        dialog --msgbox "Invalid IP address." 6 30
    fi
fi
;;

4)

TMP=$(dialog --inputbox "Enter Miner Name\nAllowed: letters numbers . _ -" 9 50 "$NAME" 3>&1 1>&2 2>&3)

if [ $? -eq 0 ]; then
    if validate_name "$TMP"; then
        NAME=$TMP
    else
        dialog --msgbox "Invalid name." 6 30
    fi
fi
;;

5)

if [ "$FORCE" -eq 0 ]; then
    FORCE=1
else
    FORCE=0
fi
;;

6)

if [ -z "$DEVICE" ] || [ -z "$NAME" ]; then
    dialog --msgbox "Device IP and Name must be defined." 6 40
    continue
fi

MINER_NAME=$(echo "$NAME" | tr -d ' ' | tr '[:upper:]' '[:lower:]')
MINER_INAME="$NAME"
MINER_IP="$DEVICE"
FILENAME="${MINER_NAME}.cfg"

dialog --msgbox "
Derived Values

Miner Name   : $MINER_INAME
Miner IP     : $MINER_IP
Filename     : $FILENAME

MRTGAxe dir  : $BITAXE_DIR
Miners dir   : $BITAXE_MINERS_DIR
" 20 60
;;

7)

if [ -z "$DEVICE" ] || [ -z "$NAME" ]; then
    dialog --msgbox "Device IP and Name must be set." 6 40
    continue
fi

MINER_NAME=$(echo "$NAME" | tr -d ' ' | tr '[:upper:]' '[:lower:]')
MINER_INAME="$NAME"
MINER_IP="$DEVICE"
FILENAME="${MINER_NAME}.cfg"

dialog --yesno "
Run setup with:

Device IP : $MINER_IP
Name      : $MINER_INAME
Force     : $FORCE
File      : $FILENAME
" 12 50

if [ $? -eq 0 ]; then

    dialog --infobox "Adding Miner ..." 5 30
    sleep 1

    echo "DEVICE=$DEVICE"
    echo "NAME=$NAME"
    echo "FORCE=$FORCE"
    echo "MINER_NAME=$MINER_NAME"
    echo "FILENAME=$FILENAME"

    $BITAXE_DIR/mrtgaxe_set.sh -d "$DEVICE" -n "$NAME"
    dialog --msgbox "Setup completed." 6 30
fi
;;

"")
    ;;
0)
clear
exit 0
;;

esac

done
