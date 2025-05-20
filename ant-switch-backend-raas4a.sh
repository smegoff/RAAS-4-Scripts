#!/usr/bin/env bash
# ant-switch-backend-raas4a.sh
# KiwiSDR backend for RAAS-4a antenna switch via CP2102N USB-UART
# Compatible with Debian 11.11+, supports 4 ports and query/status

N_CH=4
VERSION=1.3

# Set your serial device and baud rate here
TTY="/dev/ttyUSB0"
BAUD=9600  # Change to 115200 or 921600 if your board supports it

# Try to autodetect a CP2102N device if available
for path in /dev/serial/by-id/*CP2102N*; do
    [[ -e "$path" ]] && { TTY="$path"; break; }
done

configure_port() {
    stty -F "$TTY" "$BAUD" cs8 -cstopb -parenb -ixon -ixoff -echo
}

send_cmd() {
    printf "%s" "$1" > "$TTY"
}

recv_resp() {
    IFS= read -r -n2 resp < "$TTY"
    echo "$resp"
}

AntSW_ShowBackend() {
    echo "RAAS-4a USB v$VERSION, 4 antennas, $TTY @ $BAUD baud"
}

AntSW_GetAddress() {
    echo "$TTY"
}

AntSW_SetAddress() {
    [[ -n "$1" ]] && TTY="$1"
    echo "$TTY"
}

AntSW_Initialize() {
    modprobe cp210x 2>/dev/null || true
    configure_port
}

AntSW_GroundAll() {
    send_cmd "A1"
}

AntSW_SelectAntenna() {
    send_cmd "A$1"
}

AntSW_AddAntenna() {
    send_cmd "A$1"
}

AntSW_RemoveAntenna() {
    send_cmd "A1"
}

AntSW_ToggleAntenna() {
    send_cmd "A?"
    sleep 0.05
    resp=$(recv_resp)
    cur=${resp:1:1}
    if [[ "$cur" == "$1" ]]; then
        AntSW_GroundAll
    else
        send_cmd "A$1"
    fi
}

AntSW_ReportSelected() {
    send_cmd "A?"
    sleep 0.05
    resp=$(recv_resp)
    sel=${resp:1:1}
    echo -n "Selected antenna: "
    echo "$sel"
}

AntSW_ShowSelected() {
    AntSW_ReportSelected
}

# Command-line support
case "${1,,}" in
    show)
        AntSW_ShowBackend
        ;;
    status)
        AntSW_ShowSelected
        ;;
    *)
        # No-op
        ;;
esac
