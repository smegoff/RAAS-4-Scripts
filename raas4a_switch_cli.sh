#!/usr/bin/env bash

# Simple interactive RAAS-4a Antenna Switch Control Script

# Set your serial device and baud rate here
TTY="/dev/ttyUSB0"
BAUD=9600  # Change to 115200 or 921600 if your relay supports it

# Configure serial port
stty -F "$TTY" "$BAUD" cs8 -cstopb -parenb -ixon -ixoff -echo

echo "=== RAAS-4a Antenna Switch Control ==="
echo "Device: $TTY, Baud: $BAUD"
echo "Options:"
echo " 1 - Switch to Antenna 1"
echo " 2 - Switch to Antenna 2"
echo " 3 - Switch to Antenna 3"
echo " 4 - Switch to Antenna 4"
echo " ? - Query current antenna"
echo " q - Quit"
echo

while true; do
    read -rp "Select antenna [1-4], [?] to query, or [q] to quit: " choice

    case "$choice" in
        1|2|3|4)
            printf "A%s" "$choice" > "$TTY"
            sleep 0.05
            ;;
        ?)
            printf "A?" > "$TTY"
            sleep 0.05
            # Read the 2-byte response
            IFS= read -r -n2 resp < "$TTY"
            echo "Current selection: $resp"
            ;;
        q|Q)
            echo "Bye!"
            break
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
done
