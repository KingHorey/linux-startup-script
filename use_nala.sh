#!/usr/bin/bash

[[ -$EUID -eq 0 ]] || echo "Run as sudo"; exit 1 && use_nala


use_nala() {
	apt()
	{
	command nala "$@"
	}

	sudo()
	{
	if [ $1 == "apt" ];
	then
		shift
		command sudo nala "$@"
	else
		command sudo "$@"
	fi
	}
}

save_nala() {
	cat <<EOF >> ~/.bashrc 
	$(declare -f use_nala)
	use_nala
	$(echo "success")
	EOF

}
