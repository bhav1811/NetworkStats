#!/bin/sh

# Desired location and name of the output file
output_file="/storage/emulated/0/Documents/network/network_stats.txt"

# Function to handle DNS events
handle_dns_event() {
  local timestamp="$1"
  local source_ip="$2"
  local destination_ip="$3"


  # Display the DNS event on the terminal
  echo "DNS Event - Timestamp: $timestamp"
  echo "Source IP: $source_ip"
  echo "Destination IP: $destination_ip"

  echo

  # Append the DNS event to the output file
  echo "DNS Event - Timestamp: $timestamp" >> "$output_file"
  echo "Source IP: $source_ip" >> "$output_file"
  echo "Destination IP: $destination_ip" >> "$output_file"
  echo "Domain: $domain" >> "$output_file"
  echo >> "$output_file"
}


# Function to get URL and IP address using ping command
get_url_and_ip() {
  local ip_address="$1"

  # Use nslookup to get the domain name (URL) of the IP address
  domain=$(ping "$ip_address") #| awk '/name =/ {print $4}' | head -n 1)

  # Display the URL and IP address on the terminal
  echo "URL: $domain"
  echo "IP Address: $ip_address"
  echo

  # Append the URL and IP address to the output file
  echo "URL: $domain" >> "$output_file"
  echo "IP Address: $ip_address" >> "$output_file"
  echo >> "$output_file"
}
# Get the hostname
hostname=$(getprop net.hostname)    #(hostname)
# If net.hostname is not set, try using ro.product.name property as a fallback
if [ -z "$hostname" ]; then
  hostname=$(getprop ro.product.name)
fi

# If both properties are not set, use a default value
if [ -z "$hostname" ]; then
  hostname="Unknown_Hostname"
fi
# Infinite loop
while true; do
  # Get the current timestamp
  timestamp=$(date +"%Y-%m-%d %H:%M:%S")

  # Get the network interface names
  interfaces=$(ip -br link | awk '{print $1}' | grep -v 'lo')

  # Loop through each interface and display network usage statistics
  for interface in $interfaces; do
    # Check if the interface is rmnet_upa0 or wlan0
    if [ "$interface" == "rmnet_ipa0" ] || [ "$interface" == "wlan0" ]; then
	    # Get network usage statistics for the interface
	    stats= $(ip -s -h -c -d link show dev $interface | awk '!/RX\ errors/ && !/TX\ errors/ {print}')

	    # Get IP addresses
	    ip_addresses=$(ip -d -s -c -r addr show dev $interface)
	     

          
  #dns_events=$( tcpdump -i $interface -n -e -vvv -s 0 -l '(((port 68 and port 67) or (port 67 and port 68)) and udp)' | awk interface= "$interface" )
#'{print timestamp, interface, $1, $2, $3, $4, $5, $6, $7, $8}')
 

	    # Display hostname, timestamp, network usage statistics, IP addresses, and DNS events on terminal
	    echo "Hostname: $hostname"
	    echo "Timestamp: $timestamp"
	    echo "Network Usage Statistics for $interface:"
	    echo "$stats"
	    echo
	    echo "IP Addresses for $interface:"
	    echo "$ip_addresses"
	    echo
	    echo "DNS Events:"
	    echo "$dns_events"
	    echo

	    # Append the output to the file
	    echo "Hostname: $hostname" >> "$output_file"
	    echo "Timestamp: $timestamp" >> "$output_file"
	    echo "Network Usage Statistics for $interface:" >> "$output_file"
	    echo "$stats" >> "$output_file"
	    echo >> "$output_file"
	    echo "IP Addresses for $interface:" >> "$output_file"
	    echo "$ip_addresses" >> "$output_file"
	    echo >> "$output_file"
	  #  echo "DNS Events:" >> "$output_file"
	   # echo "$dns_events" >> "$output_file"
	    echo >> "$output_file"

	    # Process each DNS event
	  #  while read -r line; do
	   #   handle_dns_event $line
	    #done <<< "$dns_events"
fi
done
  # Wait for 1 second before repeating the loop
  sleep 3
# CONNEXTTION DECISIONS, SCANS
done
