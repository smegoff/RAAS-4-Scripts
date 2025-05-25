#!/usr/bin/env bash
# KiwiSDR Antenna Switch Backend: RAAS-4a

N_CH=4
VERSION=1.4

# Try to autodetect a CP2102N device if available
TTY="/dev/ttyUSB0"
for path in /dev/serial/by-id/*CP2102N*; do
    [[ -e "$path" ]] && { TTY="$path"; break; }
done

BAUD=9600  # Set to 115200 or 921600 if your board supports it

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
    # Description         # NumChannels  # SerialDevice
    echo "RAAS-4a USB relay $N_CH $TTY"
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

# CLI support for standalone testing
case "${1,,}" in
    show)
        AntSW_ShowBackend
        ;;
    status)
        AntSW_ShowSelected
        ;;
    *)
        # no-op
        ;;
esac
