#!/bin/bash

# MediaTek/Intel Wi-Fi Drop Tester 
# V2.1
# This basic script pings 8.8.8.8 every 60 seconds and runs a check of iw every 10 seconds to capture as much as possible.
# If there is a drop or even a drop and it resumes, we should see it happen here. This will run for one hour.
# You can stop it at any time with ctrl+c if you need to.

# You will first see "iw is already installed", then it will move to your interface name two seconds later. Then the monitoring will take place for one hour or until you interrupt this.

# Function to install a package if not installed
install_if_needed() {
    local package=$1
    if ! command -v $package &> /dev/null; then
        echo "$package not found, installing..."
        if [ -f /etc/fedora-release ]; then
            sudo dnf install -y $package
        elif [ -f /etc/lsb-release ]; then
            sudo apt-get update
            sudo apt-get install -y $package
        else
            echo "Unsupported Linux distribution. Please install $package manually."
            exit 1
        fi
    else
        echo "$package is already installed."
    fi
}

# Install iw and lshw if necessary
install_if_needed iw
install_if_needed lshw

# Set the duration (in seconds) for which you want to monitor the WiFi
MONITOR_DURATION=3600  # 1 hour

# Log files to store iw and ping output
IW_LOG="$HOME/iw_logfile.log"
PING_LOG="$HOME/ping_logfile.log"

# Host to ping for connectivity checks
PING_HOST="8.8.8.8"

# Ping interval (in seconds)
PING_INTERVAL=60  # Set to 60 seconds for 1-minute intervals

# Create or clear the log files
: > "$IW_LOG"
: > "$PING_LOG"

# Get system information
KERNEL_VERSION=$(uname -r)
BIOS_VERSION=$(sudo dmidecode -s bios-version)

if [ -f /etc/fedora-release ]; then
    DISTRO=$(cat /etc/fedora-release)
elif [ -f /etc/lsb-release ]; then
    DISTRO=$(grep DISTRIB_DESCRIPTION /etc/lsb-release | cut -d'=' -f2 | tr -d '"')
else
    DISTRO="Unknown"
fi

# Get network device brand and driver
DEVICE_BRAND=$(sudo lshw -C network | grep -m 1 'vendor:' | awk -F ': ' '{print $2}')
DRIVER=$(sudo lshw -C network | grep -i 'configuration:.*driver=' | awk -F 'driver=' '{print $2}' | awk '{print $1}')

# Append system information to the iw log file
echo "Kernel Version: $KERNEL_VERSION" >> "$IW_LOG"
echo "BIOS Version: $BIOS_VERSION" >> "$IW_LOG"
echo "Linux Distribution: $DISTRO" >> "$IW_LOG"
echo "Device Brand: $DEVICE_BRAND" >> "$IW_LOG"
echo "Driver: $DRIVER" >> "$IW_LOG"
echo "---------------------------" >> "$IW_LOG"

# Get the active WiFi interface name
interface=$(nmcli -t -f active,device d wifi list | grep '^yes' | cut -d':' -f2)
echo -e "\n        \033[1;33mInterface:\033[0m $interface"

echo "Monitoring WiFi on interface $interface for $MONITOR_DURATION seconds. Logs are being saved to $IW_LOG and $PING_LOG."

# Function to log iw output periodically
log_iw() {
    local end_time=$((SECONDS + MONITOR_DURATION))
    while [ $SECONDS -lt $end_time ]; do
        echo "$(date):" >> "$IW_LOG"
        iw dev $interface link >> "$IW_LOG"
        echo "---------------------------" >> "$IW_LOG"
        sleep 10  # Adjust the interval as needed
    done
}

# Start logging iw output in the background
log_iw &
IW_PID=$!

# Start pinging in the background and redirect output to the log file
timeout $MONITOR_DURATION ping -i $PING_INTERVAL $PING_HOST &> "$PING_LOG" &
PING_PID=$!

echo "Processes started: iw PID = $IW_PID, ping PID = $PING_PID"

# Wait for the monitoring to complete
wait $IW_PID
wait $PING_PID

echo "Monitoring completed."

# Analyze the log files for drops or freezes
echo "Analyzing the log files for drops or freezes..."

# Example: Check iw log file for specific patterns
grep -i "not connected\|no signal" "$IW_LOG"

# Example: Check ping log file for packet loss or high latency
grep -i "timeout\|unreachable\|100% packet loss" "$PING_LOG"

echo "Analysis completed. Check the log files for details."
