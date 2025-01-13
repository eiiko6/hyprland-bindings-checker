# Hyprland Key Bindings Display and Check Script

## Description

This script displays the layout of your keyboard with highlighted keys based on the keybindings defined in the Hyprland config file. It also allows you to check which commands are associated with specific modifier keys (Super, Super+Shift, or Super+Control).

## Usage

```bash
./script.sh layout <path-to-config-file>      # Display the keyboard layout with highlighted keys
./script.sh check <path-to-config-file> <key> # Check the commands associated with a specific key
```
### Example Usage

1. **Display Keyboard Layout**:

   ```bash
   ./hyprland_keys.sh layout ~/.config/hypr/bindings.conf
   ```

2. **Check Commands for a Specific Key**:

   ```bash
   ./hyprland_keys.sh check ~/.config/hypr/bindings.conf A
   ```

## Required Format for Hyprland Config File

The script expects the Hyprland keybinding configuration file to follow a specific format. Here are some examples:

```bash
bind = $mainMod, M, exec, some command # Some optional comment
bind = $mainMod SHIFT, left, movefocus, l
bind = $mainMod CONTROL, R, exec, some other command
```
