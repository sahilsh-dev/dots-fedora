#!/bin/bash 

#run "xrandr" --output DisplayPort-0 --off --output DisplayPort-1 --off --output DisplayPort-2 --off --output HDMI-A-2 --primary --mode 1920x1080 --pos 1280x0 --rotate normal --output DVI-D-0 --off --output VGA-1-1 --mode 1280x1024 --pos 0x169 --rotate normal --output HDMI-1-1 --off --output HDMI-1-2 --off

eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK 
dbus-update-activation-environment --all
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
# gnome-keyring-daemon --start --components=secrets

setxkbmap -option "caps:swapescape"
picom -b
nitrogen --restore &
xset b off
xclip &
thunar --daemon &
nm-applet &

killall redshift
redshift -l 30.7046:76.7179 &
thunderbird &
