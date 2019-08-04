#!/bin/bash
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $SCRIPT_PATH/utils.bash

# Move the repo to the working folder
mv $HOME/$CIRCLECI_PROJECT_REPONAME $BASE_PATH/ros_qtc_plugin
cd $BASE_PATH

mkdir ros_qtc_plugin-build
cd $BASE_PATH/ros_qtc_plugin-build
qmake ../ros_qtc_plugin/ros_qtc_plugin.pro -r 
make -j8$(nproc) || exit 1

# Next change the rpath to use the local Qt Libraries copied into the Qt Creator Directory
chrpath -r \$\ORIGIN:\$\ORIGIN/..:\$\ORIGIN/../lib/qtcreator:\$\ORIGIN/../../Qt/lib $BASE_PATH/$INSTALL_DIR/lib/qtcreator/plugins/libROSProjectManager.so  
