# ubuntu dockerfile is very minimal (only 122 packages are installed)
# add dependencies expected by scripts
apt update
apt install -y software-properties-common lsb-release \
sudo wget curl build-essential jq autoconf automake \
pkg-config ca-certificates rpm apt-utils \
python3 make gettext pinentry-tty devscripts dpkg-dev
# install new enough git to run actions/checkout
sudo add-apt-repository ppa:git-core/ppa -y
sudo add-apt-repository ppa:theofficialgman/cmake-bionic -y
sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
sudo apt update
sudo apt install -y git cmake gcc-13 g++-13
# avoid "fatal: detected dubious ownership in repository" error
git config --global --add safe.directory '*'

# build and package
./create-deb.sh
