# Wifi-monitoring

## Overview
This project provides a Python script to parse log files of internet speed tests and visualize the download speed over time. It uses `matplotlib` to create a time-series graph of download speed, with failed speed tests treated as zero speed. This allows users to easily observe the variation in internet performance.

Additionally, the project includes a Bash script that automates the logging of speed test results, making it easy to gather data over time.

## Features
- Parses internet speed logs, including successful and failed speed tests.
- Converts log data into a graph showing download speed over time.
- Automatically treats failed speed tests as zero speed.
- Provides adjustable granularity of time labels for better visualization.
- Bash script for automating speed test logging.

## Requirements
- Python 3.x
- `matplotlib`
- `re` (Regular Expressions for log parsing)
- `datetime` (For date-time handling)
- `pandas` (Optional, used for data inspection/debugging)
- `speedtest-cli` (Required for running the Bash script)

You can install the necessary Python packages using:
```sh
pip install matplotlib pandas
```

To install `speedtest-cli`, use:
```sh
sudo apt-get install speedtest-cli
```

## Usage
1. Clone this repository to your local machine:
   ```sh
   git clone git@github.com:tanmay6anand/wifi-monitoring.git
   ```
2. Place your internet speed log file in the project directory. Make sure the file follows the expected format:
   ```
   Wed Nov 27 01:38:20 AM EST 2024: Speed test successful.
   Ping: 58.931 ms
   Download: 176.34 Mbit/s
   Upload: 10.62 Mbit/s
   ```
3. Update the path to the log file in the Python script:
   ```python
   log_file_path = 'your_log_file.log'
   ```
4. Run the Python script to generate the graph:
   ```sh
   python internet_speed_analysis.py
   ```
5. To automate logging of speed tests, use the provided Bash script:
   ```sh
   ./run_speedtest.sh
   ```

## Bash Script for Automating Speed Tests
The project includes a Bash script (`run_speedtest.sh`) that automates the process of running speed tests and logging the results.

### Bash Script Overview
```bash
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
```

### How to Use the Bash Script
1. Ensure `speedtest-cli` is installed.
2. Make the script executable:
   ```sh
   chmod +x run_speedtest.sh
   ```
3. Run the script to log internet speed tests:
   ```sh
   ./run_speedtest.sh
   ```

This script will check if the WiFi is active before running a speed test. If the speed test is successful, it logs the results (ping, download, and upload speeds) to the specified log file. If the speed test fails or WiFi is inactive, it logs an appropriate message.

### Automating with Cron
To continuously log speed tests, you can use `cron` to schedule the Bash script to run at regular intervals.

1. Open the cron editor:
   ```sh
   crontab -e
   ```
2. Add an entry to run the script every hour (or adjust the interval as needed):
   ```
   0 * * * * /path/to/run_speedtest.sh
   ```
   This line schedules the script to run at the start of every hour. Adjust the interval as needed to fit your requirements.

3. Save and exit the editor. The script will now run automatically according to the schedule you defined.

## Log File Format
The script expects log entries with the following format:
- **Successful Test**: Includes timestamp, ping, download, and upload speeds.
- **Failed Test**: Includes timestamp and an indication that the speed test failed.

Example:
```
Wed Nov 27 01:38:20 AM EST 2024: Speed test successful.
Ping: 58.931 ms
Download: 176.34 Mbit/s
Upload: 10.62 Mbit/s
Wed Nov 27 04:01:06 AM EST 2024: Speed test failed.
```

## Customization
- **Time Granularity**: You can adjust the granularity of the time axis by modifying the interval in the script's `HourLocator` configuration.
- **Data Inspection**: The script uses `pandas` for inspecting parsed data during debugging. You can enable or modify this feature for your needs.

## Output
The script generates a time-series graph that visualizes download speed over time, with each data point representing either a successful speed test or a failed test (represented as 0 Mbit/s).


## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Contributions
Contributions are welcome! Please submit a pull request or open an issue for any improvements or suggestions.

## Contact
If you have any questions, feel free to reach out.
- **Author**: Tanmay Anand
- **Email**: your_email@example.com

