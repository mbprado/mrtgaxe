#!/bin/bash
# bitaxe-mrtg.sh
# MRTG-compatible script for Bitaxe metrics

BITAXE_IP=""
METRICS=()

# Parse multiple -m options
while getopts "d:m:" opt; do
  case $opt in
    d) BITAXE_IP="$OPTARG" ;;
    m) METRICS+=("$OPTARG") ;;
    *) echo "Usage: $0 -d <bitaxe_ip> -m metric1 [-m metric2]" ; exit 1 ;;
  esac
done

if [ -z "$BITAXE_IP" ]; then
    echo "0"
    echo "0"
    echo "0"
    echo "bitaxe"
    exit 1
fi

API_URL="http://$BITAXE_IP/api/system/info"
DATA=$(curl -s "$API_URL")

if [ $? -ne 0 ] || [ -z "$DATA" ]; then
    echo "0"
    echo "0"
    echo "0"
    echo "bitaxe"
    exit 1
fi

# Base function:
get_metric() {
	echo "$DATA" | jq -r "$1" 
}

# Map metric name to value
get_value() {
    case "$1" in
        hashrate) echo "$(get_metric '.hashRate // 0')" ;;
        expectedHashrate) echo "$(get_metric '.expectedHashrate // 0')" ;;
        temp) echo "$(get_metric '.temp // 0')" ;;
        vrTemp) echo "$(get_metric '.vrTemp // 0')" ;;
        power) echo "$(get_metric '.power // 0')" ;;
        voltage) echo "$(get_metric '.voltage // 0')" ;;
        current) echo "$(get_metric '.current // 0')" ;;
        corevoltage) echo "$(get_metric '.coreVoltage // 0')" ;;
        coreVoltageActual) echo "$(get_metric '.coreVoltageActual // 0')" ;;
        frequency) echo "$(get_metric '.frequency // 0')" ;;
        poolDifficulty) echo "$(get_metric '.poolDifficulty // 0')" ;;
        bestdiff) echo "$(get_metric '.bestDiff // 0')" ;;
        pooldiff) echo "$(get_metric '.poolDifficulty // 0')" ;;
        errorperc) echo "$(get_metric '.errorPercentage // 0')" ;;
        uptime) echo "$(get_metric '.uptimeSeconds // 0')" ;;
	wifiRSSI)  echo "$(get_metric '.wifiRSSI // 0')" ;;
	responseTime) echo "$(get_metric '.responseTime // 0')" ;;
	sharesAccepted) echo "$(get_metric '.sharesAccepted // 0')" ;;
	sharesRejected) echo "$(get_metric '.sharesRejected // 0')" ;;
        *) echo "0" ;;
    esac
}

# Determine metrics
VAL1=$(get_value "${METRICS[0]}")
VAL2=$(get_value "${METRICS[1]}")

# Default second metric to 0 if missing
[ -z "$VAL2" ] && VAL2=0

# MRTG requires 4 lines
echo "$VAL1"
echo "$VAL2"
echo "$(( $(get_metric '.uptimeSeconds // 0') /3600 ))"
echo "bitaxe-$BITAXE_IP"
