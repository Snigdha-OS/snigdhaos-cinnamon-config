#!/bin/bash

GTK_THEME=$(gsettings get org.cinnamon.desktop.interface gtk-theme | tr -d "'")
ICON_THEME=$(gsettings get org.cinnamon.desktop.interface icon-theme | tr -d "'")
CURSOR_THEME=$(gsettings get org.cinnamon.desktop.interface cursor-theme | tr -d "'")
FONT_NAME=$(gsettings get org.cinnamon.desktop.interface font-name | tr -d "'")
TOOLBAR_STYLE=$(gsettings get org.cinnamon.desktop.interface toolbar-style | tr -d "'")
TOOLBAR_ICON_SIZE=$(gsettings get org.cinnamon.desktop.interface toolbar-icon-size | tr -d "'")

# Ensure /etc/skel directory exists
if [ ! -d "/etc/skel" ]; then
    echo "Error: /etc/skel directory does not exist!"
    exit 1
fi

# Write to /etc/skel/.gtkrc-2.0
cat <<EOF > /etc/skel/.gtkrc-2.0
# DO NOT EDIT! This file will be overwritten by LXAppearance.
# Any customization should be done in ~/.gtkrc-2.0.mine instead.

include "/home/\$USER/.gtkrc-2.0.mine"
gtk-theme-name="$GTK_THEME"
gtk-icon-theme-name="$ICON_THEME"
gtk-font-name="$FONT_NAME"
gtk-cursor-theme-name="$CURSOR_THEME"
gtk-cursor-theme-size=24
gtk-toolbar-style=GTK_TOOLBAR_$TOOLBAR_STYLE
gtk-toolbar-icon-size=GTK_ICON_SIZE_${TOOLBAR_ICON_SIZE^^}
gtk-button-images=0
gtk-menu-images=0
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle="hintfull"
gtk-xft-rgba="none"
gtk-modules="canberra-gtk-module:gail:atk-bridge"
EOF

echo ".gtkrc-2.0 file has been successfully written to /etc/skel/"
