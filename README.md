# box64-debs

This is a simple Debian repository for the [box64](https://github.com/ptitSeb/box64) project. New versions are compiled when a new release is made on box64's repository. The debs are available in the debian folder: https://github.com/atoll6/box64-debs/tree/main/debian

These debs have been compiled for the RPI5ARM64 target.

### Repository Installation
Involves adding .sources file and GPG key for added security.
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
wget -qO- "https://atoll6.github.io/box64-debs/KEY.gpg" | sudo gpg --dearmor -o /usr/share/keyrings/box64-archive-keyring.gpg
# create .sources file
echo "Types: deb
URIs: https://atoll6.github.io/box64-debs/debian
Suites: ./
Signed-By: /usr/share/keyrings/box64-archive-keyring.gpg" | sudo tee /etc/apt/sources.list.d/box64.sources >/dev/null
sudo apt update
sudo apt install box64-rpi5arm64 -y
```

If you don't want to add this apt repository to your system, you can download and install the latest arm64 deb from [here](https://github.com/atoll6/box64-debs/tree/main/debian).

### Direct Download Instructions
1. Go to the [debian folder](https://github.com/atoll6/box64-debs/tree/main/debian).
2. Download the latest `box64-rpi5arm64_*.deb` file.
3. Install it with: `sudo dpkg -i box64-rpi5arm64_*.deb`
4. Fix any dependencies: `sudo apt install -f`
