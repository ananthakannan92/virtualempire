 #!/usr/bin/env bash

 # Execute this file to install the virtualempire cli tools into your path on OS X

 CURRENT_LOC="$( cd "$(dirname "$0")" ; pwd -P )"
 LOCATION=${CURRENT_LOC%Virtualempire-Qt.app*}

 # Ensure that the directory to symlink to exists
 sudo mkdir -p /usr/local/bin

 # Create symlinks to the cli tools
 sudo ln -s ${LOCATION}/Virtualempire-Qt.app/Contents/MacOS/virtualempired /usr/local/bin/virtualempired
 sudo ln -s ${LOCATION}/Virtualempire-Qt.app/Contents/MacOS/virtualempire-cli /usr/local/bin/virtualempire-cli
