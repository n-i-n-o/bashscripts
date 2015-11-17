#!/bin/bash 

## Upgrades to Kernel 4.2 → Tested on Debian 8 | Ubuntu 15.04 (both x64)
## remove the echo's in nested if-loop when ready to implement and after verfiying script is functioning

if [[ $UID == 0 ]]; then
	echo -e "\e[1m[*] Preparing for essential build up → takes a while\e[0m"
	apt-get install git fakeroot build-essential ncurses-dev xz-utils -qq -y --force-yes && apt-get --no-install-recommends install kernel-package -qq -y --force-yes || { echo -e "\e[1m[!] Quitting!\e[0m">&2; exit 1; }
else
	echo -e"\e[1m[!] Need to be root → no sudo\e[0m"
	exit 1
fi
echo -e "\e[1m[*] Done! \e[0m"
echo -e "\e[1m[*] Downloading new kernel into tarball ...\e[0m"
sleep 1s
wget -q --show-progress https://www.kernel.org/pub/linux/kernel/v4.x/linux-4.2.5.tar.xz || { echo -e "\e[1m[!] Didn't get it\e[0m" >&2; exit 1; }
echo -e "\e[1m[*] Got it!\e[0m"
echo -e "\e[1m[*] Extracting tarball ... \e[0m"
sleep 1
tar --checkpoint=.1000 -xf linux-4.2.5.tar.xz || { echo -e "\e[1m[*] Error\e[0m" >&2; exit 1; }
sleep 1s
echo
echo -e "\e[1m[*] Moving into the directory\e[0m"
echo -e "\e[1m    Kernel options menus will pop up → make sure to save options before exiting \e[0m"
dir_name="linux-4.2.5"
sleep 1s
if [[ -d $dir_name ]]; then
	if cd $dir_name; then
		echo "cp /boot/config-$(uname -r) .config"
		echo -e "\e[1m[*] Copied origianl kernel config successfully\e[0m"
		echo "make menuconfig"
		echo -e "\e[1m[*] Cleaning up source tree and getting ready for install\e[0m"
		echo "make-kpkg clean"
		echo
		echo -e "\e[1m[*] Just leave, don't start watching porn, we need the CPU and memory resources, this is gonna take a long time\e[0m"
		echo
		sleep 2
		echo "fakeroot make-kpkg --initrd --revision=1.0.NAS kernel_image kernel_headers"
	else
		echo -e "\e[1[!] ERROR\e[0m" >&2
		exit 1
	fi
else											
	echo -e "\e[1m[!] Where is the directory¿?\e[0m" >&2				     
	exit 1
fi

echo -e "\e[1m[*] Almost finished, installing last pieces ...\e[0m"
dpkg -i linux-headers-4.2.5_1.0.NAS_amd64.deb 2>/dev/null && dpkg -i linux-image-4.2.5_1.0.NAS_amd64.deb 2>/dev/null  || { echo -e "\e[1m[!] Why are you seeing this¿?\e[0m" >&2; exit 1; }

echo "e[1m[*] Successful install → rebooting in 20 seconds ...\e[0m"
sleep 20s && shutdown -r now
exit 0
