#!/bin/bash
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $SCRIPT_PATH/utils.bash

ROOT_PATH="$(dirname $SCRIPT_PATH)"
RESOURCES_PATH="$ROOT_PATH/resources"
TEMPLATES_PATH="$ROOT_PATH/templates"
INSTALL_DIR="$ROOT_PATH/test"
MODE=${1:-online}
BASE_PACKAGE_NAME="org.rosindustrial.qtros"
PACKAGE_NAME="latest"

CONFIG_PATH="$INSTALL_DIR/config"
BASE_PACKAGE_PATH="$INSTALL_DIR/packages/$BASE_PACKAGE_NAME"
PACKAGE_PATH="$INSTALL_DIR/packages/$BASE_PACKAGE_NAME.$PACKAGE_NAME"

pretty_header "Parameters"
pretty_print "mode: $MODE"
pretty_print "INSTALL_DIR: $INSTALL_DIR"
pretty_print "CONFIG_PATH: $CONFIG_PATH"
pretty_print "BASE_PACKAGE_PATH: $BASE_PACKAGE_PATH"
pretty_print "PACKAGE_PATH: $PACKAGE_PATH"

# Creates folders
pretty_header "Creating folders"
mkdir -p "$CONFIG_PATH"
mkdir -p "$BASE_PACKAGE_PATH/meta"
mkdir -p "$PACKAGE_PATH/data"
mkdir -p "$PACKAGE_PATH/meta"
mkdir -p "$PACKAGE_PATH.rqtc/data"
mkdir -p "$PACKAGE_PATH.rqtc/meta"

# Config
pretty_header "Config"
pretty_print "config.xml"
cat $TEMPLATES_PATH/config.$MODE.xml > "$CONFIG_PATH/config.xml"

# Root package
pretty_header "Root package"
pretty_print "package.xml"
cat $TEMPLATES_PATH/package.root.xml > "$BASE_PACKAGE_PATH/meta/package.xml"

pretty_print "copying resources"
cp $RESOURCES_PATH/LICENSE.GPL3-EXCEPT $BASE_PACKAGE_PATH/meta/LICENSE.GPL3-EXCEPT
cp $RESOURCES_PATH/LICENSE.APACHE $BASE_PACKAGE_PATH/meta/LICENSE.APACHE
cp $RESOURCES_PATH/page.ui $BASE_PACKAGE_PATH/meta/page.ui

# QtCreator
pretty_header "QtCreator package"
pretty_print "package.xml"
cat $TEMPLATES_PATH/package.qtc.xml > "$BASE_PACKAGE_PATH/meta/package.xml"
pretty_print "installscript.qs"
cat $TEMPLATES_PATH/installscript.qs > "$BASE_PACKAGE_PATH/meta/installscript.qs"
pretty_print "move qtcreator.7z to data"
cd $BASE_PATH
mv qtcreator.7z $INSTALL_PATH/packages/$BASE_PACKAGE_NAME.$PACKAGE_NAME/data/

# Plugin
pretty_header "ROS QTC package"
pretty_print "package.xml"
cat $TEMPLATES_PATH/package.ros.xml > "$BASE_PACKAGE_PATH.rqtc/meta/package.xml"
