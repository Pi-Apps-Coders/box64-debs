#!/bin/bash

[ -z "$DIRECTORY" ] && DIRECTORY="/github/workspace"
DEBIAN_FRONTEND=noninteractive

LATESTCOMMIT=`cat $DIRECTORY/commit.txt`

function error() {
	echo -e "\e[91m$1\e[39m"
    rm -f $COMMITFILE
    rm -rf $DIRECTORY/box64
	exit 1
 	break
}

rm -rf $DIRECTORY/box64

cd $DIRECTORY

# install dependencies
apt-get update
apt-get install wget git build-essential gcc-8 python3 make gettext pinentry-tty sudo devscripts dpkg-dev cmake -y || error "Failed to install dependencies"
git clone https://github.com/giuliomoro/checkinstall || error "Failed to clone checkinstall repo"
cd checkinstall
sudo make install || error "Failed to run make install for Checkinstall!"
cd .. && rm -rf checkinstall

rm -rf box64

git clone https://github.com/ptitSeb/box64 || error "Failed to download box64 repo"
cd box64
commit="$(bash -c 'git rev-parse HEAD | cut -c 1-7')"
if [ "$commit" == "$LATESTCOMMIT" ]; then
  cd "$DIRECTORY"
  rm -rf "box64"
  echo "box64 is already up to date. Exiting."
  touch exited_successfully.txt
  exit 0
fi
echo "box64 is not the latest version, compiling now."
echo $commit > $DIRECTORY/commit.txt
echo "Wrote commit to commit.txt file for use during the next compilation."

targets=(GENERIC_ARM ANDROID RPI4ARM64 RPI3ARM64 TEGRAX1 RK3399)

for target in ${targets[@]}; do

  cd $DIRECTORY/box64
  sudo rm -rf build && mkdir build && cd build || error "Could not move to build directory"
  if [[ $target == "ANDROID" ]]; then
    cmake .. -DBAD_SIGNAL=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_C_COMPILER=aarch64-linux-gnu-gcc-8 -DARM_DYNAREC=ON || error "Failed to run cmake."
  elif [[ $target == "GENERIC_ARM" ]]; then
    cmake .. -DARM64=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_C_COMPILER=aarch64-linux-gnu-gcc-8 -DARM_DYNAREC=ON || error "Failed to run cmake."
  else
    cmake .. -D$target=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_C_COMPILER=aarch64-linux-gnu-gcc-8 -DARM_DYNAREC=ON || error "Failed to run cmake."
  fi
  make -j4 || error "Failed to run make."

  function get-box64-version() {
    if [[ $1 == "ver" ]]; then
      export box64VER="$(cat ../src/box64version.h | sed -n -e 's/^.*BOX64_MAJOR //p')"."$(cat ../src/box64version.h | sed -n -e 's/^.*BOX64_MINOR //p')"."$(cat ../src/box64version.h | sed -n -e 's/^.*BOX64_REVISION //p')"
    elif [[ $1 == "commit" ]]; then
      export box64COMMIT="$commit"
    fi
  }

  get-box64-version ver  || error "Failed to get box64 version!"
  get-box64-version commit || error "Failed to get box64 commit!"
  DEBVER="$(echo "$box64VER+$(date -u +"%Y%m%dT%H%M%S").$box64COMMIT")" || error "Failed to set debver variable."

  mkdir doc-pak || error "Failed to create doc-pak dir."
  cp ../docs/README.md ./doc-pak || warning "Failed to add README to docs"
  cp ../docs/CHANGELOG.md ./doc-pak || error "Failed to add CHANGELOG to docs"
  cp ../docs/USAGE.md ./doc-pak || error "Failed to add USAGE to docs"
  cp ../LICENSE ./doc-pak || error "Failed to add LICENSE to docs"
  echo "Box64 lets you run x86_64 Linux programs (such as games) on non-x86_64 Linux systems, like ARM (host system needs to be 64bit little-endian)">description-pak || error "Failed to create description-pak."
  echo '#!/bin/bash
warning() { #yellow text
  echo -e "\e[93m\e[5m◢◣\e[25m WARNING: $1\e[0m" 1>&2
}
# do not touch binfmts inside a container
if command -v systemd-detect-virt >/dev/null; then
  if systemd-detect-virt --quiet --container ; then
    warning "Registering a binfmt cannot be done in a container. This means Box64 will not be automatically summoned to run x86_64 code, breaking some apps that use it including Steam."
    exit 0
  fi
fi
if grep -zqs ^container= /proc/1/environ; then
  warning "Registering a binfmt cannot be done in a container. This means Box64 will not be automatically summoned to run x86_64 code, breaking some apps that use it including Steam."
  exit 0
fi
systemctl restart systemd-binfmt || warning "Restarting systemd-binfmt failed. This means Box64 will not be automatically summoned to run x86_64 code, breaking some apps that use it including Steam."' > postinstall-pak || error "Failed to create postinstall-pak!"

  conflict_list="qemu-user-static, box64, box64-generic-arm-page16k"
  for value in "${targets[@]}"; do
    if [[ $value != $target ]]; then
      conflict_list+=", box64-$(echo $value | tr '[:upper:]' '[:lower:]' | tr _ - | sed -r 's/ /, /g')"
    fi
  done
  sudo checkinstall -y -D --maintainer="dofficialgman@gmail.com" --pkgversion="$DEBVER" --arch="arm64" --provides="box64" --conflicts="$conflict_list" --pkgname="box64-$target" --install="no" make install || error "Checkinstall failed to create a deb package."

  cd $DIRECTORY
  mkdir -p debian
  mv box64/build/*.deb ./debian/ || error "Failed to move deb to debian folder."

done

# only keep last 4 debs for each target
# keeps github pages builds fast and below 1GB suggested limit
cd $DIRECTORY
ls ./debian/box64-*.deb | sort -t '+' -k 2 | head -n -24 | xargs -r rm

rm -rf $DIRECTORY/box64

echo "Script complete."
