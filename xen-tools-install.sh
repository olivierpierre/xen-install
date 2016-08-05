#!/bin/bash
set -euf -o pipefail

# Git branch / tag to checkout before install
XTOOLS_CO="release-4.6.2"
# Git repo of xen-tools
XTOOLS_GIT="https://github.com/xen-tools/xen-tools.git"

# Prerequisites
sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get install -y perl debootstrap git liblog-message-perl bridge-utils

yes | sudo cpan install Config::IniFiles Text::Template Data::Validate::Domain Data::Validate::IP Data::Validate::URI File::Slurp File::Which Sort::Versions || true

git clone $XTOOLS_GIT
cd xen-tools && git checkout $XTOOLS_CO && cd -

sudo make install -C xen-tools
