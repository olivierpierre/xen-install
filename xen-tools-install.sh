#!/bin/bash
set -euf -o pipefail

XTOOLS_GIT="https://github.com/xen-tools/xen-tools.git"
XTOOLS_CO="release-4.6.2"

# Prerequisites
sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get install -y perl debootstrap git liblog-message-perl bridge-utils

yes | sudo cpan install Config::IniFiles Text::Template Data::Validate::Domain Data::Validate::IP Data::Validate::URI File::Slurp File::Which Sort::Versions || true

git clone $XTOOLS_GIT
cd xen-tools && git checkout $XTOOLS_CO && cd -

sudo make install -C xen-tools
