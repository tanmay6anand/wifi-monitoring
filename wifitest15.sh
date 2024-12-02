#!/bin/bash

# Log file location
LOG_FILE="$HOME/wifi_speedtest15.log"

# Function to check WiFi connection
check_wifi() {
    # Check if connected to any WiFi network
    WIFI_STATUS=$(nmcli -t -f WIFI g)
    if [ "$WIFI_STATUS" = "enabled" ]; then
        echo "WiFi is active."
        return 0
    else
        echo "WiFi is inactive."
        return 1
    fi
}

# Function to run speed test and log results
run_speedtest() {
    if check_wifi; then
        # Run speed test and log the result
        SPEEDTEST_RESULT=$(speedtest-cli --simple)
        if [ $? -eq 0 ]; then
            echo "$(date): Speed test successful." >> "$LOG_FILE"
            echo "$SPEEDTEST_RESULT" >> "$LOG_FILE"
        else
            echo "$(date): Speed test failed." >> "$LOG_FILE"
        fi
    else
        echo "$(date): WiFi is not active. Skipping speed test." >> "$LOG_FILE"
    fi
}

# Main script loop
run_speedtest
