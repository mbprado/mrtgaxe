#!/bin/bash
#0.1.37
BUSYBOX_PORT=9999
LOCAL_IP=$(hostname -I | cut -d' ' -f1)
INDEX=0
REQUIREMENTS=(/usr/bin/jq /usr/bin/busybox /usr/bin/mrtg /usr/bin/bc)

if [[ $1 == "-h" ]] ; then echo "Options: -i - Force index rebuild" ; exit 1 ; fi
if [[ $1 == "-i" ]] ; then INDEX=1 ; fi

export BITAXE_DIR=$PWD
export BITAXE_SCRIPT=$PWD/mrtgaxe_get.sh

#Requirements verification function:
chk_pkg () {
	if [ ! -f "$1" ] ; then
		echo "$1 not found. Install the package"
		exit 254
	# Debug:	
	#else
	#	echo "$1 found. Godd to go"
	fi

}

#Set the configuration file:
sed -i "s|^WorkDir:.*|WorkDir: $BITAXE_DIR/mrtg|" mrtg.cfg
sed -i "s|^Include:.*|Include: $BITAXE_DIR/miners/*.cfg|" mrtg.cfg

# Check required binaries
for pkg in ${REQUIREMENTS[@]} ; do
	chk_pkg $pkg
done

mkdir -p $PWD/mrtg
mkdir -p $PWD/miners

# Check if there is an index available
if [ ! -f $BITAXE_DIR/mrtg/index.html ] || [ $INDEX -eq 1 ] ; then 
	echo Creating index ...
	indexmaker $BITAXE_DIR/mrtg.cfg --output=$BITAXE_DIR/mrtg/index.html --title="MRTGaxe MRTG Dashboard" --sectionhost --headeradd '<img src="logo.png" alt="Logo" style="max-height:50px;">'
	cp logo.png mrtg/logo.png
fi


# Load mrtg
LANG=C mrtg --daemon $PWD/mrtg.cfg
if [ $? -eq 25 ] ; then 
	exit 25
fi
# Load Busybox
setsid busybox httpd -p $BUSYBOX_PORT -h $BITAXE_DIR/mrtg >/dev/null 2>&1 &
if [ $? -eq 0 ] ; then 
	echo "Daemonizing Busybox ..."
	echo "To access the dashboard head to: http://$LOCAL_IP:$BUSYBOX_PORT"
fi
