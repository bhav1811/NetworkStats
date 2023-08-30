#!/bin/sh

# Function to get the current timestamp
get_timestamp() {
    date +"%Y-%m-%d %H:%M:%S"
}

# Get network interface names
interfaces=$(ip -br link )

# Check if network interface names are set
#if [ -z "$interface_eth" ] || [ -z "$interface_wifi" ]; then
   # echo "Unable to determine network interface names."
   # exit 1
#fi

# Function to get network usage statistics
get_network_usage() {
   # interface=$1


cat "/sys/class/net/$interface/statistics/rx_bytes"

}

# Initialize initial network usage statistics

initial_stats_wifi=$(get_network_usage "$interface")

# Loop to continuously display network usage with timestamps
while true; do
    # Get current network usage statistics
    current_stats_eth=$(get_network_usage "$interface")
 

    # Calculate network usage in kilobytes and display with timestamp
    timestamp=$(get_timestamp)
    echo "[$timestamp] Network usage:"
    
    usage_eth=$(( (current_stats_eth - initial_stats_eth) / 1024 ))
    echo "Interface $interface: RX - $usage_eth KB"

  #  usage_wifi=$(( (current_stats_wifi - initial_stats_wifi) / 1024 ))
  #  echo "Interface $interface_wifi: RX - $usage_wifi KB"

    # Wait for 1 second before checking again
    sleep 1
done

