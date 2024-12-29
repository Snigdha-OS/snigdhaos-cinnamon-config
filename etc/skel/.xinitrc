#!/bin/bash
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

# File paths for resources and keymaps
userresources="$HOME/.Xresources"
usermodmap="$HOME/.Xmodmap"
sysresources="/etc/X11/xinit/.Xresources"
sysmodmap="/etc/X11/xinit/.Xmodmap"

# Default session (fallback to cinnamon)
SESSION="${1:-cinnamon}"

# Merge system defaults and keymaps if they exist
[ -f "$sysresources" ] && xrdb -merge "$sysresources"
[ -f "$sysmodmap" ] && xmodmap "$sysmodmap"
[ -f "$userresources" ] && xrdb -merge "$userresources"
[ -f "$usermodmap" ] && xmodmap "$usermodmap"

# Execute scripts in xinitrc.d directory
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for script in /etc/X11/xinit/xinitrc.d/?*.sh; do
        [ -x "$script" ] && . "$script"
    done
    unset script
fi

# Function to determine the session to launch
get_session() {
    local dbus_args=(--sh-syntax --exit-with-session)
    case "$SESSION" in
        awesome) dbus_args+=(awesome) ;;
        bspwm) dbus_args+=(bspwm-session) ;;
        budgie) dbus_args+=(budgie-desktop) ;;
        cinnamon) dbus_args+=(cinnamon-session) ;;
        deepin) dbus_args+=(startdde) ;;
        enlightenment) dbus_args+=(enlightenment_start) ;;
        fluxbox) dbus_args+=(startfluxbox) ;;
        gnome) dbus_args+=(gnome-session) ;;
        i3|i3wm) dbus_args+=(i3 --shmlog-size 0) ;;
        jwm) dbus_args+=(jwm) ;;
        kde) dbus_args+=(startkde) ;;
        lxde) dbus_args+=(startlxde) ;;
        lxqt) dbus_args+=(lxqt-session) ;;
        mate) dbus_args+=(mate-session) ;;
        xfce) dbus_args+=(xfce4-session) ;;
        openbox) dbus_args+=(openbox-session) ;;
        *) dbus_args+=("$SESSION") ;; # Default to user-specified session
    esac

    echo "dbus-launch ${dbus_args[*]}"
}

# Start the session
exec "$(get_session)"
