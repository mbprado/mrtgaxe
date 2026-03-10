#!/bin/bash
BUSYBOX_PORT=9999
LOCAL_IP=$(hostname -I | cut -d' ' -f1)

export BITAXE_DIR=$PWD
export BITAXE_SCRIPT=$PWD/mrtgaxe_get.sh


#Set the configuration file:
sed -i "s|^WorkDir:.*|WorkDir: $BITAXE_DIR/mrtg|" mrtg.cfg
sed -i "s|^Include:.*|Include: $BITAXE_DIR/miners/*.cfg|" mrtg.cfg

# Check if busybox is installed 
busybox > /dev/null 2>&1
if [ $? -ne 0 ] ; then
	echo busybox not installed
	exit 255
fi

# Check if mrtg is installed
if [ ! -f /usr/bin/mrtg ] ; then
	echo mrtg not installed
	exit 255
fi

mkdir -p $PWD/mrtg
mkdir -p $PWD/miners

# Check if there is an index available
if [ ! -f $BITAXE_DIR/mrtg/index.html ] ; then 
	echo Create index
	indexmaker $BITAXE_DIR/mrtg.cfg --output=$BITAXE_DIR/mrtg/index.html
fi


# Load mrtg
LANG=C mrtg --daemon $PWD/mrtg.cfg
if [ $? -ne 0 ] ; then 
	exit 255
fi
# Load Busybox
setsid busybox httpd -p $BUSYBOX_PORT -h $BITAXE_DIR/mrtg >/dev/null 2>&1 &
if [ $? -eq 0 ] ; then 
	echo Daemonizing Busybox ...
	echo -e \\n
	echo "To access the dashboard head to: http://$LOCAL_IP:$BUSYBOX_PORT"
fi
