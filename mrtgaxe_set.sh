#!/bin/bash
DEVICE=""
NAME=""
FORCE=0
BITAXE_DIR=$PWD
BITAXE_MINERS_DIR=$PWD/miners

# Check if no arguments were passed
if [ $# -eq 0 ]; then
    echo "Error: no options provided"
    echo "Usage: $0 -d <device_ip> -n <name> [-f]"
    exit 1
fi

# Parse options
while getopts ":d:n:f" opt; do
    case $opt in
        d)
            DEVICE="$OPTARG"
            ;;
        n)
            NAME="$OPTARG"
            ;;
        f)
            FORCE=1
            ;;
        \?)
            echo "Error: invalid option -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Error: option -$OPTARG requires an argument" >&2
            exit 1
            ;;
    esac
done

# Treat variable do avoid mistakes
MINER_NAME=$(echo -n $NAME | tr -d [' '] | tr [:upper:] [:lower:])
MINER_INAME=$(echo -n $NAME)
MINER_IP=$(echo -n $DEVICE)
FILENAME=$(echo -n $MINER_NAME.cfg)

if [ $FORCE -eq 0 ] ; then
     if [ -f $BITAXE_MINERS_DIR/$FILENAME ] ; then
	     echo "File already existis, use -f to force overwrite"
	     exit 255
     fi
fi
     


cat <<'EOF' | sed -e "s/MINER_NAME/$MINER_NAME/g" -e "s/MINER_INAME/$MINER_INAME/g" -e "s/MINER_IP/$MINER_IP/g" > $BITAXE_MINERS_DIR/$FILENAME
#################################################################################
# Add additional miners by copying this file and changing the IP and target names
#################################################################################

# Input and ASIC Core Voltage 
Target[MINER_NAME_voltage_current]: `${BITAXE_SCRIPT} -d MINER_IP -m voltage -m corevoltage`
MaxBytes[MINER_NAME_voltage_current]: 20000
Title[MINER_NAME_voltage_current]: MINER_INAME Voltage
PageTop[MINER_NAME_voltage_current]: <h1>MINER_INAME Input and Core Voltage</h1>
Options[MINER_NAME_voltage_current]: gauge, growright, nopercent
YLegend[MINER_NAME_voltage_current]: Voltage 
ShortLegend[MINER_NAME_voltage_current]: mV
Legend1[MINER_NAME_voltage_current]: Input Voltage
Legend2[MINER_NAME_voltage_current]: ASIC Voltage
LegendI[MINER_NAME_voltage_current]: Input
LegendO[MINER_NAME_voltage_current]: ASIC

# ASIC Temp & VRM Temp
Target[MINER_NAME_temp_vrm]: `${BITAXE_SCRIPT} -d MINER_IP -m temp -m vrTemp`
MaxBytes[MINER_NAME_temp_vrm]: 100
Title[MINER_NAME_temp_vrm]: MINER_INAME ASIC & VRM Temp
PageTop[MINER_NAME_temp_vrm]: <h1>MINER_INAME ASIC and VRM Temperature</h1>
Options[MINER_NAME_temp_vrm]: gauge, growright, nopercent
YLegend[MINER_NAME_temp_vrm]: Temperature
ShortLegend[MINER_NAME_temp_vrm]: °C
Legend1[MINER_NAME_temp_vrm]: ASIC Temp
Legend2[MINER_NAME_temp_vrm]: VRM Temp
LegendI[MINER_NAME_temp_vrm]: ASIC
LegendO[MINER_NAME_temp_vrm]: VRM

# Hashrate Current Avg
Target[MINER_NAME_hash_1m]: `${BITAXE_SCRIPT} -d MINER_IP -m hashrate`
MaxBytes[MINER_NAME_hash_1m]: 5000
Title[MINER_NAME_hash_1m]: MINER_INAME Hashrate 
PageTop[MINER_NAME_hash_1m]: <h1>MINER_INAME Hash Rate</h1>
Options[MINER_NAME_hash_1m]: gauge, growright, nopercent
YLegend[MINER_NAME_hash_1m]: Hash Rate
ShortLegend[MINER_NAME_hash_1m]: GH/s
Legend1[MINER_NAME_hash_1m]: Hash Rate
Legend2[MINER_NAME_hash_1m]: None
LegendI[MINER_NAME_hash_1m]: Hash Rate
LegendO[MINER_NAME_hash_1m]: 

# Power Consumption
Target[MINER_NAME_power]: `${BITAXE_SCRIPT} -d MINER_IP -m power`
MaxBytes[MINER_NAME_power]: 2000
Title[MINER_NAME_power]: MINER_INAME Power
PageTop[MINER_NAME_power]: <h1>MINER_INAME Power</h1>
Options[MINER_NAME_power]: gauge, growright, nopercent
YLegend[MINER_NAME_power]: Power
ShortLegend[MINER_NAME_power]: W
Legend1[MINER_NAME_power]: Watts
Legend2[MINER_NAME_power]: None
LegendI[MINER_NAME_power]: Power
LegendO[MINER_NAME_power]:

# Error Percentage
Target[MINER_NAME_error]: `${BITAXE_SCRIPT} -d MINER_IP -m errorperc`
MaxBytes[MINER_NAME_error]: 100
Title[MINER_NAME_error]: MINER_INAME Error Rate
PageTop[MINER_NAME_error]: <h1>MINER_INAME Error Rate</h1>
Options[MINER_NAME_error]: gauge, growright, nopercent
YLegend[MINER_NAME_error]: Miner Error
ShortLegend[MINER_NAME_error]: %
Legend1[MINER_NAME_error]: Error
Legend2[MINER_NAME_error]: None
LegendI[MINER_NAME_error]: Error %
LegendO[MINER_NAME_error]: 

# Pool Difficulty
Target[MINER_NAME_diff]: `${BITAXE_SCRIPT} -d MINER_IP -m pooldiff`
MaxBytes[MINER_NAME_diff]: 2000
Title[MINER_NAME_diff]: MINER_INAME Pool Difficulty
PageTop[MINER_NAME_diff]: <h1>MINER_INAME Pool Difficulty</h1>
Options[MINER_NAME_diff]: gauge, growright, nopercent
YLegend[MINER_NAME_diff]: Difficulty
ShortLegend[MINER_NAME_diff]: d
Legend1[MINER_NAME_diff]: diff
Legend2[MINER_NAME_diff]: None
LegendI[MINER_NAME_diff]: Dificulty
LegendO[MINER_NAME_diff]:

# Uptime only (second metric 0)
Target[MINER_NAME_uptime]: `${BITAXE_SCRIPT} -d MINER_IP -m uptime`
MaxBytes[MINER_NAME_uptime]: 100000
Title[MINER_NAME_uptime]: MINER_INAME Uptime
PageTop[MINER_NAME_uptime]: <h1>MINER_INAME Uptime</h1>
Options[MINER_NAME_uptime]: gauge, growright, nopercent
YLegend[MINER_NAME_uptime]: Uptime Hours
ShortLegend[MINER_NAME_uptime]: h
Legend1[MINER_NAME_uptime]: Uptime
Legend2[MINER_NAME_uptime]: None
LegendI[MINER_NAME_uptime]: Uptime Hours
LegendO[MINER_NAME_uptime]:
EOF

