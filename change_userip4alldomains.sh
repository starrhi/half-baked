#!/bin/bash

# HestiaCP : CLI Bash script to Change IP for All Domains Under a Specific User

# Function to check if the entered username exists
function check_user_exists() 
{
	local username=$1
	# Get the list of existing users in plain format and check if the username exists
	if v-list-users plain | awk '{print $1}' | grep -qw "$username"; then
		return 0 # User exists
	else
		return 1 # User does not exist
	fi
}

# Prompt the user to input the username
read -p "Enter the HestiaCP username: " username

# Check if the username exists
if ! check_user_exists "$username"; then
	echo "Error: The username '$username' does not exist in HestiaCP."
	exit 1
fi

# Prompt the user to input the new IP address
read -p "Enter the new IP address: " new_ip

# Check if the new IP address is provided
if [[ -z "$new_ip" ]]; then
  echo "Error: IP address is required."
  exit 1
fi

# List all domains for the user and loop through them to change the IP address
for domain in $(v-list-web-domains $username plain | awk '{print $1}'); do
  echo "Changing IP for domain: $domain to $new_ip"
  v-change-web-domain-ip $username $domain $new_ip
done

echo "IP address change completed for all domains under user: $username"
