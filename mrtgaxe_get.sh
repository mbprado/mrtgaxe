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

# Parse all metrics once
HASHRATE=$(echo "$DATA" | jq -r '.hashRate // 0')
HASHRATE_1M=$(echo "$DATA" | jq -r '.hashRate_1m // 0')
HASHRATE_10M=$(echo "$DATA" | jq -r '.hashRate_10m // 0')
HASHRATE_1H=$(echo "$DATA" | jq -r '.hashRate_1h // 0')
TEMP=$(echo "$DATA" | jq -r '.temp // 0')
VRM=$(echo "$DATA" | jq -r '.vrTemp // 0')
POWER=$(echo "$DATA" | jq -r '.power // 0')
VOLTAGE=$(echo "$DATA" | jq -r '.voltage // 0')
CURRENT=$(echo "$DATA" | jq -r '.current // 0')
COREVOLT=$(echo "$DATA" | jq -r '.coreVoltage // 0')
COREVOLT_ACTUAL=$(echo "$DATA" | jq -r '.coreVoltageActual // 0')
BESTDIFF=$(echo "$DATA" | jq -r '.bestDiff // 0')
POOLDIFF=$(echo "$DATA" | jq -r '.poolDifficulty // 0')
ERRORPERC=$(echo "$DATA" | jq -r '.errorPercentage // 0')
UPTIME=$(echo "$DATA" | jq -r '.uptime // 0')
UPTIME_HOURS=$((UPTIME / 3600))

# Map metric name to value
get_value() {
    case "$1" in
        hashrate) echo "$HASHRATE" ;;
        hash_1m) echo "$HASHRATE_1M" ;;
        hash_10m) echo "$HASHRATE_10M" ;;
        hash_1h) echo "$HASHRATE_1H" ;;
        temp) echo "$TEMP" ;;
        vrTemp) echo "$VRM" ;;
        power) echo "$POWER" ;;
        voltage) echo "$VOLTAGE" ;;
        current) echo "$CURRENT" ;;
        corevoltage) echo "$COREVOLT" ;;
        corevoltageact) echo "$COREVOLT_ACTUAL" ;;
        bestdiff) echo "$BESTDIFF" ;;
        pooldiff) echo "$POOLDIFF" ;;
        errorperc) echo "$ERRORPERC" ;;
        uptime) echo "$UPTIME_HOURS" ;;
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
echo "$UPTIME_HOURS"
echo "bitaxe-$BITAXE_IP"
