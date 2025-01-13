#!/bin/bash

# Define the input config file
config_file="$HOME/.config/hypr/bindings.conf"

# Collect all assigned super keys (including super, super+shift, super+control)
super_keys=$(cat "$config_file" | grep '^bind = \$mainMod, ' | awk '{print $4}' | tr -d ',')
super_shift_keys=$(cat "$config_file" | grep '^bind = \$mainMod SHIFT, ' | awk '{print $5}' | tr -d ',')
super_control_keys=$(cat "$config_file" | grep '^bind = \$mainMod CONTROL, ' | awk '{print $5}' | tr -d ',')

# Layout of the keyboard
layout=(
    "ESC F1 F2 F3 F4 F5 F6 F7 F8 F9 F10 F11 F12"
    " 1 2 3 4 5 6 7 8 9 0 - = BACKSPACE"
    "TAB Q W E R T Y U I O P [ ] |"
    "CAPS A S D F G H J K L ; ' ENTER"
    "SHIFT Z X C V B N M , . / SHIFT"
    "CTRL ALT \t SPACE \t ALT CTRL"
    "\t left up down left"
)

# Function to display usage
usage() {
    echo "Usage:"
    echo "  $0 layout <path-to-config-file>"
    echo "  $0 check <path-to-config-file> <key>"
    exit 1
}

# Function to check if a key is assigned
is_assigned() {
    local key=$1
    local key_set=($2)  # Convert the string to an array
    for assigned_key in "${key_set[@]}"; do
        if [[ "$key" == "$assigned_key" ]]; then
            return 0  # True if found
        fi
    done
    return 1  # False if not found
}

# Function to print the keyboard with colored keys
print_keyboard() {
    local key_set=$1  # Accept the space-separated key set
    
    for row in "${layout[@]}"; do
        for key in $row; do
            if is_assigned "$key" "$key_set"; then
                # Color assigned keys in green
                echo -n -e "\e[32m$key\e[0m  "
            else
                # Color unassigned keys in red
                echo -n -e "\e[31m$key\e[0m  "
            fi
        done
        echo  # New line after each row
    done
}

# Function to extract commands
extract_commands() {
  local mod="$1"
  cat "$config_file" |
    grep "^bind = \$mainMod$mod, " |
    awk -v key="$key" -F ', ' '$2 == key {print $0"\n"}' |
    sed 's/ #.*$//' |
    awk -F ', ' '{for(i=3;i<=NF;i++) printf "%s ", $i}'
}

# Validate the number of arguments
if [[ $# -lt 2 ]]; then
    usage
fi

# Parse the command
command=$1
config_file=$2

if [[ ! -f "$config_file" ]]; then
    echo "Error: Config file '$config_file' not found!"
    exit 1
fi

# Handle commands
if [[ "$command" == "layout" ]]; then
    echo -e "\n\t<---  Super Keys  --->"
    print_keyboard "$super_keys"

    echo -e "\n\t<---  Super + Shift Keys  --->"
    print_keyboard "$super_shift_keys"

    echo -e "\n\t<---  Super + Control Keys  --->"
    print_keyboard "$super_control_keys"

elif [[ "$command" == "check" ]]; then
    if [[ $# -ne 3 ]]; then
        usage
    fi

    key=$(echo "$3" | awk '{for(i=1;i<=NF;i++) if(length($i)==1) $i=toupper($i)} 1')  # Format keys

    super_commands=$(extract_commands '')
    super_shift_commands=$(extract_commands ' SHIFT')
    super_control_commands=$(extract_commands ' CONTROL')

    [[ -n "$super_commands" ]] && echo "super commands:" && echo "$super_commands" | awk '{print "   "$0} END {print "\n"}'
    [[ -n "$super_shift_commands" ]] && echo "super + shift commands:" && echo "$super_shift_commands" | awk '{print "   "$0} END {print "\n"}'
    [[ -n "$super_control_commands" ]] && echo "super + control commands:" && echo "$super_control_commands" | awk '{print "   "$0} END {print "\n"}'
else
    usage
fi
