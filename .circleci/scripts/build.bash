#!/bin/bash
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $SCRIPT_PATH/utils.bash

cd $BASE_PATH

pretty_header "Building"
pretty_print "Creating build folder"
mkdir -p ros_qtc_plugin-build
cd $BASE_PATH/ros_qtc_plugin-build
pretty_print "Running qmake"
qmake ../ros_qtc_plugin/ros_qtc_plugin.pro -r 
pretty_print "Making"
make || exit 1
make install

# Next change the rpath to use the local Qt Libraries copied into the Qt Creator Directory
pretty_print "Update Rpath"
chrpath -r \$\ORIGIN:\$\ORIGIN/..:\$\ORIGIN/../lib/qtcreator:\$\ORIGIN/../../Qt/lib $QTC_INSTALL_PATH/lib/qtcreator/plugins/libROSProjectManager.so
