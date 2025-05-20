# KiwiSDR RAAS-4a Antenna Switch Backend

Bash scripts for controlling a Remote Antenna Switch (RAAS-4a) via a Silicon Labs CP2102N USB-UART bridge.  
Supports manual CLI control and KiwiSDR integration for antenna selection and query.

## Features

- Control up to 4 antenna ports with instant switching
- Query currently selected port
- Works at baud rates from 9600 up to 921600 (if supported by your RAAS-4a board)
- Designed for Debian Linux systems (tested on Debian 11)

## Files

- `ant-switch-backend-raas4a.sh`  
  Bash backend script for use with the KiwiSDR "Antenna Switch Extension".

- `raas4a_switch_cli.sh`  
  Standalone interactive script for manual operation and testing.

## Usage

### Prerequisites

- CP2102N USB to UART bridge connected between host and RAAS-4a (GND, TX, RX)
- Properly powered RAAS-4a board
- User has permission to access `/dev/ttyUSB0` (add user to the `dialout` group if necessary)

### 1. Manual Testing

```bash
chmod +x raas4a_switch_cli.sh
sudo ./raas4a_switch_cli.sh
