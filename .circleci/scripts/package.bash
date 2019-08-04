#!/bin/bash
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $SCRIPT_PATH/utils.bash

ROOT_PATH="$(dirname $SCRIPT_PATH)"
RESOURCES_PATH="$ROOT_PATH/resources"
TEMPLATES_PATH="$ROOT_PATH/templates"
MODE=${1:-online}
export BASE_PACKAGE_NAME="org.rosindustrial.qtros"
export DISTRO=(`lsb_release -cs`)

RQTC_INSTALL_DIR="rqtc_install"
RQTC_INSTALL_PATH="$BASE_PATH/$RQTC_INSTALL_DIR/$INSTALL_DIR"

export INSTALL_DIR="latest"
export PACKAGE_NAME="latest"

INSTALLER_DIR_PATH="$BASE_PATH/installer"
CONFIG_PATH="$INSTALLER_DIR_PATH/$DISTRO/$INSTALL_DIR/config"
BASE_PACKAGE_PATH="$INSTALLER_DIR_PATH/$DISTRO/$INSTALL_DIR/packages/$BASE_PACKAGE_NAME"
QTC_PACKAGE_PATH="$BASE_PACKAGE_PATH.$PACKAGE_NAME"
RQTC_PACKAGE_PATH="$QTC_PACKAGE_PATH.rqtc"


# Get Qt Creator Major and Minor Version
PVersion=(`echo $QTC_VERSION | tr '.' ' '`)
export QTC_MAJOR_VERSION=${PVersion[0]}.${PVersion[1]}
export QTC_MINOR_VERSION=${PVersion[0]}.${PVersion[1]}.${PVersion[2]}

# Get ROS Plugin Major and Minor Version
export RQTC_VERSION="0.3.0.0"
RVersion=(`echo $RQTC_VERSION | tr '.' ' '`)
export RQTC_MAJOR_VERSION=${RVersion[0]}.${RVersion[1]}
export RQTC_MINOR_VERSION=${RVersion[0]}.${RVersion[1]}.${RVersion[2]}

# Template variables
export INSTALLER_VERSION="1.0.2"
export INSTALLER_RELEASE_DATE="2018-11-27"
export QTC_DISPLAY_NAME="Qt Creator ($QTC_MINOR_VERSION)"
export QTC_RELEASE_DATE="2018-10-23"
export RQTC_RELEASE_DATE="2018-11-26"
export COMMANDLINE_NAME="qtcreator-ros"

pretty_header "Parameters"
pretty_print "MODE: $MODE"
pretty_print "INSTALL_DIR: $INSTALL_DIR"
pretty_print "CONFIG_PATH: $CONFIG_PATH"
pretty_print "BASE_PACKAGE_PATH: $BASE_PACKAGE_PATH"
pretty_print "PACKAGE_PATH: $QTC_PACKAGE_PATH"
pretty_print "DISTRO: $DISTRO"
pretty_print "INSTALLER_DIR_PATH: $INSTALLER_DIR_PATH"

##############
## Metadata ##
##############
# Creates folders
pretty_header "Create installer metadata"
pretty_print "Creating folders"
mkdir -p "$CONFIG_PATH"
mkdir -p "$BASE_PACKAGE_PATH/meta"
mkdir -p "$QTC_PACKAGE_PATH/data"
mkdir -p "$QTC_PACKAGE_PATH/meta"
mkdir -p "$RQTC_PACKAGE_PATH/data"
mkdir -p "$RQTC_PACKAGE_PATH/meta"

# Config
pretty_print "config.xml"
envsubst < $TEMPLATES_PATH/config.$MODE.xml > "$CONFIG_PATH/config.xml"

# Base package
pretty_print "base package.xml"
envsubst < $TEMPLATES_PATH/package.base.xml > "$BASE_PACKAGE_PATH/meta/package.xml"

pretty_print "copy base resources"
cp $RESOURCES_PATH/LICENSE.GPL3-EXCEPT $BASE_PACKAGE_PATH/meta/LICENSE.GPL3-EXCEPT
cp $RESOURCES_PATH/LICENSE.APACHE $BASE_PACKAGE_PATH/meta/LICENSE.APACHE
cp $RESOURCES_PATH/page.ui $BASE_PACKAGE_PATH/meta/page.ui

# QtCreator
pretty_print "qtcreator package.xml"
envsubst < $TEMPLATES_PATH/package.qtc.xml > "$QTC_PACKAGE_PATH/meta/package.xml"
pretty_print "qtcreator installscript.qs"
envsubst < $TEMPLATES_PATH/installscript.qs > "$QTC_PACKAGE_PATH/meta/installscript.qs"

# Plugin
pretty_print "plugin package.xml"
envsubst < $TEMPLATES_PATH/package.rqtc.xml > "$RQTC_PACKAGE_PATH/meta/package.xml"


####################
## Plugin packing ##
####################
pretty_header "Pack ROS QTC plugin"
pretty_print "copy ROS QTC plugin"
mkdir -p $RQTC_INSTALL_PATH/lib/qtcreator/plugins
cp $QTC_INSTALL_PATH/lib/qtcreator/plugins/libROSProjectManager.so $RQTC_INSTALL_PATH/lib/qtcreator/plugins
mkdir -p $RQTC_INSTALL_PATH/share/qtcreator
cp -r $BASE_PATH/ros_qtc_plugin/share/styles $RQTC_INSTALL_PATH/share/qtcreator
cp -r $BASE_PATH/ros_qtc_plugin/share/templates $RQTC_INSTALL_PATH/share/qtcreator

pretty_print "copy QTermWidget plugin"
cp $QTC_INSTALL_PATH/lib/qtcreator/libqtermwidget5.so* $RQTC_INSTALL_PATH/lib/qtcreator
## qtermwidget looks for the color-schemes and kb-layouts directory in the same path as the executable
mkdir -p $RQTC_INSTALL_PATH/bin
cp -R $BASE_PATH/qtermwidget/lib/color-schemes $RQTC_INSTALL_PATH/bin
cp -R $BASE_PATH/qtermwidget/lib/kb-layouts $RQTC_INSTALL_PATH/bin

pretty_print "copy YamlCPP plugin"
cp $QTC_INSTALL_PATH/lib/qtcreator/libyaml-cpp.so* $RQTC_INSTALL_PATH/lib/qtcreator

pretty_print "package plugin"
cd $BASE_PATH/$RQTC_INSTALL_DIR/
7zr a -r $BASE_PATH/qtcreator_ros_plugin.7z $INSTALL_DIR


###############
## Installer ##
###############
pretty_header "Create installers"
pretty_print "moving qtcreator.7z to $QTC_PACKAGE_PATH/data"
cp $BASE_PATH/qtcreator.7z $QTC_PACKAGE_PATH/data
pretty_print "moving qtcreator_ros_plugin.7z to $RQTC_PACKAGE_PATH/data"
cp $BASE_PATH/qtcreator_ros_plugin.7z $RQTC_PACKAGE_PATH/data
pretty_print "create offline binary"
cd $INSTALLER_DIR_PATH/$DISTRO/$INSTALL_DIR
binarycreator -f -c config/config.xml -p packages qtcreator-ros-$DISTRO-$PACKAGE_NAME-offline-installer.run
if [[ $MODE -eq "online" ]]; then
	pretty_print "create online binary"
    binarycreator -n -c config/config.xml -p packages qtcreator-ros-$DISTRO-$PACKAGE_NAME-online-installer.run
fi