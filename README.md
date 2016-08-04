# xen-install
Script to quickly compile and install Xen from sources on a Ubuntu / Debian system

## Pre-requisites
Debian / Ubuntu & root access.

## Usage
1. Edit the variables at the begnining of the script code to choose the branch / tag that will be checked out on Xen git repo, and also some various options.
2. Run `./xen-install.sh`, the computer will reboot automatically at the end of the procedure.

## Installing xen-tools
There is another script to install xen-tools. It can be edited in the same way as the first one and launched like this: `xen-tools-install.sh`.
