# box64-debs

This is a simple Debian repository for the [box64](https://github.com/ptitSeb/box64) project. New versions are compiled every 24 hours if a new commit on box64's repository has been made, you can find all the debs here: https://github.com/Pi-Apps-Coders/box64-debs/commits/master

These debs have been compiled using various target CPUs and systems. You can see all the available pkgs below.

## Package List

Package Name | Notes | Install Command |
------------ | ------------- | ------------- |
| box64-rpi4arm64 | box64 built for RPI4ARM64 target. | `sudo apt install box64-rpi4arm64` |
| box64-rpi3arm64 | box64 built for RPI3ARM64 target. | `sudo apt install box64-rpi3arm64` |
| box64-generic-arm | box64 built for generic ARM systems. | `sudo apt install box64-generic-arm` |
| box64-tegrax1 | box64 built for Tegra X1 systems. | `sudo apt install box64-tegrax1` |
| box64-rk3399 | box64 built for rk3399 cpu target. | `sudo apt install box64-rk3399` |
| box64-android | box64 built with the `-DBAD_SIGNAL=ON` flag | `sudo apt install box64-android` |

Want me to build for more platforms? Open an issue. 

### Repository installation
Involves adding .list file and gpg key for added security.
```
sudo wget https://Pi-Apps-Coders.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list
wget -qO- https://Pi-Apps-Coders.github.io/box64-debs/KEY.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg 
sudo apt update && sudo apt install box64-rpi4arm64 -y
```

If you don't want to add this apt repository to your system, you can download and install the latest arm64 deb from [here](https://github.com/Pi-Apps-Coders/box64-debs/tree/master/debian).

### Note for box86

Please note that this repository is *only for box64*. If you would like deb packages for box86, check out [box86-debs](https://github.com/Pi-Apps-Coders/box86-debs)
