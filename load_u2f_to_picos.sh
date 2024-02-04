#!/bin/bash

#PRESS BOOTSEL BUTTON
#CONNECT MICRO USB TO RPI PICO W
#RELEASE BOOTSEL BUTTON
#EXECUTE SCRIPT

picotool_info=$(sudo picotool info)

if [[ -z "$picotool_info" ]]; then
    echo "No Raspberry Pi Pico devices detected."
    exit 1
fi

declare -a devices

while read -r line; do
    if [[ "$line" =~ "Device at bus" ]]; then
        bus=$(echo "$line" | grep -oP "(?<=bus\s)\d+")
        address=$(echo "$line" | grep -oP "(?<=address\s)\d+")

        if [[ -n "$bus" && -n "$address" ]]; then
            devices+=("$bus $address")
        fi
    fi
done <<< "$picotool_info"

echo "Detected Raspberry Pi Pico devices:"
for device in "${devices[@]}"; do
    echo "$device"
done

for device in "${devices[@]}"; do
    bus=$(echo "$device" | cut -d ' ' -f 1)
    address=$(echo "$device" | cut -d ' ' -f 2)
    echo "Executing command for Bus $bus and Address $address"
    sudo picotool load ./RPI_PICO_W-20231005-v1.21.0.uf2 --bus "$bus" --address "$address"
done
