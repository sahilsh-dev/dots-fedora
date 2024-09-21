#!/bin/bash

# Function to print in different colors
print_color() {
  case "$1" in
    "green") echo -e "\e[32m$2\e[0m";;
    "red") echo -e "\e[31m$2\e[0m";;
    "blue") echo -e "\e[34m$2\e[0m";;
    *) echo "$2";;
  esac
}

# Function to run commands and handle null bytes
run_command() {
  command_output=$(echo "$1" | tr -d '\0' > /proc/acpi/call && cat /proc/acpi/call | tr -d '\0')
  echo "$command_output"
}

# Function to get current System Performance Mode
get_performance_mode() {
  mode=$(run_command '\_SB.PCI0.LPC0.EC0.GZ44')
  case "$mode" in
    "0x0") echo "Intelligent Cooling";;
    "0x1") echo "Extreme Performance";;
    "0x2") echo "Battery Saving";;
    *) echo "Unknown";;
  esac
}

# Function to get the status of Battery Conservation Mode
get_battery_conservation_status() {
  status=$(run_command '\_SB.PCI0.LPC0.EC0.BTSM')
  [ "$status" == "0x1" ] && echo "on" || echo "off"
}

# Function to toggle Battery Conservation Mode
toggle_battery_conservation_mode() {
  current_status=$(get_battery_conservation_status)
  if [ "$current_status" == "on" ]; then
    run_command '\_SB.PCI0.LPC0.EC0.VPC0.SBMC 0x05'
    echo "Battery Conservation Mode turned $(print_color red "off")"
  else
    run_command '\_SB.PCI0.LPC0.EC0.VPC0.SBMC 0x03'
    echo "Battery Conservation Mode turned $(print_color green "on")"
  fi
}

# Main script
if [ "$#" -eq 0 ]; then
  # No parameters passed, display current settings
  echo "Current Performance Mode: $(print_color blue "$(get_performance_mode)")"
  echo "Battery Conservation Mode: $(print_color blue "$(get_battery_conservation_status)")"
else
  # Handle parameters
  while getopts ":b" opt; do
    case $opt in
      b)
        toggle_battery_conservation_mode
        ;;
      \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
      :)
        echo "Option -$OPTARG requires an argument." >&2
        exit 1
        ;;
    esac
  done
fi
