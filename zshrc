alias dl="youtube-dl -x --audio-format mp3 -o '%(title)s.%(ext)s'"
alias bl="bluetoothctl power on"

alias um="udisksctl mount -b /dev/sdb1"
alias uu="udisksctl unmount -b /dev/sdb1"
alias pm="aft-mtp-mount ~/static/media"
alias pu="fusermount -u ~/static/media"

alias uw="doas systemctl start wg-quick-wg0.service"
alias dw="doas systemctl stop wg-quick-wg0.service"


if [ $(tty) = /dev/tty1 ]; then
	exec sway
fi
