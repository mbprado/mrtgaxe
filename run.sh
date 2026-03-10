#!/bin/bash
export BITAXE_DIR=$PWD
export BITAXE_SCRIPT=$PWD/mrtgaxe_get.sh

#Set the configuration file:
sed -i "s|^WorkDir:.*|WorkDir: $BITAXE_DIR/mrtg|" mrtg.cfg

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

# Check if there is an index available
if [ ! -f $BITAXE_DIR/mrtg/index.html ] ; then 
	echo Create index
	indexmaker $BITAXE_DIR/mrtg.cfg --output=$BITAXE_DIR/mrtg/index.html
fi

echo $BITAXE_SCRIPT 
echo $BITAXE_DIR

# Load mrtg
LANG=C mrtg --daemon $PWD/mrtg.cfg
if [ $? -ne 0 ] ; then 
	exit 255
fi
setsid busybox httpd -p 9999 -h /var/www/mrtg >/dev/null 2>&1 &
