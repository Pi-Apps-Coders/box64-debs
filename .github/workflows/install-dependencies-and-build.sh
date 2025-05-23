# ubuntu dockerfile is very minimal (only 122 packages are installed)
# add dependencies expected by scripts
apt update
apt install -y software-properties-common lsb-release \
sudo wget curl build-essential jq autoconf automake \
pkg-config ca-certificates rpm apt-utils \
python3 make gettext pinentry-tty devscripts dpkg-dev \
gcc-8 g++-8
# install new enough git to run actions/checkout
sudo add-apt-repository ppa:git-core/ppa -y
sudo add-apt-repository ppa:theofficialgman/cmake-bionic -y
sudo apt update
sudo apt install -y git cmake
# avoid "fatal: detected dubious ownership in repository" error
git config --global --add safe.directory '*'

# build and package
./create-deb.sh
