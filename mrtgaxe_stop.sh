#!/bin/bash
#0.1.51
MRTG_PID=$(cat $PWD/mrtg.pid)
BUSYBOX_PID=$(cat $PWD/busybox.pid)

kill $MRTG_PID 2> /dev/null
kill $BUSYBOX_PID 2> /dev/null
