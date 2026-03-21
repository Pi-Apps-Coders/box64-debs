# box64-debs

This is a simple Debian repository for the [box64](https://github.com/ptitSeb/box64) project. New versions are compiled every 24 hours if a new commit on box64's repository has been made, you can find all the debs here: https://github.com/Pi-Apps-Coders/box64-debs/commits/master

These debs have been compiled using various target CPUs and systems. You can see all the available pkgs below.

## Package List

Package Name | Notes | Install Command |
------------ | ------------- | ------------- |
| box64-rpi5arm64 | box64 built for RPI5ARM64 target. | `sudo apt install box64-rpi5arm64` |
| box64-rpi4arm64 | box64 built for RPI4ARM64 target. | `sudo apt install box64-rpi4arm64` |
| box64-rpi3arm64 | box64 built for RPI3ARM64 target. | `sudo apt install box64-rpi3arm64` |
| box64-generic-arm | box64 built for generic ARM systems. | `sudo apt install box64-generic-arm` |
| box64-tegrax1 | box64 built for Tegra X1 systems. | `sudo apt install box64-tegrax1` |
| box64-rk3399 | box64 built for rk3399 cpu target. | `sudo apt install box64-rk3399` |
| box64-android | box64 built with the `-DBAD_SIGNAL=ON` flag | `sudo apt install box64-android` |

Want me to build for more platforms? Open an issue. 

### Repository installation
Involves adding .sources file and gpg key for added security.
```
# check if .list file already exists
if [ -f /etc/apt/sources.list.d/box64.list ]; then
  sudo rm -f /etc/apt/sources.list.d/box64.list || exit 1
fi
# check if .sources file already exists
if [ -f /etc/apt/sources.list.d/box64.sources ]; then
  sudo rm -f /etc/apt/sources.list.d/box64.sources || exit 1
fi
# download gpg key from specified url
if [ -f /usr/share/keyrings/box64-archive-keyring.gpg ]; then
  sudo rm -f /usr/share/keyrings/box64-archive-keyring.gpg
fi
sudo mkdir -p /usr/share/keyrings
wget -qO- "https://pi-apps-coders.github.io/box64-debs/KEY.gpg" | sudo gpg --dearmor -o /usr/share/keyrings/box64-archive-keyring.gpg
# create .sources file
echo "Types: deb
URIs: https://Pi-Apps-Coders.github.io/box64-debs/debian
Suites: ./
Signed-By: /usr/share/keyrings/box64-archive-keyring.gpg" | sudo tee /etc/apt/sources.list.d/box64.sources >/dev/null
sudo apt update
sudo apt install box64-generic-arm -y
```

If you don't want to add this apt repository to your system, you can download and install the latest arm64 deb from [here](https://github.com/Pi-Apps-Coders/box64-debs/tree/master/debian).

### Note for box86

Please note that this repository is *only for box64*. If you would like deb packages for box86, check out [box86-debs](https://github.com/Pi-Apps-Coders/box86-debs)
