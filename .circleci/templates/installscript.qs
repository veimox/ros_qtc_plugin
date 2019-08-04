function Component()
{
}

Component.prototype.createOperations = function()
{
    // Call the base createOperations and afterwards set some registry settings
    component.createOperations();
    if ( installer.value("os") == "x11" )
    {
        component.addOperation("CreateLink", "@HomeDir@/.local/bin/$COMMANDLINE_NAME", "@TargetDir@/$INSTALL_DIR/bin/qtcreator");
        component.addOperation("CreateLink", "@TargetDir@/$INSTALL_DIR/bin/$COMMANDLINE_NAME", "@TargetDir@/$INSTALL_DIR/bin/qtcreator");
        component.addOperation( "InstallIcons", "@TargetDir@/$INSTALL_DIR/share/icons" );
        component.addOperation( "CreateDesktopEntry",
                                "QtProject-qtcreator-ros-$PACKAGE_NAME.desktop",
                                "Type=Application\nExec=@TargetDir@/$INSTALL_DIR/bin/$COMMANDLINE_NAME\nPath=@TargetDir@/$INSTALL_DIR\nName=Qt Creator ($QTC_MINOR_VERSION)\nGenericName=The IDE of choice for Qt development.\nGenericName[de]=Die IDE der Wahl zur Qt Entwicklung\nIcon=QtProject-qtcreator\nTerminal=false\nCategories=Development;IDE;Qt;\nMimeType=text/x-c++src;text/x-c++hdr;text/x-xsrc;application/x-designer;application/vnd.qt.qmakeprofile;application/vnd.qt.xml.resource;text/x-qml;text/x-qt.qml;text/x-qt.qbs;"
                                );
        component.addOperation("CreateLink", "@HomeDir@/Desktop/QtProject-qtcreator-ros-$PACKAGE_NAME.desktop", "@HomeDir@/.local/share/applications/QtProject-qtcreator-ros-$PACKAGE_NAME.desktop");
        maintenanceToolPath = "@TargetDir@/MaintenanceTool";
        var settingsFile = "@TargetDir@/$INSTALL_DIR/share/qtcreator/QtProject/QtCreator.ini";
        
        // Configure UpdateInfo plugin
        component.addOperation("Settings", "path="+settingsFile, "method=set",
                               "key=Updater/MaintenanceTool",
                               "value="+maintenanceToolPath);
        component.addOperation("Settings", "path="+settingsFile,
                               "method=add_array_value",
                               "key=Plugins/ForceEnabled", "value=UpdateInfo");
        
    }
}