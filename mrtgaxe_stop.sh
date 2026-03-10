#!/bin/bash
MRTG_PID=$(cat $PWD/mrtg.pid)

kill $MRTG_PID 2> /dev/null
killall busybox
